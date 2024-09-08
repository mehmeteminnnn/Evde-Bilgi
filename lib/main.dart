import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/firebase_options.dart';
import 'package:evde_bilgi/giris_ekranı_logo_widget.dart';
import 'package:evde_bilgi/ilan_sayfalari/ilan_ver.dart';
import 'package:evde_bilgi/kayit_sayfalari/ogretmen_kay%C4%B1t.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String? uid;

  HomeScreen({this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: const EvdeBilgiAppBar(),
      drawer: const EvdeBilgiDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Ebeveynler ve Uzmanları\nBir Araya Getiren\nYeni Nesil Platform',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                giris_ekrani(iconData: Icons.school, text: "Gölge Öğretmen"),
                giris_ekrani(iconData: Icons.book, text: "Özel Eğitim"),
                giris_ekrani(
                    iconData: Icons.child_care, text: "Oyun Ablası / Abisi"),
                giris_ekrani(iconData: Icons.favorite, text: "Yaşam Koçu"),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IlanVer(
                                    jobModel: JobModel(),
                                    userId: "",
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Uzman Arıyorum'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherRegisterPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('İş Arıyorum'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Aileler İçin Talep Formu'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
