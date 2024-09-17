import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/ayarlar/aile_ayar.dart';
import 'package:evde_bilgi/basvuran_ogretmenler.dart';
import 'package:evde_bilgi/mesaj_ekranlari/aile_mesaj.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:evde_bilgi/main.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_listeleri.dart';
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
            padding: const EdgeInsets.symmetric(
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
                    leading: const Icon(Icons.home, size: 20),
                    title: const Text(
                      'Ana Sayfa',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.list, size: 20),
                    title: const Text(
                      'İş İlanları',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    leading: const Icon(Icons.add_box, size: 20),
                    title: const Text(
                      'İlan Ver',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      print(widget.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IlanVer(
                                    jobModel: JobModel(),
                                    userId: widget.uid!,
                                  )));
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.search, size: 20),
                    title: const Text(
                      'Uzman Bul',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    leading: const Icon(Icons.folder_open, size: 20),
                    title: const Text(
                      'Başvuranlar',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IlanListPage(
                                    familyId: widget.uid!,
                                  )));
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.message, size: 20),
                    title: const Text(
                      'Mesajlarım',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FamilyMessagesScreen(familyId: widget.uid!)));
                    },
                    // Handle the action
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.notifications, size: 20),
                    title: const Text(
                      'Bildirimler',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.card_membership, size: 20),
                    title: const Text(
                      'Paketlerim',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      // Handle the action
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.settings, size: 20),
                    title: const Text(
                      'Ayarlar',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AileAyarlarPage(
                                    uid: widget.uid,
                                  )));
                    },
                    // Handle the action
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
                return const CircularProgressIndicator();
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
                      const CircleAvatar(
                        radius: 16, // Avatar boyutunu küçültüyoruz
                        child:
                            Icon(Icons.person, size: 16), // Icon'u küçültüyoruz
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userData['name'] ?? 'Bilinmeyen Kullanıcı',
                        style: const TextStyle(
                            fontSize: 14), // Yazı boyutunu küçültüyoruz
                      ),
                    ],
                  ),
                );
              }

              return const Text("Kullanıcı bulunamadı.");
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.exit_to_app, size: 20, color: Colors.red),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
