import 'dart:io';
import 'dart:math';
import 'dart:convert'; // For encoding base64
import 'dart:typed_data';
import 'package:face_apps/page/absen/registrasi_page.dart';
import 'package:face_apps/utils/facedetection/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class CameraAbsenPage extends StatefulWidget {
  const CameraAbsenPage({super.key});

  @override
  State<CameraAbsenPage> createState() => _State();
}

class _State extends State<CameraAbsenPage> with TickerProviderStateMixin {
  //set face detection
  late Interpreter _interpreter;
  late List<int> _inputShape;
  late List<double> _embedding;
  bool _isModelLoaded = false;
  bool _isInitializing = true;

  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    // enableLandmarks: true,
    // enableFaceNet: true,
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _checkDeviceArchitecture();
    _verifyTFLiteLocation();
    _initializeCamera();
    // loadCamera();
    // loadModel();
  }

  Future<void> _initializeCamera() async {
    setState(() => _isInitializing = true);
    try {
      await loadModel();
      await loadCamera();
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> loadModel() async {
    try {
      print("Starting model loading process...");

      // Add delay untuk memastikan sistem siap
      await Future.delayed(const Duration(seconds: 2));

      // Custom options
      final options = InterpreterOptions()
        ..threads = 2  // Kurangi thread
        ..useNnApiForAndroid = false;  // Disable NNAPI

      print("Attempting to load model...");
      _interpreter = await Interpreter.fromAsset(
        "assets/mobilefacenet.tflite",
        options: options,
      );

      print("Model loaded, getting input shape...");
      _inputShape = _interpreter.getInputTensor(0).shape;

      _isModelLoaded = true;
      print("Model fully loaded! Input shape: $_inputShape");
    } catch (e, stackTrace) {
      print("Detailed error loading model: $e");
      print("Stack trace: $stackTrace");
      _isModelLoaded = false;
    }
  }

  // Add this helper function
  Future<bool> _checkTFLiteExists() async {
    try {
      // Try loading interpreter without model to check library
      await Interpreter.fromAsset("assets/mobilefacenet.tflite");
      return true;
    } catch (e) {
      print("TFLite check error: $e");
      return false;
    }
  }

  void _checkDeviceArchitecture() {
    try {
      final result = Process.runSync('getprop', ['ro.product.cpu.abi']);
      print("Device architecture: ${result.stdout}");
    } catch (e) {
      print("Cannot determine device architecture: $e");
    }
  }

  Future<void> _verifyTFLiteLocation() async {
    try {
      // Cek lokasi package
      final packageInfo = await PackageInfo.fromPlatform();
      final packagePath = packageInfo.packageName;

      print("Package path: $packagePath");
      print("Expected TFLite location: /android/app/$packagePath/main/jniLibs/arm64-v8a/libtensorflowlite_jni.so");

      // Cek apakah file ada
      final file = File("/android/app/$packagePath/main/jniLibs/arm64-v8a/libtensorflowlite_jni.so");
      print("File exists: ${await file.exists()}");
    } catch (e) {
      print("Error checking TFLite location: $e");
    }
  }

  Future<List<double>?> _getFaceEmbedding(InputImage inputImage, Face face) async {
    if (!_isModelLoaded) {
      print("Model not loaded yet!");
      return null; // Or handle the error as needed
    }

    final bytes = inputImage.bytes;
    if (bytes == null) {
      return null;
    }

    final image = img.decodeImage(bytes);
    if (image == null) {
      return null;
    }
    try {
      final faceRect = face.boundingBox;
      final croppedImage = img.copyCrop(
          image, faceRect.left.toInt(), faceRect.top.toInt(),
          faceRect.width.toInt(), faceRect.height.toInt());
      final resizedImage = img.copyResize(
          croppedImage, width: _inputShape[1], height: _inputShape[2]);

      final inputBytes = resizedImage.getBytes();
      final input = Float32List(_inputShape[1] * _inputShape[2] * 3);
      const mean = 127.5;
      const std = 127.5;
      for (var i = 0; i < inputBytes.length; i++) {
        input[i] = (inputBytes[i] - mean) / std;
      }

      final output = List.generate(1, (i) =>
          Float32List(_interpreter
              .getOutputTensor(0)
              .shape[1]));
      _interpreter.run(
          [input.reshape([1, _inputShape[1], _inputShape[2], 3])], output);
      return output[0];
    } catch (e) {
      print("error get face embedding : $e");
      return null;
    }
  }

  // Set open front camera device
  // if 1 front, if 0 rear
  Future<void> loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      await controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.camera_enhance_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Ups, kamera tidak ditemukan!", style: TextStyle(color: Colors.white))
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //set loading
    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(Colors.pinkAccent)),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text("Sedang memeriksa data...")
            ),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Foto Selfie",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _isInitializing
          ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Memuat model face recognition...")
              ],
            ),
          )
      : Stack(
        children: [
          SizedBox(
              height: size.height,
              width: size.width,
              child: controller == null
                  ? const Center(child: Text("Ups, kamera bermasalah!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                  : !controller!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : CameraPreview(controller!)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Lottie.asset(
              "assets/raw/face_id_ring.json",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Pastikan Anda berada di tempat terang, agar wajah terlihat jelas.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.teal, // Button color
                        child: InkWell(
                          splashColor: Colors.pink, // Splash color
                          onTap: () async {
                            // Cek status model terlebih dahulu
                            if (!_isModelLoaded) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Mohon tunggu, model sedang dimuat..."),
                                backgroundColor: Colors.orange,
                              ));
                              return;
                            }
                            final hasPermission = await handleLocationPermission();
                            try {
                              if (controller != null) {
                                if (controller!.value.isInitialized) {
                                  controller!.setFlashMode(FlashMode.off);
                                  image = await controller!.takePicture();
                                  setState(() {
                                    if (hasPermission) {
                                      showLoaderDialog(context);
                                      final inputImage = InputImage.fromFilePath(image!.path);
                                      Platform.isAndroid ? processImage(inputImage) : Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => RegistrasiPage(image: image)));
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Nyalakan perizinan lokasi terlebih dahulu!",
                                              style: TextStyle(color: Colors.white),
                                            )
                                          ],
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        shape: StadiumBorder(),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  });
                                }
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("Ups, $e",
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                backgroundColor: Colors.redAccent,
                                shape: const StadiumBorder(),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          },
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Permission location
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location services are disabled. Please enable the services.",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text("Location permission denied.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Location permission denied forever, we cannot access.",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  // Face detection
  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;

    try {
      final faces = await faceDetector.processImage(inputImage);

      if (mounted) {
        if (faces.isNotEmpty) {
          final face = faces.first;
          final embedding = await _getFaceEmbedding(inputImage, face);

          if (embedding != null) {
            // Navigate outside of setState
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrasiPage(image: image, faceEmbedding: embedding),
              ),
            );
          } else {
            // Use setState for UI updates (SnackBar)
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Failed to extract face embedding."),
              ));
            });
          }
        } else {
          // Use setState for UI updates (SnackBar)
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No face detected."),
            ));
          });
        }
      }
    } catch (e) {
      print('Error processing image: $e');
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error processing image: $e"),
        ));
      });
    } finally {
      isBusy = false;
      if (mounted) {
        setState(() {
          Navigator.of(context).pop(); // Close the loading dialog
        });
      }
    }
  }

}

