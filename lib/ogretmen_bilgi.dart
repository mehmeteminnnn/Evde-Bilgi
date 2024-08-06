import 'package:evde_bilgi/app_bar.dart';
import 'package:evde_bilgi/is_ayr%C4%B1ntilari.dart';
import 'package:evde_bilgi/models/il_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<IlModel>> loadJsonData() async {
  try {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => IlModel.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error loading JSON data: $e');
    return [];
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

  List<String> cities = [];
  List<String> districts = [];
  List<String> neighborhoods = [];

  List<IlModel> jsonData = [];

  @override
  void initState() {
    super.initState();
    loadJsonData().then((data) {
      setState(() {
        jsonData = data;
        cities = data.map((il) => il.name).toList();
      });
    });
  }

  List<String> getNeighborhoods(String? selectedDistrict) {
    List<String> neighborhoodList = [];
    if (selectedCity != null && selectedDistrict != null) {
      var cityData = jsonData.firstWhere(
        (il) => il.name == selectedCity,
        orElse: () => IlModel(name: '', counties: []),
      );
      for (var county in cityData.counties) {
        var districtData = county.districts.firstWhere(
          (district) => district.name == selectedDistrict,
          orElse: () => District(name: '', neighborhoods: []),
        );
        neighborhoodList.addAll(
            districtData.neighborhoods.map((neigh) => neigh.name).toList());
      }
    }
    return neighborhoodList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Çalışma Adresi')),
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
                    (il) => il.name == value,
                    orElse: () => IlModel(name: '', counties: []),
                  );
                  districts =
                      cityData.counties.map((county) => county.name).toList();
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
                  neighborhoods = getNeighborhoods(selectedDistrict);
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobSelectionPage()));
              },
              child: Text('İleri'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
