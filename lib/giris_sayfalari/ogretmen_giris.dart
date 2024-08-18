import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OgretmenGirisEkrani extends StatefulWidget {
  @override
  _OgretmenGirisEkraniState createState() => _OgretmenGirisEkraniState();
}

class _OgretmenGirisEkraniState extends State<OgretmenGirisEkrani> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _girisYap() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('ogretmen')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Giriş başarılı
        String userId = querySnapshot.docs.first.id;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobListingsPage(
                id: userId,
              ),
            )); // İstediğiniz yere yönlendirme yapabilirsiniz
      } else {
        // Giriş başarısız
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E-posta veya şifre hatalı!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hata durumu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Öğretmen Girişi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // E-posta Giriş Alanı
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 16),

            // Şifre Giriş Alanı
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 32),

            // Giriş Butonu
            ElevatedButton(
              onPressed: _girisYap,
              child: Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            // İptal Butonu
            TextButton(
              onPressed: () {
                _emailController.clear();
                _passwordController.clear();
              },
              child: Text('İptal'),
            ),
          ],
        ),
      ),
    );
  }
}
