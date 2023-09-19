import 'dart:convert';
import 'dart:io';
import 'package:latihanapi/list_data.dart';
import 'package:latihanapi/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final int id;
  final String nama;
  final String jurusan;
  const EditData(
      {Key? key, required this.id, required this.nama, required this.jurusan})
      : super(key: key);

  @override
  _EditDataState createState() => _EditDataState(id, nama, jurusan);
}

class _EditDataState extends State<EditData> {
  int? id;
  String? nama;
  String? jurusan;
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();
  _EditDataState(int id, String nama, String jurusan) {
    this.id = id;
    this.nama = nama;
    this.jurusan = jurusan;
    namaController.text = nama;
    jurusanController.text = jurusan;
  }
  Future updateData(int? id, String nama, String jurusan) async {
    String url = Platform.isAndroid
        ? 'http://192.168.1.33:90/apikoneksi/index.php'
        : 'http://localhost:90/apikoneksi/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"id":"$id","nama":"$nama","jurusan":"$jurusan"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Edit data');
    }
  }

  _buatInput(control, String hint) {
    return TextField(
      controller: control,
      decoration: InputDecoration(hintText: hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Mahaasiswa'),
      ),
      drawer: const SideMenu(),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buatInput(namaController, 'Masukkan Nama Mahasiswa'),
              _buatInput(jurusanController, 'Masukkan Nama Jurusan'),
              ElevatedButton(
                  onPressed: () {
                    String nama = namaController.text;
                    String jurusan = jurusanController.text;
                    updateData(id, nama, jurusan).then((result) {
                      if (result['pesan'] == 'berhasil') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Data berhasil diedit'),
                                content: const Text('ok'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListData()));
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });
                      }
                      setState(() {});
                    });
                  },
                  child: const Text('Edit Mahasiswa'))
            ],
          )),
    );
  }
}
