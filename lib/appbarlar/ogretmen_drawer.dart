import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:evde_bilgi/main.dart';
import 'package:evde_bilgi/mesajlar.dart';
import 'package:flutter/material.dart';

class OgretmenDrawer extends StatefulWidget {
  final String? uid;

  OgretmenDrawer({Key? key, this.uid}) : super(key: key);

  @override
  _OgretmenDrawerState createState() => _OgretmenDrawerState();
}

class _OgretmenDrawerState extends State<OgretmenDrawer> {
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
                              builder: (context) => JobListingsPage()));
                    },
                    // Handle the action
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
                    leading: Icon(Icons.card_membership, size: 20),
                    title: Text(
                      'Başvurularım',
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
                .collection('ogretmen')
                .doc(widget.uid) // Öğretmen ID'si burada kullanılmalı
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
          ListTile(
            dense: true,
            leading: Icon(Icons.exit_to_app, size: 20, color: Colors.red),
            title: Text(
              'Çıkış Yap',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen()), // HomeScreen'e yönlendirme
              );
            },
          ),
        ],
      ),
    );
  }
}
