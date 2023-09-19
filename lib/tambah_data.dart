import 'dart:convert';
import 'dart:io';
import 'package:latihanapi/list_data.dart';
import 'package:latihanapi/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();
  Future postData(String nama, String jurusan) async {
    String url = Platform.isAndroid
        ? 'http://192.168.1.33:90/apikoneksi/index.php'
        : 'http://localhost:90/apikoneksi/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"nama":"$nama","jurusan":"$jurusan"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failded to add data');
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
        title: const Text('Tambah Data Mahaasiswa'),
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
                    postData(nama, jurusan).then((result) {
                      if (result['pesan'] == 'berhasil') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Data berhasil ditambah'),
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
                  child: const Text('Tambah Mahasiswa'))
            ],
          )),
    );
  }
}
