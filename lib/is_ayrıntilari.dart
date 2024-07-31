import 'package:evde_bilgi/app_bar.dart';
import 'package:evde_bilgi/ihtiyac_detay.dart';
import 'package:flutter/material.dart';

class JobSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'İş Türü*',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildJobTypeButton('Tam zamanlı'),
                _buildJobTypeButton('Yarı zamanlı'),
                _buildJobTypeButton('Geçici'),
                _buildJobTypeButton('Günlük'),
                _buildJobTypeButton('Saatlik'),
                _buildJobTypeButton('Yatılı'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Günlük kaç saat?',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ne kadar acil ihtiyacınız var?',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              items: <String>['Hemen', '1 hafta içinde', '2 hafta içinde']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(),
                      ),
                    );
                    // Next action
                  },
                  child: Text('İleri'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildJobTypeButton(String label) {
    return OutlinedButton(
      onPressed: () {
        // Job type selection action
      },
      child: Text(label),
    );
  }
}
