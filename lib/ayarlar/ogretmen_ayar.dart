import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AyarlarPage extends StatefulWidget {
  final String? uid;

  AyarlarPage({Key? key, this.uid}) : super(key: key);

  @override
  _AyarlarPageState createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Kullanıcı verilerini Firestore'dan çekme
  void _fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('ogretmen')
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
          .collection('ogretmen')
          .doc(widget.uid)
          .update({'email': _emailController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('E-posta başarıyla güncellendi.')),
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
          .collection('ogretmen')
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

  // Fotoğraf güncelleme fonksiyonu
  Future<void> _updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Burada resmi Firestore'a yüklemek için gerekli kodu ekleyebilirsin
      // Örneğin Firebase Storage kullanarak resmi yükleyip, URL'yi Firestore'a kaydedebilirsin.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil fotoğrafı güncelleme
            _image == null
                ? const Icon(Icons.account_circle, size: 100)
                : Image.file(_image!, height: 100, width: 100),
            ElevatedButton(
              onPressed: _updateProfileImage,
              child: const Text('Profil Fotoğrafını Güncelle'),
            ),
            const SizedBox(height: 20),
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
