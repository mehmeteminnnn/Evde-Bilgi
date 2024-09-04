import 'dart:convert';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turkish/turkish.dart';

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

    // Türkçe karakterlere uygun şekilde alfabetik olarak sırala
    cityList.sort((a, b) => turkish.comparator(a, b));

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

    List<Map<String, dynamic>> filteredJobs = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return {
        'id': doc.id,
        'title': data.containsKey('title') ? data['title'] : '',
        'details': data.containsKey('details') ? data['details'] : '',
        'salary': data.containsKey('salary') ? data['salary'] : '',
        'selectedCity':
            data.containsKey('selectedCity') ? data['selectedCity'] : '',
        'position': data.containsKey('position') ? data['position'] : '',
        'jobTypes': data.containsKey('jobTypes') ? data['jobTypes'] : [],
      };
    }).toList();

    Navigator.pop(context, filteredJobs);
  }

  Widget buildJobList() {
    return filteredJobs.isNotEmpty
        ? ListView.builder(
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              var ilan = filteredJobs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(ilan['title'] ?? "Başlık bilgisi yok"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ilan['details'] ?? ""),
                            SizedBox(height: 8),
                            Text(
                              '${ilan['salary'] ?? "Ücret bilgisi yok"} TL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Şimdi Başvur'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            JobDetailPage(jobId: ilan['id']),
                                      ),
                                    );
                                  },
                                  child: Text('Görüntüle'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
