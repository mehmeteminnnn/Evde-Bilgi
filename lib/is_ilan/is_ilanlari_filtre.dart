import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedCity;
  String? selectedPosition;
  String? selectedWorkType;

  List<String> cities = [];
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    // JSON dosyasını oku
    String jsonString = await rootBundle.loadString('assets/il.json');
    final jsonResponse = json.decode(jsonString);

    // Şehirleri listeye ekle
    List<String> cityList = (jsonResponse as List).map((data) {
      return data['name'] as String;
    }).toList();

    setState(() {
      cities = cityList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtreler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdown('Şehir', cities, (value) {
              setState(() {
                selectedCity = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdown('Pozisyon', ['Gölge Öğretmen', 'Diğer'], (value) {
              setState(() {
                selectedPosition = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdown('Çalışma Şekli',
                ['Tam zamanlı', 'Yarı zamanlı', 'Geçici', 'Yatılı'], (value) {
              setState(() {
                selectedWorkType = value;
              });
            }),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Filtreyi Uygula'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 32),
            Expanded(
              child: buildJobList(),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() async {
    Query query = FirebaseFirestore.instance.collection('ilanlar');

    if (selectedCity != null) {
      query = query.where('selectedCity', isEqualTo: selectedCity);
    }
    if (selectedPosition != null) {
      query = query.where('position', isEqualTo: selectedPosition);
    }
    if (selectedWorkType != null) {
      query = query.where('jobTypes', arrayContains: selectedWorkType);
    }

    QuerySnapshot querySnapshot = await query.get();

    setState(() {
      filteredJobs = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Widget buildJobList() {
    return filteredJobs.isNotEmpty
        ? ListView.builder(
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              var job = filteredJobs[index];
              return ListTile(
                title: Text(job['position'] ?? "Pozisyon bilgisi yok"),
                subtitle: Text(
                    '${job['selectedCity'] ?? "Şehir bilgisi yok"} - ${job['jobTypes'] != null ? job['jobTypes'].join(", ") : "Çalışma şekli bilgisi yok"}'),
              );
            },
          )
        : Center(child: Text('Eşleşen ilan bulunamadı'));
  }

  Widget buildDropdown(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
