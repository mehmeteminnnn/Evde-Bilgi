import 'package:evde_bilgi/aile_kayit.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ogretmen_kay%C4%B1t.dart';
import 'package:flutter/material.dart';

class UyeOlma extends StatelessWidget {
  const UyeOlma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FamilyRegisterPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(24),
              ),
              child: Center(
                child: Text(
                  'AİLE OLARAK ÜYE OL',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherRegisterPage()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(24),
              ),
              child: Center(
                child: Text(
                  'ÖĞRETMEN OLARAK ÜYE OL',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
