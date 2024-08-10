import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tebrikler ilanınız başarıyla oluşturuldu',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Premium Abonelikler',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPremiumContainer(),
                buildPremiumContainer(),
                buildPremiumContainer(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Detayları',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Deneme Deneme Deneme Deneme Deneme\n' * 6,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Satın Al',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPremiumContainer() {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
