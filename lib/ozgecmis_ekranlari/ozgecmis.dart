import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  // İl ve İlçe bilgileri
  String? selectedCity;
  String? selectedDistrict;

  List<dynamic> cities = [];
  List<dynamic> districts = [];

  // Deneyim
  String? selectedExperience;
  List<String> experienceOptions = ['0-1 yıl', '1-5 yıl', '5+ yıl'];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    // İl JSON dosyasını oku
    String cityJson = await rootBundle.loadString('assets/il.json');
    List<Map<String, dynamic>> cityList =
        List<Map<String, dynamic>>.from(jsonDecode(cityJson));

    // Şehirleri alfabetik sıraya göre sıralayın
    cityList.sort((a, b) => a['name'].compareTo(b['name']));

    setState(() {
      cities = cityList;
    });
  }

  Future<void> _updateDistricts() async {
    // İlçe JSON dosyasını oku
    String districtJson = await rootBundle.loadString('assets/ilce.json');
    List<dynamic> allDistricts = jsonDecode(districtJson);

    // Seçili şehre ait ilçeleri filtrele
    setState(() {
      districts = allDistricts
          .where((district) => district['il_id'] == selectedCity)
          .toList();
    });
  }

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
            // Konum ve İl Seçimi
            _buildDropdown('Ülke Seçiniz', ['Türkiye']),
            _buildCityDropdown(),
            _buildDistrictDropdown(),
            _buildDatePicker(context, 'Doğum Tarihi'),
            _buildExperienceDropdown(),
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
            _buildTextField('Minimum aylık maaş (TL)'),
            _buildTextField('Maksimum aylık maaş (TL)'),
            _buildTextField('İş deneyiminizi ve görevlerinizi tanımlayın.',
                maxLines: 3),
            SizedBox(height: 20),

            // Kaydet ve İptal Butonları
            ElevatedButton(
              onPressed: () {
                // İleri butonuna tıklandığında yapılacak işlemler
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

  // Şehir Dropdown'ı oluşturan fonksiyon
  Widget _buildCityDropdown() {
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
          labelText: 'İl seçiniz',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedCity,
        items: cities.map<DropdownMenuItem<String>>((city) {
          return DropdownMenuItem<String>(
            child: Text(city['name']),
            value: city['id'].toString(),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCity = value;
            selectedDistrict = null; // İl seçildiğinde ilçe sıfırlanır
            districts = []; // İlçe listesini sıfırla
            _updateDistricts();
          });
        },
      ),
    );
  }

  // İlçe Dropdown'ı oluşturan fonksiyon
  Widget _buildDistrictDropdown() {
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
          labelText: 'İlçe seçiniz',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedDistrict,
        items: districts.map<DropdownMenuItem<String>>((district) {
          return DropdownMenuItem<String>(
            child: Text(district['name']),
            value: district['id'].toString(),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDistrict = value;
          });
        },
      ),
    );
  }

  // Deneyim Dropdown'ı oluşturan fonksiyon
  Widget _buildExperienceDropdown() {
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
          labelText: 'Deneyim',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedExperience,
        items: experienceOptions.map<DropdownMenuItem<String>>((experience) {
          return DropdownMenuItem<String>(
            child: Text(experience),
            value: experience,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedExperience = value;
          });
        },
      ),
    );
  }

  // Metin alanı oluşturan fonksiyon
  Widget _buildTextField(String labelText, {int maxLines = 1}) {
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
      child: TextFormField(
        maxLines: maxLines,
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
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String labelText) {
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
      child: TextFormField(
        readOnly: true, // Kullanıcı manuel olarak tarih giremez
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
          suffixIcon: Icon(Icons.calendar_today), // Takvim simgesi
        ),
        onTap: () async {
          // Takvim gösterme işlemi
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900), // En erken seçilebilecek tarih
            lastDate: DateTime.now(), // En geç seçilebilecek tarih (bugün)
          );

          if (selectedDate != null) {
            // Seçilen tarihi göster
            setState(() {
              _dobController.text =
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
            });
          }
        },
        controller:
            _dobController, // Tarih değerini göstermek için bir TextEditingController
      ),
    );
  }

  TextEditingController _dobController = TextEditingController();
  // Genel Dropdown yapısı oluşturan fonksiyon
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
        value: items.isNotEmpty ? items.first : null,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            // Güncelleme işlemi
          });
        },
      ),
    );
  }
}
