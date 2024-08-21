import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CalismaAdresiScreen extends StatefulWidget {
  @override
  _CalismaAdresiScreenState createState() => _CalismaAdresiScreenState();
}

class _CalismaAdresiScreenState extends State<CalismaAdresiScreen> {
  String selectedCountry = 'Türkiye';
  String? selectedCity;
  String? selectedDistrict;
  String? enteredNeighborhood;

  List<dynamic> cities = [];
  List<dynamic> districts = [];

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

  bool _isFormComplete() {
    return selectedCity != null &&
        selectedDistrict != null &&
        enteredNeighborhood != null &&
        enteredNeighborhood!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(title: Text('Evde Bilgi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Çalışma Adresi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Aradığınız kişi nerede çalışacaksa seçebilirsiniz.'),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCountry,
              items: [
                DropdownMenuItem(child: Text('Türkiye'), value: 'Türkiye'),
              ],
              hint: Text('Ülke seçiniz'),
              onChanged: null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                    child: Text(city['name']), value: city['id'].toString());
              }).toList(),
              hint: Text('İl seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null; // İl seçildiğinde ilçe sıfırlanır
                  districts = []; // İlçe listesini sıfırla
                  enteredNeighborhood = null; // Mahalle sıfırlanır
                  _updateDistricts();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: districts.map<DropdownMenuItem<String>>((district) {
                return DropdownMenuItem<String>(
                    child: Text(district['name']),
                    value: district['id'].toString());
              }).toList(),
              hint: Text('İlçe seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  enteredNeighborhood =
                      null; // İlçe değiştiğinde mahalle sıfırlanır
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(hintText: 'Mahalle adını giriniz'),
              onChanged: (value) {
                setState(() {
                  enteredNeighborhood = value;
                });
              },
              enabled: selectedCity != null && selectedDistrict != null,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _isFormComplete()
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Scaffold()));
                    }
                  : null, // Tüm alanlar doldurulmamışsa buton pasif olur
              child: Text('İleri'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
