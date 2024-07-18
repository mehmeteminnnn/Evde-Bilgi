import 'package:evde_bilgi/giris_ekranı_logo_widget.dart';
import 'package:evde_bilgi/ilan_ver.dart';
import 'package:flutter/material.dart';

void main() {
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
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/logov3.png'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('İş İlanları'),
              onTap: () {
                // Handle the action
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('İlan Ver'),
              onTap: () {
                // Handle the action
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Öğretmen Bul'),
              onTap: () {
                // Handle the action
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Aile Girişi'),
              onTap: () {
                // Handle the action
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Öğretmen Girişi'),
              onTap: () {
                // Handle the action
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text('İletişim'),
              onTap: () {
                // Handle the action
              },
            ),
            Spacer(), // This will push the following ListTile to the bottom
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Üye Ol'),
              onTap: () {
                // Handle the action
              },
            ),
          ],
        ),
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
                    onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
