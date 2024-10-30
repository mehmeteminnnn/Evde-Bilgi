import 'package:evde_bilgi/aile_talep_formu/aile_talep_formu.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/firebase_options.dart';
import 'package:evde_bilgi/giris_ekranı_logo_widget.dart';
import 'package:evde_bilgi/giris_sayfalari/aile_girisi.dart';
import 'package:evde_bilgi/giris_sayfalari/ogretmen_giris.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade400,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Lato',
          ),
          centerTitle: true,
          elevation: 2,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EvdeBilgiAppBar(),
      drawer: const EvdeBilgiDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10), // Yüksekliği azaltılmış
          const Text(
            'Ebeveynler ve Uzmanları\nBir Araya Getiren\nYeni Nesil Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10), // Yüksekliği azaltılmış
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16, // Aralık azaltılmış
            crossAxisSpacing: 16,
            children: <Widget>[
              _buildGridCard(context, Icons.school, "Gölge Öğretmen"),
              _buildGridCard(context, Icons.book, "Özel Eğitim"),
              _buildGridCard(context, Icons.child_care, "Oyun Ablası / Abisi"),
              _buildGridCard(context, Icons.favorite, "Yaşam Koçu"),
            ],
          ),
          const SizedBox(height: 10), // Yüksekliği azaltılmış
          _buildGradientButton(context, 'Uzman Arıyorum', AileGirisEkrani()),
          const SizedBox(height: 5), // Yüksekliği azaltılmış
          _buildGradientButton(context, 'İş Arıyorum', OgretmenGirisEkrani()),
          const SizedBox(height: 10), // Yüksekliği azaltılmış
          OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AileTalepFormu()));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0), // İç padding azaltılmış
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 40,
                  color: Colors.blueAccent), // Icon boyutu küçültülmüş
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
      BuildContext context, String text, Widget targetPage) {
    return Container(
      width: 280, // Buton genişliği azaltılmış
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => targetPage));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: 10), // Buton iç padding azaltılmış
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.white), // Font boyutu küçültülmüş
        ),
      ),
    );
  }
}
