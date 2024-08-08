import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/app_bar.dart';
import 'package:flutter/material.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordController2 = TextEditingController();
var isChecked = false;

class FamilyRegisterPage extends StatefulWidget {
  @override
  State<FamilyRegisterPage> createState() => _FamilyRegisterPageState();
}

class _FamilyRegisterPageState extends State<FamilyRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aile Kayıt',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildTextField('Adınız/Soyadınız', nameController),
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
                        isChecked = value!;
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
                    onPressed: saveDataToFirestore,
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
                  )),
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

  Future<void> saveDataToFirestore() async {
    // Firestore bağlantısını kurun
    final firestore = FirebaseFirestore.instance;

    // Verileri bir haritaya dönüştürün
    Map<String, dynamic> userData = {
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    // Verileri Firestore'a yazın
    if(passwordController.text == passwordController2.text){
    await firestore.collection('aile').add(userData);}
    else{
       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
           title: Text('Hata'),
           content: Text('Şifreler uyuşmuyor.'),
           actions: [
            TextButton(
              onPressed: () {
               Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
           ],
          );
        },
       );
    }
  }
}
