import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/aile_drawer.dart';
import 'package:evde_bilgi/basvuran_ogretmenler.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/mesaj_ekranlari/aile_mesaj.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:evde_bilgi/models/ogretmen_model.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_ayrinti.dart';
import 'package:flutter/material.dart';

class TeacherListPage extends StatefulWidget {
  final String? id;

  TeacherListPage({Key? key, this.id}) : super(key: key);

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  int _selectedIndex = 0;

  Future<List<Teacher>> _fetchTeachers() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('ogretmen').get();

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
      appBar: AppBar(title: const Text('Kayıtlı Uzmanlar')),
      drawer: AileDrawer(uid: widget.id),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Uzman Bul',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'İlan Ver',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Başvuranlar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IlanListPage(
                  familyId: widget.id!,
                ),
              ),
            ).then((_) {
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IlanVer(
                  userId: widget.id!,
                  jobModel: JobModel(),
                ),
              ),
            ).then((_) {
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FamilyMessagesScreen(
                  familyId: widget.id!,
                ),
              ),
            ).then((_) {
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
        },
      ),
      body: FutureBuilder<List<Teacher>>(
        future: _fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: const Text('No teachers found.'));
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
                                backgroundImage: teacher.imageUrl != null
                                    ? NetworkImage(teacher.imageUrl!)
                                    : null,
                                backgroundColor: teacher.imageUrl == null
                                    ? Colors.grey[300]
                                    : null,
                                child: teacher.imageUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey[700],
                                      )
                                    : null,
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
