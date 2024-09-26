import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // FontAwesome Icons eklendi

class AdminTalepListesi extends StatefulWidget {
  @override
  _AdminTalepListesiState createState() => _AdminTalepListesiState();
}

class _AdminTalepListesiState extends State<AdminTalepListesi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getTalepList() {
    return _firestore.collection('ailetalepformları').snapshots();
  }

  Future<void> _onaylaVeAileyeEkle(DocumentSnapshot talep) async {
    try {
      String adSoyad = talep['name'];
      String email = talep['email'];
      String phone = talep['phone'];
      String password = talep['password'];

      await _firestore.collection('aile').add({
        'name': adSoyad,
        'email': email,
        'phone': phone,
        'password': password,
      });

      await talep.reference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı başarıyla onaylandı ve eklendi.')),
      );
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı eklenirken bir hata oluştu.')),
      );
    }
  }

  void _showTalepDetails(BuildContext context, Map<String, dynamic> talepData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(talepData['name'] ?? 'Bilinmiyor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('E-posta: ${talepData['email']}'),
                Text('Telefon: ${talepData['phone']}'),
                Text('İkinci No: ${talepData['ikinciNo'] ?? 'Yok'}'),
                Text('Öğrenci Adı: ${talepData['ogrenciAdSoyad'] ?? 'Yok'}'),
                Text('Öğrenci Yaşı: ${talepData['ogrenciYas'] ?? 'Yok'}'),
                Text(
                    'Gelişim Bilgisi: ${talepData['gelisimBilgisi'] ?? 'Yok'}'),
                Text('Talep İçeriği: ${talepData['talepIcerigi'] ?? 'Yok'}'),
                Text('Talep Gün/Saat: ${talepData['talepGunSaat'] ?? 'Yok'}'),
                Text('Ekstra: ${talepData['ekstra'] ?? 'Yok'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _reddetTalep(DocumentSnapshot talep) async {
    try {
      await talep.reference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Talep başarıyla reddedildi.')),
      );
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Talep silinirken bir hata oluştu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Talep Listesi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getTalepList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Hiçbir talep bulunmamaktadır.'));
          }

          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> talepData =
                  doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Yuvarlatılmış köşeler
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Talep sahibinin adı
                          Text(
                            talepData['name'] ?? 'Bilinmiyor',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                          // Onayla ve Reddet Butonları
                          Row(
                            children: [
                              IconButton(
                                iconSize: 28,
                                icon: FaIcon(FontAwesomeIcons.checkCircle,
                                    color: Colors.green),
                                onPressed: () => _onaylaVeAileyeEkle(doc),
                                tooltip: 'Onayla',
                              ),
                              IconButton(
                                iconSize: 28,
                                icon: FaIcon(FontAwesomeIcons.timesCircle,
                                    color: Colors.red),
                                onPressed: () => _reddetTalep(doc),
                                tooltip: 'Reddet',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // E-posta
                      Text(
                        talepData['email'] ?? 'E-posta yok',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 10),
                      // Detaylar Butonu
                      OutlinedButton.icon(
                        onPressed: () => _showTalepDetails(context, talepData),
                        icon: FaIcon(FontAwesomeIcons.infoCircle,
                            color: Colors.deepPurple),
                        label: Text('Detaylar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
