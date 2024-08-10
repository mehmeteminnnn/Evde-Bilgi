import 'package:evde_bilgi/aile_kayit.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/appbarlar/ogretmen_drawer.dart';
import 'package:evde_bilgi/firebase_options.dart';
import 'package:evde_bilgi/giris_ekranı_logo_widget.dart';
import 'package:evde_bilgi/ilan_ver.dart';
import 'package:evde_bilgi/ogretmen_kay%C4%B1t.dart';
import 'package:evde_bilgi/ozgecmis_ekranlari/ozgecmis_1.dart';
import 'package:evde_bilgi/uye_olma.dart';
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
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                ;
              },
            );
          },
        ),
        title: Text("cw"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: OgretmenDrawer(
        uid: uid,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Ebeveynler ve Uzmanları\nBir Araya Getiren\nYeni Nesil Platform',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                giris_ekrani(iconData: Icons.school, text: "Gölge Öğretmen"),
                giris_ekrani(iconData: Icons.book, text: "Özel Eğitim"),
                giris_ekrani(
                    iconData: Icons.child_care, text: "Oyun Ablası / Abisi"),
                giris_ekrani(iconData: Icons.favorite, text: "Yaşam Koçu"),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => IlanVer()));
                    },
                    child: Text('Öğretmen Arıyorum'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherRegisterPage()));
                    },
                    child: Text('İş Arıyorum'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 45),
            OutlinedButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Aileler İçin Talep Formu'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
                side: BorderSide(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UyeOlma()));
              },
              child: Text('Deneme Butonu'),
            )
          ],
        ),
      ),
    );
  }
}
