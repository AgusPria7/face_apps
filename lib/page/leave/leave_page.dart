import 'package:face_apps/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String strAlamat = '', strDate = '', strTime = '', strDateTime = '';
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;
  final controllerName = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  String dropValueCategories = "Pilih:";
  var categoriesList = <String>["Pilih:", "Cuti", "Izin", "Sakit"];

  static const String BASE_URL = "http://172.25.4.76/MRP/";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Menu Pengajuan Cuti / Izin",
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
                    Icon(Icons.maps_home_work_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Isi Form Sesuai Pengajuan ya!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Input Nama
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: TextField(
                  textInputAction: TextInputAction.next,
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
              // Dropdown Keterangan
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Keterangan",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal, style: BorderStyle.solid, width: 1),
                  ),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    value: dropValueCategories,
                    onChanged: (value) {
                      setState(() {
                        dropValueCategories = value.toString();
                      });
                    },
                    items: categoriesList.map((value) {
                      return DropdownMenuItem(
                        value: value.toString(),
                        child: Text(value.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black)),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    isExpanded: true,
                  ),
                ),
              ),
              // Input Tanggal
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text("From: ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                fromController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                              }
                            },
                            controller: fromController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Starting From",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      children: [
                        const Text("Until: ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                toController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                              }
                            },
                            controller: toController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Until",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              // Tombol Ajukan
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () {
                    if (controllerName.text.isEmpty ||
                        dropValueCategories == "Pilih:" ||
                        fromController.text.isEmpty ||
                        toController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Ups, inputan tidak boleh kosong!"),
                        backgroundColor: Colors.redAccent,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Data berhasil diajukan!"),
                        backgroundColor: Colors.green,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                  child: const Text(
                    "Ajukan Sekarang",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
