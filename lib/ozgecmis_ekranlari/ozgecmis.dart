import 'package:flutter/material.dart';

class OzgecmisimEkrani extends StatefulWidget {
  @override
  _OzgecmisimEkraniState createState() => _OzgecmisimEkraniState();
}

class _OzgecmisimEkraniState extends State<OzgecmisimEkrani> {
  // Çalışmak istediğiniz pozisyonlar
  List<String> pozisyonlar = [
    'Gölge Öğretmen',
    'Oyun Ablası/Abisi',
    'Özel Eğitim',
    'Yaşam Koçu'
  ];
  List<bool> seciliPozisyonlar = [false, false, false, false];

  // Çalışma şekli
  List<String> calismaSekilleri = [
    'Tam zamanlı',
    'Yarı zamanlı',
    'Geçici',
    'Günlük',
    'Saatlik',
    'Yatılı'
  ];
  List<bool> seciliCalismaSekilleri = [
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Özgeçmişim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Birinci Sayfa İçeriği
            _buildDropdown('Konum', ['Türkiye', 'Diğer']),
            _buildDropdown('İl Seçiniz', ['İstanbul', 'Ankara', 'İzmir']),
            _buildDropdown('İlçe Seçiniz', ['Kadıköy', 'Çankaya', 'Konak']),
            _buildTextField('Doğum Tarihi'),
            _buildTextField('Deneyim'),
            SizedBox(height: 20),
            Text(
              'Çalışmak İstediğiniz Pozisyonlar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                pozisyonlar.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(pozisyonlar[index]),
                    selected: seciliPozisyonlar[index],
                    onSelected: (bool selected) {
                      setState(() {
                        seciliPozisyonlar[index] = selected;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Çalışma Şekli',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                calismaSekilleri.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(calismaSekilleri[index]),
                    selected: seciliCalismaSekilleri[index],
                    onSelected: (bool selected) {
                      setState(() {
                        seciliCalismaSekilleri[index] = selected;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),

            // İkinci Sayfa İçeriği
            _buildTextField('Minimum Ücret (TL saat başına)'),
            _buildTextField('Maksimum aylık maaş (TL)'),
            _buildTextField('İş deneyiminizi ve görevlerinizi tanımlayın.',
                maxLines: 3),
            SizedBox(height: 20),

            // Kaydet ve İptal Butonları
            ElevatedButton(
              onPressed: () {
                // Seçilen pozisyonlar ve çalışma şekilleri ile ilgili işlemler burada yapılabilir.
                // Örneğin, Firestore'a kaydetme gibi işlemler.
              },
              child: Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
            ),
            TextButton(
              onPressed: () {
                // İptal işlemi
              },
              child: Text('İptal'),
            ),
          ],
        ),
      ),
    );
  }

  // TextField'ı oluşturan yardımcı fonksiyon
  Widget _buildTextField(String labelText, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Gölgenin pozisyonu
          ),
        ],
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none, // Border'ı kaldır
          ),
        ),
      ),
    );
  }

  // DropdownButtonFormField'ı oluşturan yardımcı fonksiyon
  Widget _buildDropdown(String labelText, List<String> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {},
      ),
    );
  }
}
