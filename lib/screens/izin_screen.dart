import 'package:flutter/material.dart';
import 'package:hrm/api/izin_service.dart';
import 'package:hrm/model/izin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrm/screens/Add_izin.dart'; // Pastikan untuk mengimpor IzinForm

class IzinScreen extends StatefulWidget {
  @override
  _IzinScreenState createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  late Future<List<Izin>> futureIzin;

  @override
  void initState() {
    super.initState();
    futureIzin = _fetchIzin();
  }

  Future<List<Izin>> _fetchIzin() async {
    try {
      return await IzinService().getIzin();
    } catch (e) {
      throw Exception('Gagal memuat data izin: $e');
    }
  }

  Future<void> _deleteIzin(int izinId) async {
    try {
      await IzinService().deleteIzin(izinId);
      setState(() {
        futureIzin = _fetchIzin();
      });
    } catch (e) {
      print('Gagal menghapus izin: $e');
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(int izinId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus izin ini?"),
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
                _deleteIzin(izinId); // Panggil fungsi delete izin
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog edit
  void _showEditDialog(Izin izin) {
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
            child: IzinForm(izin: izin),
          ),
        );
      },
    ).then((_) {
      setState(() {
        futureIzin = _fetchIzin();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Izin'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<Izin>>(
        future: futureIzin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data izin.'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final izin = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                '${izin.durasi}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${izin.tgl_mulai} - ${izin.tgl_selesai}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Izin',
                                        style: TextStyle(color: Colors.green[800]),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      izin.status,
                                      style: TextStyle(
                                        color: izin.status == 'Disetujui' ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditDialog(izin); // Tampilkan dialog edit
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteDialog(izin.id); // Tampilkan dialog hapus
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Keterangan: ${izin.keterangan}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Alasan: ${izin.alasan}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IzinForm()),
          ).then((_) {
            setState(() {
              futureIzin = _fetchIzin();
            });
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Izin',
      ),
    );
  }
}
