import 'package:evde_bilgi/app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<dynamic>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  return jsonDecode(jsonString);
}

class CalismaAdresiScreen extends StatefulWidget {
  @override
  _CalismaAdresiScreenState createState() => _CalismaAdresiScreenState();
}

class _CalismaAdresiScreenState extends State<CalismaAdresiScreen> {
  String selectedCountry = 'Türkiye';
  String? selectedCity;
  String? selectedDistrict;
  String? selectedNeighborhood;

  List<String> cities = [];
  List<String> districts = [];
  List<String> neighborhoods = [];

  List<dynamic> jsonData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData().then((data) {
      setState(() {
        jsonData = data;
        cities = data.map<String>((city) => city['name'] as String).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
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
                DropdownMenuItem(
                  child: Text('Türkiye'),
                  value: 'Türkiye',
                ),
              ],
              hint: Text('Ülke seçiniz'),
              onChanged: null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              hint: Text('İl seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  var cityData = jsonData.firstWhere(
                    (city) => city['name'] == value,
                    orElse: () => {'counties': []}, // Boş county listesi döner
                  );
                  districts = (cityData['counties'] as List<dynamic>)
                      .map<String>((county) => county['name'] as String)
                      .toList();
                  selectedDistrict = null;
                  selectedNeighborhood = null;
                  neighborhoods = [];
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: districts
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              hint: Text('İlçe seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  var cityData = jsonData.firstWhere(
                    (city) => city['name'] == selectedCity,
                    orElse: () => {'counties': []}, // Boş county listesi döner
                  );
                  var districtData =
                      (cityData['counties'] as List<dynamic>).firstWhere(
                    (county) => county['name'] == value,
                    orElse: () =>
                        {'districts': []}, // Boş district listesi döner
                  );
                  neighborhoods = (districtData['districts'] as List<dynamic>)
                      .map<String>((district) => district['name'] as String)
                      .toList();
                  selectedNeighborhood = null;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedNeighborhood,
              items: neighborhoods
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              hint: Text('Mahalle seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedNeighborhood = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // İleri butonuna basıldığında yapılacak işlemler
              },
              child: Text('İleri'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                    double.infinity, 50), // Butonun genişliğini tam ekran yapar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
