import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AileTalepFormu extends StatefulWidget {
  @override
  _AileTalepFormuState createState() => _AileTalepFormuState();
}

class _AileTalepFormuState extends State<AileTalepFormu> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _ilController = TextEditingController();
  final TextEditingController _cepNoController = TextEditingController();
  final TextEditingController _ikinciNoController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _ogrenciAdSoyadController =
      TextEditingController();
  final TextEditingController _ogrenciYasController = TextEditingController();
  final TextEditingController _gelisimController = TextEditingController();
  final TextEditingController _talepIcerigiController = TextEditingController();
  final TextEditingController _talepGunSaatController = TextEditingController();
  final TextEditingController _ekstraController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // Şifre kontrolcüsü

  // SMTP Mail Gönderme
  Future<void> sendEmail() async {
    String username = 'mhmtmntok@gmail.com'; // Gmail adresiniz
    String password = 'parv prob uyvs zfdv'; // Gmail şifreniz

    final smtpServer = gmail(username, password); // Gmail SMTP server
    final message = Message()
      ..from = Address(username, 'Aile Talep Formu')
      ..recipients.add('tok835918@gmail.com') // Gönderilecek e-posta adresi
      ..subject = 'Aile Talep Formu: ${_adSoyadController.text}'
      ..html = '''
    <h3>Aile Talep Formu</h3>
    <p><strong>Ebeveyn Adı Soyadı:</strong> ${_adSoyadController.text}</p>
    <p><strong>İl/İlçe:</strong> ${_ilController.text}</p>
    <p><strong>Cep No:</strong> ${_cepNoController.text}</p>
    <p><strong>İkinci No:</strong> ${_ikinciNoController.text}</p>
    <p><strong>Mail Adresi:</strong> ${_mailController.text}</p>
    <p><strong>Öğrencinin Adı Soyadı:</strong> ${_ogrenciAdSoyadController.text}</p>
    <p><strong>Öğrencinin Yaşı:</strong> ${_ogrenciYasController.text}</p>
    <p><strong>Gelişim Bilgisi:</strong> ${_gelisimController.text}</p>
    <p><strong>Talep İçeriği:</strong> ${_talepIcerigiController.text}</p>
    <p><strong>Talep Gün/Saat:</strong> ${_talepGunSaatController.text}</p>
    <p><strong>Ekstra Bilgiler:</strong> ${_ekstraController.text}</p>
    <p><strong>Şifre:</strong> ${_passwordController.text}</p>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('E-posta başarıyla gönderildi: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('E-posta gönderilemedi. Hata: $e');
    }
  }

  // Form Onaylandığında Firestore'a Kayıt
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Mail gönderme işlemi
      await sendEmail();

      // Firestore'a veriyi ekleme
      await FirebaseFirestore.instance.collection('ailetalepformları').add({
        'name': _adSoyadController.text,
        'il': _ilController.text,
        'phone': _cepNoController.text,
        'ikinciNo': _ikinciNoController.text,
        'email': _mailController.text,
        'ogrenciAdSoyad': _ogrenciAdSoyadController.text,
        'ogrenciYas': _ogrenciYasController.text,
        'gelisimBilgisi': _gelisimController.text,
        'talepIcerigi': _talepIcerigiController.text,
        'talepGunSaat': _talepGunSaatController.text,
        'ekstra': _ekstraController.text,
        'password': _passwordController.text, // Şifreyi de Firestore'a kaydet
      });

      // Başarılı kaydedildiğinde kullanıcıya bildirim göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Form başarıyla gönderildi ve kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aile Talep Formu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Ebeveyn Adı Soyadı', _adSoyadController),
              buildTextField('İl/İlçe', _ilController),
              buildTextField('Cep No', _cepNoController),
              buildTextField(
                  'Ulaşılamaması Durumunda İkinci No', _ikinciNoController),
              buildTextField('Mail Adresi', _mailController),
              buildTextField(
                  'Öğrencinin Adı Soyadı', _ogrenciAdSoyadController),
              buildTextField('Öğrencinin Yaşı', _ogrenciYasController),
              buildTextField(
                  'Özel Gelişim/Tipik Gelişim Bilgisi', _gelisimController),
              buildTextField(
                  'Talep İçeriği (Gölge Öğretmen, Oyun Ablası/Abisi)',
                  _talepIcerigiController),
              buildTextField(
                  'Talep Ettiğiniz Gün/Saat Aralığı', _talepGunSaatController),
              buildTextField('Başka Eklemek İstedikleriniz', _ekstraController),
              buildPasswordField('Şifre', _passwordController), // Şifre alanı
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Formu Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tekrarlayan TextField Yapısı
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen bu alanı doldurun';
          }
          return null;
        },
      ),
    );
  }

  // Şifre için özel alan
  Widget buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: true, // Şifre gizleme özelliği
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen bu alanı doldurun';
          }
          return null;
        },
      ),
    );
  }
}
