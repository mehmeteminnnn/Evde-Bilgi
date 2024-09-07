import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/giris_sayfalari/ogretmen_giris.dart';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:evde_bilgi/is_ilan/is_ilanlari.dart';
import 'package:evde_bilgi/main.dart';
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
  String? userId;
  File? _image;
  final picker = ImagePicker();

  bool isFormValid() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController2.text.isNotEmpty &&
        nationality != null &&
        isChecked;
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
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Uzman Kayıt',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildTextField('Adınız/Soyadınız', nameController),
              SizedBox(height: 16),
              buildDropdown('Vatandaşlık'),
              SizedBox(height: 16),
              buildTextField('Cep Telefonu', phoneController,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 16),
              buildTextField('E-Posta', emailController,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16),
              buildTextField('Şifre', passwordController, isPassword: true),
              SizedBox(height: 16),
              buildTextField('Şifre Tekrar', passwordController2,
                  isPassword: true),
              SizedBox(height: 16),

              // Fotoğraf yükleme kısmı
              buildImagePicker(),
              SizedBox(height: 16),
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
                  Expanded(
                    child: Text(
                      'Kullanıcı Sözleşmesi ve Gizlilik Politikasını okudum ve kabul ediyorum.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid()
                      ? () async {
                          if (passwordController.text ==
                              passwordController2.text) {
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
                                      builder: (context) => JobListingsPage(
                                            id: newUserId, // Yeni userId'yi kullan
                                          )));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Şifreler uyuşmuyor')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Üye Ol',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OgretmenGirisEkrani()));
                  },
                  child: Text(
                    'Zaten üye misiniz?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (text) {
        setState(() {});
      },
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
          borderSide: BorderSide(color: Colors.black),
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
      padding: EdgeInsets.symmetric(vertical: 16.0),
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
                  child: Text('Fotoğraf Yükle'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                )
              : Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Text('Fotoğrafı Sil'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Future<String?> saveDataToFirestoreTeacher() async {
    try {
      final CollectionReference teachers =
          FirebaseFirestore.instance.collection('teachers');
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('teacher_images/${nameController.text}.jpg');

      if (_image != null) {
        final UploadTask uploadTask = storageReference.putFile(_image!);
        await uploadTask;
      }

      DocumentReference documentRef = await teachers.add({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'nationality': nationality,
        'image_url': await storageReference.getDownloadURL(),
      });

      return documentRef.id;
    } catch (e) {
      print("Error saving data to Firestore: $e");
      return null;
    }
  }
}
