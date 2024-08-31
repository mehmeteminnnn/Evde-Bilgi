import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:evde_bilgi/mesajlar.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:evde_bilgi/ogretmen_listeleri.dart';
import 'package:flutter/material.dart';

class AileDrawer extends StatefulWidget {
  final String? uid;

  AileDrawer({Key? key, this.uid}) : super(key: key);

  @override
  _AileDrawerState createState() => _AileDrawerState();
}

class _AileDrawerState extends State<AileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 0), // Sağdan soldan padding'i kaldırıyoruz
            alignment: Alignment.center, // Ortalanmış hale getiriyoruz
            child: Image.asset(
              'assets/logov3.png',
              height: 50, // Logo yüksekliğini 50 olarak ayarladık
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.home, size: 20),
                    title: Text(
                      'Ana Sayfa',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.list, size: 20),
                    title: Text(
                      'İş İlanları',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobListingsPage(
                                    id: widget.uid,
                                  )));
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.add_box, size: 20),
                    title: Text(
                      'İlan Ver',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IlanVer(
                                    jobModel: JobModel(),
                                  )));
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.search, size: 20),
                    title: Text(
                      'Öğretmen Bul',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherListPage(
                                    id: widget.uid,
                                  )));
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.folder_open, size: 20),
                    title: Text(
                      'İlanlarım',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.person, size: 20),
                    title: Text(
                      'Aday İşlemleri',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.message, size: 20),
                    title: Text(
                      'Mesajlarım',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessagesPage(
                                    messages: ["Mesaj 1", "Mesaj 2"],
                                  )));
                    },
                    // Handle the action
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.notifications, size: 20),
                    title: Text(
                      'Bildirimler',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.card_membership, size: 20),
                    title: Text(
                      'Paketlerim',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.settings, size: 20),
                    title: Text(
                      'Ayarlar',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('aile')
                .doc(widget.uid) // Kullanıcının UID'sini alıyoruz
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text("Hata: ${snapshot.error}");
              }

              if (snapshot.hasData && snapshot.data!.exists) {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16, // Avatar boyutunu küçültüyoruz
                        child:
                            Icon(Icons.person, size: 16), // Icon'u küçültüyoruz
                      ),
                      SizedBox(width: 5),
                      Text(
                        userData['name'] ?? 'Bilinmeyen Kullanıcı',
                        style: TextStyle(
                            fontSize: 14), // Yazı boyutunu küçültüyoruz
                      ),
                    ],
                  ),
                );
              }

              return Text("Kullanıcı bulunamadı.");
            },
          ),
        ],
      ),
    );
  }
}
