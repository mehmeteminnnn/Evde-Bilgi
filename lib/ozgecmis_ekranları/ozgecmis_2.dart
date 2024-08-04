import 'package:flutter/material.dart';

class OzgecmisimEkrani2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Özgeçmişim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(label: Text('Gölge Öğretmen'), selected: false),
                ChoiceChip(label: Text('Oyun Ablası/Abisi'), selected: false),
                ChoiceChip(label: Text('Özel Eğitim'), selected: false),
                ChoiceChip(label: Text('Yaşam Koçu'), selected: false),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(label: Text('Tam zamanlı'), selected: false),
                ChoiceChip(label: Text('Yarı zamanlı'), selected: false),
                ChoiceChip(label: Text('Geçici'), selected: false),
                ChoiceChip(label: Text('Günlük'), selected: false),
                ChoiceChip(label: Text('Saatlik'), selected: false),
                ChoiceChip(label: Text('Yatılı'), selected: false),
              ],
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Minimum Ücret (TL saat başına)'),
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Maksimum aylık maaş (TL)'),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'İş deneyiminizi ve görevlerinizi tanımlayın.'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('İptal'),
            ),
          ],
        ),
      ),
    );
  }
}
