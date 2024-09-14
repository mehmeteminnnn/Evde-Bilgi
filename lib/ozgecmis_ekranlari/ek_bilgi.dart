import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/models/ogretmen_model.dart';
import 'package:flutter/material.dart';

class EkBilgilerEkrani extends StatefulWidget {
  final Teacher ogretmen;
  EkBilgilerEkrani({required this.ogretmen});

  @override
  _EkBilgilerEkraniState createState() => _EkBilgilerEkraniState();
}

class _EkBilgilerEkraniState extends State<EkBilgilerEkrani> {
  String? cinsiyet;
  String? egitimSeviyesi;
  String? tibbiEgitim;
  String? egitimFakultesi;
  String? sahsiAraba;
  String? ehliyet;
  String? pasaport;
  String? sigara;
  String? kamera;
  String? evcilHayvan;
  String? katildiginKurslar;
  String? konustugunDiller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Ek Bilgiler'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDropdown('Cinsiyet', ['Erkek', 'Kadın'], cinsiyet,
                  (newValue) {
                setState(() {
                  cinsiyet = newValue;
                });
              }),
              _buildDropdown(
                  'Eğitim Seviyesi',
                  ['Lise', 'Ön Lisans', 'Lisans', 'Yüksek Lisans', 'Doktora'],
                  egitimSeviyesi, (newValue) {
                setState(() {
                  egitimSeviyesi = newValue;
                });
              }),
              _buildDropdown(
                  'Tıbbi eğitim aldınız mı?', ['Evet', 'Hayır'], tibbiEgitim,
                  (newValue) {
                setState(() {
                  tibbiEgitim = newValue;
                });
              }),
              _buildDropdown('Eğitim fakültesinden mezun musunuz?',
                  ['Evet', 'Hayır'], egitimFakultesi, (newValue) {
                setState(() {
                  egitimFakultesi = newValue;
                });
              }),
              _buildDropdown(
                  'Şahsi arabanız var mı?', ['Evet', 'Hayır'], sahsiAraba,
                  (newValue) {
                setState(() {
                  sahsiAraba = newValue;
                });
              }),
              _buildDropdown('Ehliyetiniz var mı?', ['Evet', 'Hayır'], ehliyet,
                  (newValue) {
                setState(() {
                  ehliyet = newValue;
                });
              }),
              _buildDropdown(
                  'Pasaportunuz var mı?', ['Evet', 'Hayır'], pasaport,
                  (newValue) {
                setState(() {
                  pasaport = newValue;
                });
              }),
              _buildDropdown(
                  'Sigara kullanıyor musunuz?', ['Evet', 'Hayır'], sigara,
                  (newValue) {
                setState(() {
                  sigara = newValue;
                });
              }),
              _buildDropdown(
                  'Kameraların bulunduğu yerde çalışmak ister misiniz?',
                  ['Evet', 'Hayır'],
                  kamera, (newValue) {
                setState(() {
                  kamera = newValue;
                });
              }),
              _buildDropdown(
                  'Evcil hayvanların olduğu yerde çalışmak ister misiniz?',
                  ['Evet', 'Hayır'],
                  evcilHayvan, (newValue) {
                setState(() {
                  evcilHayvan = newValue;
                });
              }),
              _buildTextField('Katıldığınız Kurslar', (newValue) {
                setState(() {
                  katildiginKurslar = newValue;
                });
              }),
              _buildTextField('Konuştuğunuz Diller', (newValue) {
                setState(() {
                  konustugunDiller = newValue;
                });
              }),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('İptal', Colors.red, () {
                    Navigator.pop(context);
                  }),
                  _buildButton('Kaydet', Colors.green, () {
                    _saveData();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, ValueChanged<String>? onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdown(String labelText, List<String> items, String? value,
      ValueChanged<String?>? onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _saveData() async {
    final teacherRef = FirebaseFirestore.instance
        .collection('ogretmen')
        .doc(widget.ogretmen.teacherId);

    final updatedTeacher = Teacher(
      teacherId: widget.ogretmen.teacherId,
      workingTypes: widget.ogretmen.workingTypes,
      dob: widget.ogretmen.dob,
      experienceDescription: widget.ogretmen.experienceDescription,
      maxSalary: widget.ogretmen.maxSalary,
      minSalary: widget.ogretmen.minSalary,
      name: widget.ogretmen.name,
      nationality: widget.ogretmen.nationality,
      positions: widget.ogretmen.positions,
      selectedCity: widget.ogretmen.selectedCity,
      selectedDistrict: widget.ogretmen.selectedDistrict,
      selectedExperience: widget.ogretmen.selectedExperience,
      gender: cinsiyet,
      educationLevel: egitimSeviyesi,
      medicalEducation: tibbiEgitim,
      educationFaculty: egitimFakultesi,
      personalCar: sahsiAraba,
      drivingLicense: ehliyet,
      passport: pasaport,
      smokingHabit: sigara,
      workingInCameraEnvironment: kamera,
      workingInPetEnvironment: evcilHayvan,
      attendedCourses: katildiginKurslar,
      spokenLanguages: konustugunDiller,
    );

    await teacherRef
        .set(updatedTeacher.toJson(), SetOptions(merge: true))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veri başarıyla kaydedildi!')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $error')),
      );
    });
  }
}
