import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/aile_drawer.dart';
import 'package:evde_bilgi/basvuran_ogretmenler.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:evde_bilgi/mesaj_ekranlari/aile_mesaj.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class AileGiris extends StatefulWidget {
  final String? id;
  const AileGiris({super.key, this.id});

  @override
  State<AileGiris> createState() => _AileGirisState();
}

class _AileGirisState extends State<AileGiris> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İlanlar')),
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
          filteredJobs.isEmpty
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ilanlar')
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
                                  title: Text(ilan['title']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(ilan['details'] ?? ""),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${ilan['salary']} TL',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                      isAile: true,
                                                      jobId: ilan.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.green,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Görüntüle'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    var job = filteredJobs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: Text(job['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job['details'] ?? ""),
                              const SizedBox(height: 8),
                              Text(
                                '${job['salary']} TL',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              isAile: true,
                                              jobId: job['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Görüntüle'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          /* Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Filtreleme sayfasına yönlendirme yapıyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(),
                  ),
                );
              },
              child: const Icon(Icons.filter_list),
              backgroundColor: Colors.blue,
            ),
          ),*/
        ],
      ),
    );
  }
}
