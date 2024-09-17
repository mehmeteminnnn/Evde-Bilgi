import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_ayrinti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl paketini ekleyin

class ApplicantsPage extends StatelessWidget {
  final List<dynamic> applicants;

  const ApplicantsPage({Key? key, required this.applicants}) : super(key: key);

  Future<String> getTeacherName(String userId) async {
    try {
      DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(userId)
          .get();

      if (teacherDoc.exists) {
        return teacherDoc['name'] ?? 'Bilgi Yok';
      } else {
        return 'Öğretmen Bulunamadı';
      }
    } catch (e) {
      print('Error fetching teacher name: $e');
      return 'Hata oluştu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Başvuranlar'),
      ),
      body: applicants.isEmpty
          ? const Center(child: Text('Bu ilana henüz başvuru yapılmamış.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final applicant = applicants[index];
                final basvuruTarihi =
                    (applicant['basvuru_tarihi'] as Timestamp).toDate();
                final String userId =
                    applicant['userId']; // Her applicant için ayrı userId

                return FutureBuilder<String>(
                  key: ValueKey(userId), // Her FutureBuilder için unique key
                  future: getTeacherName(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: const Text('Hata oluştu'),
                      );
                    } else if (!snapshot.hasData) {
                      return ListTile(
                        title: const Text('Bilgi yok'),
                      );
                    }

                    final teacherName = snapshot.data ?? 'Bilgi Yok';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: const Icon(Icons.person),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacherName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Uzun isimleri keser
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        basvuruTarihi), // Tarihi gün/ay/yıl formatında göster
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow
                                        .ellipsis, // Uzun tarihleri keser
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              id: applicant["userId"],
                                            ))); // Öğretmen detay sayfasına yönlendirme yapılabilir
                              },
                              child: const Text(
                                'Detaylar >>',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
