import 'package:evde_bilgi/ozgecmis_ekranlari/ozgecmis_2.dart';
import 'package:flutter/material.dart';

class OzgecmisimEkrani1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Özgeçmişim'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Konum'),
                items: ['Türkiye', 'Diğer'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'İl Seçiniz'),
                items: ['İstanbul', 'Ankara', 'İzmir'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'İlçe Seçiniz'),
                items: ['Kadıköy', 'Çankaya', 'Konak'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Doğum Tarihi'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Deneyim'),
              ),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => OzgecmisimEkrani2()));},
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
      ),
    );
  }
}
