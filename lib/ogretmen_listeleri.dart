import 'package:evde_bilgi/appbarlar/aile_drawer.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:flutter/material.dart';

class TeacherListPage extends StatelessWidget {
  final String? id;

  TeacherListPage({Key? key, this.id}) : super(key: key);
  final List<Map<String, String>> teachers = [
    {
      'name': 'İrem K.',
      'location': 'Beylikdüzü - İstanbul',
      'birthdate': '03.04.2001',
      'description':
          'Gölge öğretmen olarak çalışabilirim. Üsküdar üniversitesi çocuk gelişim üzerine önlisans mezunuyum. Çocuklar ve hayvanlarla ile ilgiliyim. Aynı zamanda...'
    },
    {
      'name': 'İrem K.',
      'location': 'Beylikdüzü - İstanbul',
      'birthdate': '03.04.2001',
      'description':
          'Gölge öğretmen olarak çalışabilirim. Üsküdar üniversitesi çocuk gelişim üzerine önlisans mezunuyum. Çocuklar ve hayvanlarla ile ilgiliyim. Aynı zamanda...'
    },
    {
      'name': 'İrem K.',
      'location': 'Beylikdüzü - İstanbul',
      'birthdate': '03.04.2001',
      'description':
          'Gölge öğretmen olarak çalışabilirim. Üsküdar üniversitesi çocuk gelişim üzerine önlisans mezunuyum. Çocuklar ve hayvanlarla ile ilgiliyim. Aynı zamanda...'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      drawer: AileDrawer(
        uid: id,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[300]!],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teachers[index]['name']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16),
                                SizedBox(width: 4),
                                Text(teachers[index]['location']!),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.cake, size: 16),
                                SizedBox(width: 4),
                                Text(teachers[index]['birthdate']!),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      teachers[index]['description']!,
                      style: TextStyle(fontSize: 14),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Detay sayfasına gitme kodu buraya gelecek
                        },
                        child: Text(
                          'Devamını Oku >>',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
