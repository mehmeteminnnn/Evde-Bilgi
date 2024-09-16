import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:evde_bilgi/models/ogretmen_model.dart';
import 'package:intl/intl.dart'; // Teacher model import

class ProfilePage extends StatelessWidget {
  final String id;

  ProfilePage({required this.id});

  Future<Teacher?> _fetchTeacherData() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('ogretmen').doc(id).get();

      if (doc.exists) {
        return Teacher.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error fetching teacher data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Teacher?>(
      future: _fetchTeacherData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              backgroundColor: Colors.blue,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              backgroundColor: Colors.blue,
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final teacher = snapshot.data;

        if (teacher == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              backgroundColor: Colors.blue,
            ),
            body: const Center(
              child: Text('Öğretmen bilgisi bulunamadı.'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.blue.shade100,
          appBar: AppBar(
            title: const Text('Profil'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profil Resmi ve Kişisel Bilgiler
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: teacher.imageUrl != null
                        ? NetworkImage(teacher.imageUrl!)
                        : null,
                    backgroundColor:
                        teacher.imageUrl == null ? Colors.grey[300] : null,
                    child: teacher.imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${teacher.name?.toUpperCase() ?? "İsim"} (${_calculateAge(teacher.dob)} Yaşında)',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${teacher.selectedCity ?? "Şehir Bilgisi Yok"}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İş Arayışı: ${teacher.workingTypes.isNotEmpty ? teacher.workingTypes.join(', ') : "Bilgi Yok"}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Öğretmen Hakkında
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${teacher.name?.toUpperCase() ?? "İsim"} Hakkında',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      teacher.experienceDescription ?? "Açıklama Yok",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Çalışmak İstediği Pozisyonlar
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Çalışmak İstediği Pozisyonlar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      teacher.positions.isNotEmpty
                          ? '• ${teacher.positions.join('\n• ')}'
                          : 'Bilgi Yok',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tercih Edilen Pozisyonlar

                  const SizedBox(height: 8),

                  // Çalışma Şekli
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Çalışma Şekli',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      teacher.workingTypes.isNotEmpty
                          ? '• ${teacher.workingTypes.join('\n• ')}'
                          : 'Bilgi Yok',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kişisel Bilgiler
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kişisel Bilgiler',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${teacher.educationLevel != null ? '• Öğrenim Durumu:${teacher.educationLevel}' : ''}\n'
                      '${teacher.gender != null ? '• Cinsiyet:${teacher.gender}' : ''}\n'
                      '${teacher.smokingHabit != null ? '• Sigara Kullanıyor Mu:${teacher.smokingHabit}' : ''}\n',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Tercihler
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tercihler',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${teacher.workingInCameraEnvironment != null ? '• Kameralı evde çalışabilirim' : ''}\n'
                      '${teacher.workingInPetEnvironment != null ? '• Evcil hayvanlı evde çalışabilirim' : ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to calculate age from date of birth
  int _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return 0;

    try {
      final dateFormat = DateFormat('dd-MM-yyyy'); // Tarih formatı belirleyin
      final birthDate = dateFormat.parse(dob);
      final today = DateTime.now();
      final age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        return age - 1;
      }
      return age;
    } catch (e) {
      print('Error parsing date of birth: $e');
      return 0;
    }
  }
}
