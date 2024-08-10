import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:flutter/material.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordController2 = TextEditingController();
String? nationaility = "";

class TeacherRegisterPage extends StatefulWidget {
  @override
  State<TeacherRegisterPage> createState() => _TeacherRegisterPageState();
}

class _TeacherRegisterPageState extends State<TeacherRegisterPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue.shade100,
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öğretmen Kayıt',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildTextField('Adınız/Soyadınız', nameController),
              SizedBox(height: 16),
              buildDropdown('Vatandaşlık'),
              SizedBox(height: 16),
              buildTextField('Cep Telefonu', phoneController),
              SizedBox(height: 16),
              buildTextField('E-Posta', emailController),
              SizedBox(height: 16),
              buildTextField('Şifre', passwordController, isPassword: true),
              SizedBox(height: 16),
              buildTextField('Şifre Tekrar', passwordController2,
                  isPassword: true),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? true;
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
                  onPressed: () {
                    saveDataToFirestoreTeacher();
                  },
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
                  onPressed: () {},
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
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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
        nationaility = newValue;
      },
    );
  }

  Future<void> saveDataToFirestoreTeacher() async {
    // Firestore bağlantısını kurun
    final firestore = FirebaseFirestore.instance;

    // Firestore'a veri ekleyin
    await firestore.collection('ogretmen').add({
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
      "nationality": nationaility,
    });
  }
}
