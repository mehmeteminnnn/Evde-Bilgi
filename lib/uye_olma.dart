import 'package:evde_bilgi/app_bar.dart';
import 'package:flutter/material.dart';

class UyeOlma extends StatelessWidget {
  const UyeOlma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
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
              onPressed: () {},
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
