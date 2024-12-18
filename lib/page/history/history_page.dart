import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const String BASE_URL = "http://172.25.4.76/FACE/Xmx";
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL + 'database.php?action=get_history'));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> deleteData(String id) async {
    try {
      final response = await http.post(
        Uri.parse(BASE_URL + 'database.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "delete", "id": id}),
      );
      if (response.statusCode == 200) {
        setState(() {
          data.removeWhere((element) => element['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Data berhasil dihapus"),
          backgroundColor: Colors.green,
        ));
      } else {
        throw Exception("Failed to delete data");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF001845),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
        ),
      )
          : data.isEmpty
          ? const Center(
        child: Text(
          "Ups, tidak ada data!",
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AlertDialog dialogHapus = AlertDialog(
                title: const Text("Hapus Data", style: TextStyle(fontSize: 18, color: Colors.black)),
                content: const Text(
                  "Yakin ingin menghapus data ini?",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      deleteData(data[index]['id']);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Ya",
                      style: TextStyle(fontSize: 14, color: Colors.pinkAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Tidak",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              );
              showDialog(context: context, builder: (context) => dialogHapus);
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Center(
                        child: Text(
                          data[index]['nama'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRow("Nama", data[index]['nama']),
                          _buildRow("Alamat", data[index]['alamat']),
                          _buildRow("Keterangan", data[index]['keterangan']),
                          _buildRow("Waktu Absen", data[index]['datetime']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            " : ",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        Expanded(
          flex: 8,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
