import 'dart:io';
import 'dart:convert'; // Untuk encoding base64
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool isCameraInitialized = false;
  bool isLoading = false;
  bool isValidationSuccess = false;
  String validationMessage = "";
  FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  // Fungsi untuk menginisialisasi kamera
  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      CameraDescription frontCamera = _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);
      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kamera tidak tersedia: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Fungsi untuk validasi wajah
  Future<void> validateFace() async {
    try {
      XFile image = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          isValidationSuccess = false;
          validationMessage = "Tidak ada wajah yang terdeteksi!";
        });
        return;
      }

      // Cek wajah yang terdeteksi dengan data yang ada di database
      bool isFaceRecognized = await validateWithDatabase(image.path);

      if (isFaceRecognized) {
        // Jika wajah cocok, centang hijau
        setState(() {
          isValidationSuccess = true;
          validationMessage = "Wajah dikenali, Absensi berhasil!";
        });

        // Simpan log kehadiran
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> attendanceLogs = prefs.getStringList('attendanceLogs') ?? [];
        String logEntry = 'Hadir pada: ${DateTime.now()}';
        attendanceLogs.add(logEntry);
        await prefs.setStringList('attendanceLogs', attendanceLogs);

        // Tunggu sebentar sebelum kembali ke menu utama
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      } else {
        // Jika wajah tidak cocok
        setState(() {
          isValidationSuccess = false;
          validationMessage = "Wajah tidak dikenali, coba lagi!";
        });
      }
    } catch (e) {
      setState(() {
        isValidationSuccess = false;
        validationMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  // Fungsi untuk mencocokkan wajah yang terdeteksi dengan database
  Future<bool> validateWithDatabase(String imagePath) async {
    try {
      // URL API backend untuk validasi wajah
      const String apiUrl = "http://172.25.4.76/MRP/Xmx/absensi/save_registrasi";

      // Baca file gambar dan konversi ke Base64
      final bytes = await File(imagePath).readAsBytes();
      final String base64Image = base64Encode(bytes);

      // Kirim permintaan POST ke backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image_data': base64Image, // Data gambar dalam Base64
        }),
      );

      if (response.statusCode == 200) {
        // Parsing respons dari server
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Periksa apakah wajah cocok
        return responseData['is_match'] == true;
      } else {
        // Tangani kesalahan dari server
        debugPrint('Server error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Tangani kesalahan lain, seperti koneksi gagal
      debugPrint('Error during face validation: $e');
      return false;
    }
  }

  @override
  void dispose() {
    if (isCameraInitialized) {
      _cameraController.dispose();
    }
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi Wajah"),
        backgroundColor: Colors.teal,
      ),
      body: isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_cameraController),
          if (isValidationSuccess)
            Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            ),
          if (!isValidationSuccess && validationMessage.isNotEmpty)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    validationMessage,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await initializeCamera();
                setState(() {
                  isLoading = false;
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Mulai Kamera",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isCameraInitialized
          ? FloatingActionButton(
        onPressed: validateFace,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.check),
      )
          : null,
    );
  }
}
