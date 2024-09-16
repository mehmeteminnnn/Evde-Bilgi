import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/ayarlar/ogretmen_ayar.dart';
import 'package:evde_bilgi/basvurularim.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:evde_bilgi/main.dart';
import 'package:evde_bilgi/mesaj_ekranlari/ogretmen_mesaj.dart';
import 'package:flutter/material.dart';

class OgretmenDrawer extends StatefulWidget {
  final String? uid;

  OgretmenDrawer({Key? key, this.uid}) : super(key: key);

  @override
  _OgretmenDrawerState createState() => _OgretmenDrawerState();
}

class _OgretmenDrawerState extends State<OgretmenDrawer> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(widget.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _profileImageUrl = userData['image_url'];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/logov3.png',
              height: 50,
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
                              builder: (context) =>
                                  JobListingsPage(id: widget.uid!)));
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
                              builder: (context) => TeacherMessagesScreen(
                                  teacherId: widget.uid!)));
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.card_membership, size: 20),
                    title: const Text(
                      'Başvurularım',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    onTap: () {
                      MyApplicationsPage(
                        teacherId: widget.uid!,
                      );
                    },
                    // Handle the action
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
                          builder: (context) => AyarlarPage(uid: widget.uid),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('ogretmen')
                      .doc(widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text("Hata: ${snapshot.error}");
                    }

                    if (snapshot.hasData && snapshot.data!.exists) {
                      var userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text(
                        userData['name'] ?? 'Bilinmeyen Kullanıcı',
                        style: const TextStyle(fontSize: 14),
                      );
                    }

                    return const Text("Kullanıcı bulunamadı.");
                  },
                ),
              ],
            ),
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
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
