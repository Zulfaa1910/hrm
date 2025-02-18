import 'package:flutter/material.dart';
import 'package:hrm/api/dinasluarkota_service.dart';
import 'package:hrm/model/dinasluarkota.dart';
import 'package:hrm/screens/add_dinas_luar_kota_screen.dart';

class DinasLuarKotaScreen extends StatefulWidget {
  @override
  _DinasLuarKotaScreenState createState() => _DinasLuarKotaScreenState();
}

class _DinasLuarKotaScreenState extends State<DinasLuarKotaScreen> {
  late Future<List<DinasLuarKota>> futureDinasLuarKota;

  @override
  void initState() {
    super.initState();
    futureDinasLuarKota = _fetchDinasLuarKota();
  }

  Future<List<DinasLuarKota>> _fetchDinasLuarKota() async {
    try {
      return await DinasLuarKotaService().getDinasLuarKota();
    } catch (e, stacktrace) {
      print('Error saat memuat data dinas luar kota: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('Gagal memuat data dinas luar kota: $e');
    }
  }

  Future<void> _deleteDinasLuarKota(int id) async {
    try {
      await DinasLuarKotaService().deleteDinasLuarKota(id);
      _refreshData();
    } catch (e, stacktrace) {
      print('Error saat menghapus data dinas luar kota: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  void _refreshData() {
    setState(() {
      futureDinasLuarKota = _fetchDinasLuarKota();
    });
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteDinasLuarKota(id); // Hapus data dinas luar kota
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan popup edit
  void _showEditDialog(DinasLuarKota dinas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: DinasLuarKotaForm(dinas: dinas),
          ),
        );
      },
    ).then((isEdited) {
      if (isEdited == true) {
        _refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Dinas Luar Kota'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<DinasLuarKota>>(
        future: futureDinasLuarKota,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data dinas luar kota.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final dinas = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Berangkat: ${dinas.tglBerangkat}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Tanggal Kembali: ${dinas.tglKembali}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showEditDialog(dinas); // Tampilkan popup edit
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _showDeleteDialog(dinas.id); // Tampilkan popup hapus
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          dinas.kotaTujuan,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Keperluan: ${dinas.keperluan}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total Biaya: ${dinas.totalBiaya?.toStringAsFixed(2) ?? 'Belum dihitung'}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DinasLuarKotaForm()),
          );
          if (isAdded == true) {
            _refreshData();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Dinas Luar Kota',
      ),
    );
  }
}
