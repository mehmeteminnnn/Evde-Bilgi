import 'package:evde_bilgi/aile_talep_formu/aile_talep_formu.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/kayit_sayfalari/ogretmen_kay%C4%B1t.dart';
import 'package:flutter/material.dart';

class UyeOlma extends StatelessWidget {
  const UyeOlma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: const EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aile olarak üye ol butonu
            _buildElevatedButton(
              context,
              'AİLE OLARAK ÜYE OL',
              AileTalepFormu(),
              Icons.family_restroom,
              // Aile ikonu
            ),
            const SizedBox(height: 16),
            // Öğretmen olarak üye ol butonu
            _buildElevatedButton(
              context,
              'UZMAN OLARAK ÜYE OL',
              TeacherRegisterPage(),
              Icons.school, // Öğretmen ikonu
            ),
          ],
        ),
      ),
    );
  }

  // Özelleştirilmiş ElevatedButton widget'ı
  Widget _buildElevatedButton(
      BuildContext context, String text, Widget page, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        side: BorderSide(color: Colors.blue.shade300, width: 2),
        minimumSize: const Size(double.infinity, 100),
        // Butonları büyütme
      ),
      icon: Icon(icon, size: 35),
      label: Expanded(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
