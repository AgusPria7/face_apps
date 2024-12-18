import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:face_apps/page/absen/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;

class RegistrasiPage extends StatefulWidget {
  final XFile? image;
  final List<double>? faceEmbedding;

  const RegistrasiPage({super.key, this.image, this.faceEmbedding});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState(this.image, this.faceEmbedding);
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  _RegistrasiPageState(this.image, this.faceEmbedding);

  XFile? image;
  List<double>? faceEmbedding;
  String strAlamat = "";
  bool isLoading = false;
  final controllerName = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (image != null) {
      isLoading = true;
      getGeoLocationPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF001845),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Menu Registrasi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.teal,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.face_retouching_natural_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Foto Selfie ya!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text(
                  "Ambil Foto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CameraAbsenPage()));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  width: double.infinity,
                  height: 180,
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    color: Colors.teal,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: image != null
                            ? Image.file(File(image!.path), fit: BoxFit.cover)
                            : const Icon(
                          Icons.add_a_photo_outlined,
                          size: 48,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Masukan Nama Anda",
                    hintText: "Nama Anda",
                    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Lokasi Anda",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.teal,))
                  : Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 5 * 24,
                  child: TextField(
                    enabled: false,
                    maxLines: 5,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                      hintText: strAlamat != null ? strAlamat : 'Lokasi Kamu',
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal,
                      child: InkWell(
                        splashColor: Colors.pink,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (image == null || controllerName.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text("Ups, foto dan inputan tidak boleh kosong!",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              backgroundColor: Colors.redAccent,
                              shape: StadiumBorder(),
                              behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            submitRegistrasi(strAlamat, controllerName.text.toString());
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
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
    );
  }

  //get realtime location
  Future<void> getGeoLocationPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      isLoading = false;
      getAddressFromLongLat(position);
    });
  }

  //get address by lat long
  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      strAlamat =
      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  //submit data registrasi
  Future<void> submitRegistrasi(String nama, String location) async {
    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse("http://172.25.4.76/MRP/Xmx/absensi/save_registrasi");
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan data text
      request.fields['nama'] = nama;
      request.fields['location'] = location;

      // Tambahkan fitur wajah dalam format JSON
      if (faceEmbedding != null) {
        String jsonStr = jsonEncode(faceEmbedding);
        print("Data faceEmbedding yang dikirim: $jsonStr");
        request.fields['image_path'] = jsonStr;
      }

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(jsonResponse['message']),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error terjadi: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
