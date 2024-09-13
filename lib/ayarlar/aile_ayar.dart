import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AileAyarlarPage extends StatefulWidget {
  final String? uid;

  AileAyarlarPage({Key? key, this.uid}) : super(key: key);

  @override
  _AileAyarlarPageState createState() => _AileAyarlarPageState();
}

class _AileAyarlarPageState extends State<AileAyarlarPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Kullanıcı verilerini Firestore'dan çekme
  void _fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('aile')
        .doc(widget.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _emailController.text = userDoc['email'] ?? '';
        _passwordController.text = userDoc['password'] ?? '';
      });
    }
  }

  // E-posta güncelleme fonksiyonu
  void _updateEmail() async {
    try {
      await FirebaseFirestore.instance
          .collection('aile')
          .doc(widget.uid)
          .update({'email': _emailController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta başarıyla güncellendi.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-posta güncellenemedi: $e')),
      );
    }
  }

  // Şifre güncelleme fonksiyonu
  void _updatePassword() async {
    try {
      await FirebaseFirestore.instance
          .collection('aile')
          .doc(widget.uid)
          .update({'password': _passwordController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre başarıyla güncellendi.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre güncellenemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aile Ayarları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // E-posta güncelleme
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Yeni E-posta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('E-postayı Güncelle'),
            ),
            const SizedBox(height: 20),
            // Şifre güncelleme
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePassword,
              child: const Text('Şifreyi Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
