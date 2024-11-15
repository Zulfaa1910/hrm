import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrm/api/api_service.dart';

class RekapAbsensiScreen extends StatefulWidget {
  @override
  _RekapAbsensiScreenState createState() => _RekapAbsensiScreenState();
}

class _RekapAbsensiScreenState extends State<RekapAbsensiScreen> {
  List<dynamic> _rekapAbsensi = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRekapAbsensi();
  }

  Future<void> _fetchRekapAbsensi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token == null) {
      setState(() {
        _errorMessage = 'Token tidak ditemukan. Silakan login kembali.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await ApiService.getRequest(
        'absensi',  // Sesuaikan dengan endpoint API yang benar
        {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _rekapAbsensi = data['data'];  // Pastikan key sesuai dengan respons dari API
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data, status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekap Absensi'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _rekapAbsensi.length,
                  itemBuilder: (context, index) {
                    final absensi = _rekapAbsensi[index];
                    return ListTile(
                      title: Text('Tanggal: ${absensi['tanggal']}'),
                      subtitle: Text(
                          'Jam Masuk: ${absensi['jam_masuk'] ?? 'N/A'}\nJam Keluar: ${absensi['jam_keluar'] ?? 'N/A'}'),
                    );
                  },
                ),
    );
  }
}
