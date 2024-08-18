import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return data['data'] as List<dynamic>;
    } else if (data is List<dynamic>) {
      return data;
    } else {
      throw Exception('Beklenmeyen veri formatı');
    }
  } else {
    throw Exception('Veri yüklenemedi');
  }
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

  List<dynamic> cities = [];
  List<dynamic> districts = [];
  List<dynamic> neighborhoods = [];

  @override
  void initState() {
    super.initState();
    fetchData('https://turkiyeapi.dev/api/v1/provinces').then((data) {
      setState(() {
        cities = data;
      });
    }).catchError((error) {
      print('Error fetching cities: $error');
    });
  }

  void _updateDistricts() {
    if (selectedCity != null) {
      final cityId =
          cities.firstWhere((city) => city['name'] == selectedCity)['id'];
      fetchData('http://turkiyeapi.dev/api/v1/provinces/$cityId').then((data) {
        setState(() {
          districts = data;
          selectedDistrict = null;
          selectedNeighborhood = null;
        });
      }).catchError((error) {
        print('Error fetching districts: $error');
      });
    }
  }

  void _updateNeighborhoods() {
    if (selectedDistrict != null) {
      final districtId = districts
          .firstWhere((district) => district['name'] == selectedDistrict)['id'];
      fetchData(
              'https://turkiyeapi.dev/api/v1/neighborhoods?district_id=$districtId')
          .then((data) {
        setState(() {
          neighborhoods = data;
          selectedNeighborhood = null;
        });
      }).catchError((error) {
        print('Error fetching neighborhoods: $error');
      });
    }
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
            Text('Çalışma Adresi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    child: Text(city['name']), value: city['name']);
              }).toList(),
              hint: Text('İl seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  _updateDistricts();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: districts.map<DropdownMenuItem<String>>((district) {
                return DropdownMenuItem<String>(
                    child: Text(district['name']), value: district['name']);
              }).toList(),
              hint: Text('İlçe seçiniz'),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  _updateNeighborhoods();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedNeighborhood,
              items:
                  neighborhoods.map<DropdownMenuItem<String>>((neighborhood) {
                return DropdownMenuItem<String>(
                    child: Text(neighborhood['name']),
                    value: neighborhood['name']);
              }).toList(),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Scaffold()));
              },
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
