import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/aile_drawer.dart';
import 'package:evde_bilgi/models/ogretmen_model.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_ayrinti.dart';
import 'package:flutter/material.dart';

class TeacherListPage extends StatelessWidget {
  final String? id;

  TeacherListPage({Key? key, this.id}) : super(key: key);

  Future<List<Teacher>> _fetchTeachers() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('ogretmen').get();

    // Filtreleme işlemini burada yapın
    return snapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Teacher.fromJson(data);
        })
        .where((teacher) =>
            teacher.selectedCity != null && teacher.selectedCity!.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kayıtlı Uzmanlar')),
      drawer: AileDrawer(uid: id),
      body: FutureBuilder<List<Teacher>>(
        future: _fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teachers found.'));
          } else {
            final teachers = snapshot.data!;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[100]!, Colors.blue[300]!],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  final teacher = teachers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
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
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                          '${teacher.selectedCity ?? ""} - ${teacher.selectedDistrict ?? ""}'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            teacher.experienceDescription ?? "",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          id: teacher.teacherId ?? "")),
                                );
                              },
                              // Detay sayfasına gitme kodu buraya gelecek

                              child: const Text(
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
            );
          }
        },
      ),
    );
  }
}
