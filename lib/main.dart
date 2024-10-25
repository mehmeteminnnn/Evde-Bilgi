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

        // Daha yumuşak bir arka plan rengi
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.indigo.shade400, // AppBar arka planı için daha hoş bir ton
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Lato', // Daha yumuşak bir font ailesi
          ),
          centerTitle: true, // Başlığın ortalanması
          elevation: 2, // AppBar gölgesi
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
          const SizedBox(height: 20),
          const Text(
            'Ebeveynler ve Uzmanları\nBir Araya Getiren\nYeni Nesil Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: <Widget>[
              _buildGridCard(context, Icons.school, "Gölge Öğretmen"),
              _buildGridCard(context, Icons.book, "Özel Eğitim"),
              _buildGridCard(context, Icons.child_care, "Oyun Ablası / Abisi"),
              _buildGridCard(context, Icons.favorite, "Yaşam Koçu"),
            ],
          ),
          const SizedBox(height: 20),
          _buildGradientButton(context, 'Uzman Arıyorum', AileGirisEkrani()),
          const SizedBox(height: 10),
          _buildGradientButton(context, 'İş Arıyorum', OgretmenGirisEkrani()),
          const SizedBox(height: 20),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      width: 300,
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
