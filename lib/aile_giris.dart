import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/aile_drawer.dart';
import 'package:evde_bilgi/basvuran_ogretmenler.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:evde_bilgi/mesaj_ekranlari/aile_mesaj.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatı için

class AileGiris extends StatefulWidget {
  final String? id;
  const AileGiris({super.key, this.id});

  @override
  State<AileGiris> createState() => _AileGirisState();
}

class _AileGirisState extends State<AileGiris> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlanlar'),
      ),
      drawer: AileDrawer(uid: widget.id),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'İlanlar',
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
          // Navigation logic
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
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ilanlar')
                .orderBy('publishDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Bir hata oluştu.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  var ilan = data.docs[index];
                  var publishDate =
                      (ilan['publishDate'] as Timestamp?)?.toDate() ??
                          DateTime.now();
                  String formattedDate = DateFormat('dd/MM/yyyy')
                      .format(publishDate); // Gün/ay/yıl formatı

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailPage(
                                isAile: true,
                                jobId: ilan.id,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ilan['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ilan['details'] ?? "",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.currency_lira,
                                      color: Colors.green), // TL sembolü
                                  const SizedBox(width: 10),
                                  Text(
                                    '${ilan['salary']} TL', // Dolar yerine TL
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Yayınlanma Tarihi: $formattedDate',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: 12), // Space before the button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailPage(
                                        isAile: true,
                                        jobId: ilan.id,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Görüntüle',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Buton metnini beyaz yapıyoruz
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
