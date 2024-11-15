import 'package:flutter/material.dart';
import 'package:hrm/screens/absensi_screen.dart'; // Import AbsenScreen
import 'package:hrm/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:hrm/screens/izin_screen.dart'; // Import IzinScreen
import 'package:hrm/screens/dinas_luar_kota_screen.dart'; // Import DinasLuarScreen

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 8,
        child: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex, // Set the selected index
          onTap: onTap, // Handle item tap
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Cuti',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan Absensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Dinas Luar Kota', // Added Dinas Luar Kota menu
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My Profile',
            ),
          ],
        ),
      ),
    );
  }
}
