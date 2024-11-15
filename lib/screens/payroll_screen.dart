import 'package:flutter/material.dart';
import 'package:hrm/api/payroll_service.dart';

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  Map<String, dynamic>? payrollData;
  bool isLoading = true;

  // Variabel untuk bulan dan tahun yang dipilih
  String selectedMonth = '11'; // Default bulan November
  String selectedYear = '2024'; // Default tahun 2024

  @override
  void initState() {
    super.initState();
    fetchPayrollData(); // Memanggil data saat aplikasi dimulai
  }

  // Fungsi untuk mengambil data payroll berdasarkan bulan dan tahun
  void fetchPayrollData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Mengambil data dengan bulan dan tahun yang dipilih
      final data = await PayrollService().fetchPayrollSummary(selectedMonth, selectedYear);
      setState(() {
        payrollData = data;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan dropdown bulan
  List<DropdownMenuItem<String>> getMonthDropdownItems() {
    List<String> months = [
      '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
    ];
    return months
        .map((month) => DropdownMenuItem<String>(
              value: month,
              child: Text(
                _getMonthName(month), // Mengubah bulan numerik menjadi nama bulan
                style: TextStyle(fontSize: 16),
              ),
            ))
        .toList();
  }

  // Fungsi untuk mengubah bulan numerik menjadi nama bulan
  String _getMonthName(String month) {
    Map<String, String> monthNames = {
      '01': 'Januari', '02': 'Februari', '03': 'Maret', '04': 'April', '05': 'Mei', '06': 'Juni',
      '07': 'Juli', '08': 'Agustus', '09': 'September', '10': 'Oktober', '11': 'November', '12': 'Desember'
    };
    return monthNames[month] ?? 'Januari';
  }

  // Fungsi untuk menampilkan dropdown tahun
  List<DropdownMenuItem<String>> getYearDropdownItems() {
    List<String> years = ['2024', '2023', '2022']; // Tahun yang dapat dipilih
    return years
        .map((year) => DropdownMenuItem<String>(
              value: year,
              child: Text(
                year,
                style: TextStyle(fontSize: 16),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll Summary'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : payrollData == null
              ? Center(child: Text('Tidak ada data'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assessment, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Payroll Summary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Dropdown Bulan dan Tahun
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedMonth,
                                onChanged: (String? newMonth) {
                                  setState(() {
                                    selectedMonth = newMonth!;
                                  });
                                  fetchPayrollData(); // Refresh data setelah memilih bulan
                                },
                                items: getMonthDropdownItems(),
                              ),
                              DropdownButton<String>(
                                value: selectedYear,
                                onChanged: (String? newYear) {
                                  setState(() {
                                    selectedYear = newYear!;
                                  });
                                  fetchPayrollData(); // Refresh data setelah memilih tahun
                                },
                                items: getYearDropdownItems(),
                              ),
                            ],
                          ),
                        ),

                        // Tabel Data Payroll
                        DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade50),
                          columns: [
                            DataColumn(
                                label: Text(
                              'Kategori',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            )),
                            DataColumn(
                                label: Text(
                              'Jumlah',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            )),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Row(
                                  children: [
                                    Icon(Icons.event, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Izin'),
                                  ],
                                )),
                                DataCell(Text(
                                  payrollData!['izin_count'].toString(),
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Row(
                                  children: [
                                    Icon(Icons.location_city, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('Dinas Luar Kota'),
                                  ],
                                )),
                                DataCell(Text(
                                  payrollData!['dinas_luar_kota_count'].toString(),
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Row(
                                  children: [
                                    Icon(Icons.beach_access, color: Colors.purple),
                                    SizedBox(width: 8),
                                    Text('Cuti'),
                                  ],
                                )),
                                DataCell(Text(
                                  payrollData!['cuti_count'].toString(),
                                  style: TextStyle(
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Row(
                                  children: [
                                    Icon(Icons.work, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Hari Kerja'),
                                  ],
                                )),
                                DataCell(Text(
                                  payrollData!['working_days'].toString(),
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
