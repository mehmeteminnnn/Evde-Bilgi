import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/giris_sayfalari/ogretmen_giris.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart'; // Güncel sayfa yolunu kontrol edin
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordController2 = TextEditingController();

String? nationality = "";

class TeacherRegisterPage extends StatefulWidget {
  @override
  State<TeacherRegisterPage> createState() => _TeacherRegisterPageState();
}

class _TeacherRegisterPageState extends State<TeacherRegisterPage> {
  bool isChecked = false;
  File? _image;
  final picker = ImagePicker();

  bool isFormValid() {
    return nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController2.text.isNotEmpty &&
        nationality != null &&
        isChecked &&
        passwordController.text == passwordController2.text;
  }

  Future<String?> saveDataToFirestoreTeacher() async {
    try {
      final CollectionReference teachers =
          FirebaseFirestore.instance.collection('ogretmen');
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('teacher_images/${nameController.text}.jpg');

      String? imageUrl;

      if (_image != null) {
        final UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask.whenComplete(() async {
          try {
            imageUrl = await storageReference.getDownloadURL();
          } catch (e) {
            print("Error getting download URL: $e");
            imageUrl = "";
          }
        });
      }

      DocumentReference documentRef = await teachers.add({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'nationality': nationality,
        'image_url': imageUrl ?? "", // imageUrl boş ise boş string kullan
        'createdAt': FieldValue.serverTimestamp(),
      });

      return documentRef.id;
    } catch (e) {
      print("Error saving data to Firestore: $e");
      return null;
    }
  }

  Future<bool> isPhoneOrEmailRegistered(String phone, String email) async {
    final CollectionReference teachers =
        FirebaseFirestore.instance.collection('ogretmen');
    final querySnapshot = await teachers
        .where('phone', isEqualTo: phone)
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: const EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Uzman Kayıt',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              buildTextField('Adınız/Soyadınız', nameController),
              const SizedBox(height: 16),
              buildDropdown('Vatandaşlık'),
              const SizedBox(height: 16),
              buildTextField('Cep Telefonu', phoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              buildTextField('E-Posta', emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              buildTextField('Şifre', passwordController, isPassword: true),
              const SizedBox(height: 16),
              buildTextField('Şifre Tekrar', passwordController2,
                  isPassword: true),
              const SizedBox(height: 16),

              // Fotoğraf yükleme kısmı
              buildImagePicker(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Kullanıcı Sözleşmesi ve Gizlilik Politikasını okudum ve kabul ediyorum.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid()
                      ? () async {
                          final phone = phoneController.text;
                          final email = emailController.text;

                          if (isValidEmail(email) == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Geçerli bir e-posta adresi giriniz.'),
                              ),
                            );
                            return;
                          }

                          // Telefon veya e-posta zaten kayıtlı mı kontrol et
                          if (await isPhoneOrEmailRegistered(phone, email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Bu telefon numarası veya e-posta zaten kayıtlı.'),
                              ),
                            );
                            return;
                          }

                          String? newUserId =
                              await saveDataToFirestoreTeacher();
                          if (newUserId != null) {
                            // Form alanlarını temizleme
                            setState(() {
                              nameController.clear();
                              phoneController.clear();
                              emailController.clear();
                              passwordController.clear();
                              passwordController2.clear();
                              nationality = "";
                              isChecked = false;
                              _image = null;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JobListingsPage(id: newUserId),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Veriler kaydedilemedi.'),
                              ),
                            );
                          }
                        }
                      : null,
                  child: const Text('Kayıt Ol'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildDropdown(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: <String>['Türkiye', 'Diğer']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          nationality = newValue;
        });
      },
    );
  }

  Widget buildImagePicker() {
    return Container(
      width: double.infinity, // TextField'larla aynı genişlikte
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _image == null
              ? ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Fotoğraf Yükle'),
                )
              : Image.file(
                  _image!,
                  width: 100,
                  height: 100,
                ),
          const SizedBox(height: 16),
          if (_image != null)
            ElevatedButton(
              onPressed: () => setState(() => _image = null),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Fotoğrafı Sil'),
            ),
        ],
      ),
    );
  }
}
