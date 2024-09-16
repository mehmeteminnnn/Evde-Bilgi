import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/giris_sayfalari/aile_girisi.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_listeleri.dart';
import 'package:flutter/material.dart';

final TextEditingController familyNameController = TextEditingController();
final TextEditingController familyPhoneController = TextEditingController();
final TextEditingController familyEmailController = TextEditingController();
final TextEditingController familyPasswordController = TextEditingController();
final TextEditingController familyPasswordController2 = TextEditingController();

class FamilyRegisterPage extends StatefulWidget {
  @override
  State<FamilyRegisterPage> createState() => _FamilyRegisterPageState();
}

class _FamilyRegisterPageState extends State<FamilyRegisterPage> {
  bool isChecked = false;
  String? familyId;
  Future<bool> isPhoneOrEmailRegistered(String phone, String email) async {
    final CollectionReference teachers =
        FirebaseFirestore.instance.collection('aile');
    final querySnapshot = await teachers
        .where('phone', isEqualTo: phone)
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isFormValid() {
    return familyNameController.text.isNotEmpty &&
        familyPhoneController.text.isNotEmpty &&
        familyEmailController.text.isNotEmpty &&
        familyPasswordController.text.isNotEmpty &&
        familyPasswordController2.text.isNotEmpty &&
        isChecked;
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
                'Aile Kayıt',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              buildTextField('Adınız/Soyadınız', familyNameController),
              const SizedBox(height: 16),
              buildTextField('Cep Telefonu', familyPhoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              buildTextField('E-Posta', familyEmailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              buildTextField('Şifre', familyPasswordController,
                  isPassword: true),
              const SizedBox(height: 16),
              buildTextField('Şifre Tekrar', familyPasswordController2,
                  isPassword: true),
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
                          final phone = familyPhoneController.text;
                          final email = familyEmailController.text;
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
                          if (familyPasswordController.text ==
                              familyPasswordController2.text) {
                            familyId = await saveDataToFirestoreFamily();
                            if (familyId != null) {
                              setState(() {
                                familyNameController.clear();
                                familyPhoneController.clear();
                                familyEmailController.clear();
                                familyPasswordController.clear();
                                familyPasswordController2.clear();
                                isChecked = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherListPage(
                                            id: familyId,
                                          )));
                              // Kayıt başarılı olduğunda yapılacak işlemler
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Aile kaydı başarılı!')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Şifreler uyuşmuyor')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Üye Ol',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AileGirisEkrani()));
                  },
                  child: const Text(
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
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (text) {
        setState(() {}); // Butonun durumunu kontrol etmek için
      },
    );
  }

  Future<String?> saveDataToFirestoreFamily() async {
    final firestore = FirebaseFirestore.instance;

    DocumentReference docRef = await firestore.collection('aile').add({
      'name': familyNameController.text,
      'phone': familyPhoneController.text,
      'email': familyEmailController.text,
      'password': familyPasswordController.text, // Şifreyi hashleyin
      'createdAt': FieldValue.serverTimestamp(),
    });

    String familyId = docRef.id;
    return familyId;
  }
}
