import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrm/screens/absensi_screen.dart'; // Import AbsenScreen
import 'package:hrm/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:hrm/screens/izin_screen.dart'; // Import IzinScreen
import 'package:hrm/screens/rekap_absensi.dart'; // Import RekapAbsensiScreen
import 'package:hrm/screens/dinas_luar_kota_screen.dart'; // Import DinasLuarScreen
import 'package:hrm/screens/payroll_screen.dart'; // Import PayrollScreen
import 'package:hrm/screens/navigation.dart'; // Import CustomBottomNavigationBar

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Set default to "Scan Absensi"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Handle navigation logic based on selected index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IzinScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AbsensiScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DinasLuarKotaScreen()), // Added DinasLuarScreen navigation
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: [
                  Image.asset('assets/images/example1.png', fit: BoxFit.cover),
                  Image.asset('assets/images/example2.png', fit: BoxFit.cover),
                  Image.asset('assets/images/example3.png', fit: BoxFit.cover),
                ],
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLayananItem('Absensi', Icons.qr_code, context),
                      _buildLayananItem('Payroll', Icons.attach_money, context),
                      _buildLayananItem('Rekap Absensi', Icons.description, context),
                      _buildLayananItem('Kinerja', Icons.task, context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(toY: 5, color: Colors.blue),
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(toY: 3, color: Colors.green),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(toY: 4, color: Colors.red),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(toY: 2, color: Colors.orange),
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(toY: 6, color: Colors.purple),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // Pass the current index
        onTap: _onItemTapped, // Handle item tap
      ),
    );
  }

  Widget _buildLayananItem(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Absensi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AbsensiScreen()),
          );
        } else if (title == 'Payroll') { // Navigate to PayrollScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PayrollScreen()),
          );
        } else if (title == 'Rekap Absensi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RekapAbsensiScreen()),
          );
        } else if (title == 'Dinas Luar Kota') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DinasLuarKotaScreen()), // Navigation to DinasLuarScreen
          );
        }
      },
      child: Column(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}  
