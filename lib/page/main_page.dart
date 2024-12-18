import 'package:face_apps/page/absen/registrasi_page.dart';
import 'package:face_apps/page/absen/attendance_page.dart';
import 'package:face_apps/page/history/history_page.dart';
import 'package:face_apps/page/leave/leave_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6), // Warna latar belakang menarik
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Menu Utama",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(
                          context,
                          'assets/images/ic_absen.png',
                          'Absen Kehadiran',
                          AttendancePage(),
                        ),
                        const SizedBox(width: 20),
                        _buildMenuItem(
                          context,
                          'assets/images/ic_history.png',
                          'Riwayat Absensi',
                          HistoryPage(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Jarak antara baris atas dan bawah
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(
                          context,
                          'assets/images/ic_leave.png',
                          'Registrasi Wajah',
                          RegistrasiPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String imagePath, String label, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "INFO",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apa Anda ingin keluar dari aplikasi?",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Batal", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Ya", style: TextStyle(color: Colors.teal, fontSize: 14)),
          ),
        ],
      ),
    )) ?? false;
  }
}