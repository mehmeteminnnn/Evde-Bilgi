import 'package:flutter/material.dart';

class EkBilgilerEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ek Bilgiler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration:
                  InputDecoration(labelText: 'Sigara kullanıyor musunuz?'),
              items: ['Evet', 'Hayır'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText:
                      'Kameraların bulunduğu yerde çalışmak ister misiniz?'),
              items: ['Evet', 'Hayır'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText:
                      'Evcil hayvanların olduğu yerde çalışmak ister misiniz?'),
              items: ['Evet', 'Hayır'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Katıldığınız Kurslar',
                suffixIcon: Icon(Icons.add),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Konuştuğunuz Diller',
                suffixIcon: Icon(Icons.add),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('İleri'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange // Renk tercihi
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
