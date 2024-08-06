import 'package:evde_bilgi/ozgecmis_ekranlari/ek_bilgi.dart';
import 'package:flutter/material.dart';

class OzgecmisimEkrani3 extends StatefulWidget {
  @override
  _EkBilgilerEkraniState createState() => _EkBilgilerEkraniState();
}

class _EkBilgilerEkraniState extends State<OzgecmisimEkrani3> {
  String? cinsiyet;
  String? egitimSeviyesi;
  String? tibbiEgitim;
  String? egitimFakultesi;
  String? sahsiAraba;
  String? ehliyet;
  String? pasaport;

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
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Cinsiyet',
                border: OutlineInputBorder(),
              ),
              value: cinsiyet,
              onChanged: (String? newValue) {
                setState(() {
                  cinsiyet = newValue;
                });
              },
              items: <String>['Erkek', 'Kadın', 'Diğer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Eğitim Seviyesi',
                border: OutlineInputBorder(),
              ),
              value: egitimSeviyesi,
              onChanged: (String? newValue) {
                setState(() {
                  egitimSeviyesi = newValue;
                });
              },
              items: <String>[
                'Lise',
                'Ön Lisans',
                'Lisans',
                'Yüksek Lisans',
                'Doktora'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tıbbi eğitim aldınız mı?',
                border: OutlineInputBorder(),
              ),
              value: tibbiEgitim,
              onChanged: (String? newValue) {
                setState(() {
                  tibbiEgitim = newValue;
                });
              },
              items: <String>['Evet', 'Hayır']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Eğitim fakültesinden mezun musunuz?',
                border: OutlineInputBorder(),
              ),
              value: egitimFakultesi,
              onChanged: (String? newValue) {
                setState(() {
                  egitimFakultesi = newValue;
                });
              },
              items: <String>['Evet', 'Hayır']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Şahsi arabanız var mı?',
                border: OutlineInputBorder(),
              ),
              value: sahsiAraba,
              onChanged: (String? newValue) {
                setState(() {
                  sahsiAraba = newValue;
                });
              },
              items: <String>['Evet', 'Hayır']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Ehliyetiniz var mı?',
                border: OutlineInputBorder(),
              ),
              value: ehliyet,
              onChanged: (String? newValue) {
                setState(() {
                  ehliyet = newValue;
                });
              },
              items: <String>['Evet', 'Hayır']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Pasaportunuz var mı?',
                border: OutlineInputBorder(),
              ),
              value: pasaport,
              onChanged: (String? newValue) {
                setState(() {
                  pasaport = newValue;
                });
              },
              items: <String>['Evet', 'Hayır']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // İptal butonu işlevi
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EkBilgilerEkrani()));
                    // Kaydet butonu işlevi
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
