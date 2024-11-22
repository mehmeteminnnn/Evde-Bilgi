import 'package:evde_bilgi/aile_talep_formu/aile_talep_formu.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/kayit_sayfalari/ogretmen_kay%C4%B1t.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UyeOlma extends StatelessWidget {
  const UyeOlma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EvdeBilgiAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe1f5fe), Color(0xFFb3e5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildElevatedButton(
              context,
              'AİLE OLARAK ÜYE OL',
              AileTalepFormu(),
              Icons.family_restroom,
            ),
            const SizedBox(height: 24),
            _buildElevatedButton(
              context,
              'UZMAN OLARAK ÜYE OL',
              TeacherRegisterPage(),
              Icons.school,
            ),
          ],
        ),
      ),
    );
  }

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
        foregroundColor: Colors.blue.shade900,
        shadowColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        side: BorderSide(color: Colors.blueAccent.shade100, width: 2),
        minimumSize: const Size(double.infinity, 90),
      ),
      icon: Icon(
        icon,
        size: 36,
        color: Colors.blue.shade700,
      ),
      label: Expanded(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ),
    );
  }
}
