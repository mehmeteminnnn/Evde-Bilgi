import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class OzgecmisimEkrani extends StatefulWidget {
  final String? teacherId; // Öğretmen ID'si

  OzgecmisimEkrani({required this.teacherId}); // Constructor ile ID almak

  @override
  _OzgecmisimEkraniState createState() => _OzgecmisimEkraniState();
}

class _OzgecmisimEkraniState extends State<OzgecmisimEkrani> {
  List<String> pozisyonlar = [
    'Gölge Öğretmen',
    'Oyun Ablası/Abisi',
    'Özel Eğitim',
    'Yaşam Koçu'
  ];
  List<bool> seciliPozisyonlar = [false, false, false, false];

  List<String> calismaSekilleri = [
    'Tam zamanlı',
    'Yarı zamanlı',
    'Geçici',
    'Günlük',
    'Saatlik',
    'Yatılı'
  ];
  List<bool> seciliCalismaSekilleri = [
    false,
    false,
    false,
    false,
    false,
    false
  ];

  String? selectedCityName;
  String? selectedDistrictName;

  List<dynamic> cities = [];
  List<dynamic> districts = [];

  String? selectedExperience;
  List<String> experienceOptions = ['0-1 yıl', '1-5 yıl', '5+ yıl'];

  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();
  TextEditingController _experienceDescriptionController =
      TextEditingController();
  TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    String cityJson = await rootBundle.loadString('assets/il.json');
    List<Map<String, dynamic>> cityList =
        List<Map<String, dynamic>>.from(jsonDecode(cityJson));

    cityList.sort((a, b) => a['name'].compareTo(b['name']));

    setState(() {
      cities = cityList;
      if (cities.isNotEmpty) {
        selectedCityName = cities.first['name']; // İlk şehir seçili olacak
      }
    });
    _updateDistricts();
  }

  Future<void> _updateDistricts() async {
    String districtJson = await rootBundle.loadString('assets/ilce.json');
    List<dynamic> allDistricts = jsonDecode(districtJson);

    setState(() {
      districts = allDistricts
          .where((district) =>
              district['il_id'].toString() ==
              cities
                  .firstWhere((city) => city['name'] == selectedCityName)['id'])
          .toList();
      if (districts.isNotEmpty) {
        selectedDistrictName =
            districts.first['name']; // İlk ilçe seçili olacak
      }
    });
  }

  Future<void> _updateTeacher() async {
    if (selectedCityName == null || selectedDistrictName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şehir ve ilçe seçiminizi yapmalısınız!')),
      );
      return;
    }

    try {
      String? teacherId = widget.teacherId; // Öğretmen ID'sini al

      await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(teacherId)
          .update({
        'selectedCity': selectedCityName,
        'selectedDistrict': selectedDistrictName,
        'selectedExperience': selectedExperience,
        'pozisyonlar': pozisyonlar
            .asMap()
            .entries
            .where((entry) => seciliPozisyonlar[entry.key])
            .map((entry) => entry.value)
            .toList(),
        'calismaSekilleri': calismaSekilleri
            .asMap()
            .entries
            .where((entry) => seciliCalismaSekilleri[entry.key])
            .map((entry) => entry.value)
            .toList(),
        'minSalary': _minSalaryController.text,
        'maxSalary': _maxSalaryController.text,
        'experienceDescription': _experienceDescriptionController.text,
        'dob': _dobController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veriler başarıyla güncellendi!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veri güncelleme hatası!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Özgeçmişim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCityDropdown(),
            _buildDistrictDropdown(),
            _buildDatePicker(context, 'Doğum Tarihi'),
            _buildExperienceDropdown(),
            const SizedBox(height: 20),
            const Text(
              'Çalışmak İstediğiniz Pozisyonlar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                pozisyonlar.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(pozisyonlar[index]),
                    selected: seciliPozisyonlar[index],
                    onSelected: (bool selected) {
                      setState(() {
                        seciliPozisyonlar[index] = selected;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Çalışma Şekli',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: List<Widget>.generate(
                calismaSekilleri.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(calismaSekilleri[index]),
                    selected: seciliCalismaSekilleri[index],
                    onSelected: (bool selected) {
                      setState(() {
                        seciliCalismaSekilleri[index] = selected;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 20),
            _buildTextField('Minimum aylık maaş (TL)',
                controller: _minSalaryController),
            _buildTextField('Maksimum aylık maaş (TL)',
                controller: _maxSalaryController),
            _buildTextField('İş deneyiminizi ve görevlerinizi tanımlayın.',
                maxLines: 3, controller: _experienceDescriptionController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTeacher,
              child: const Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
            ),
            TextButton(
              onPressed: () {
                // İptal işlemi
              },
              child: const Text('İptal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
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
        decoration: InputDecoration(
          labelText: 'İl seçiniz',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedCityName,
        items: cities.map<DropdownMenuItem<String>>((city) {
          return DropdownMenuItem<String>(
            child: Text(city['name']),
            value: city['name'],
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCityName = value;
            selectedDistrictName = null; // Seçili ilçeyi sıfırla
            _updateDistricts(); // İlçeleri güncelle
          });
        },
      ),
    );
  }

  Widget _buildDistrictDropdown() {
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
        decoration: InputDecoration(
          labelText: 'İlçe seçiniz',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedDistrictName,
        items: districts.map<DropdownMenuItem<String>>((district) {
          return DropdownMenuItem<String>(
            child: Text(district['name']),
            value: district['name'],
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDistrictName = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(String labelText,
      {int maxLines = 1, TextEditingController? controller}) {
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
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
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
      ),
    );
  }

  Widget _buildExperienceDropdown() {
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
        decoration: InputDecoration(
          labelText: 'Deneyim Seviyesi',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        value: selectedExperience,
        items: experienceOptions.map<DropdownMenuItem<String>>((experience) {
          return DropdownMenuItem<String>(
            child: Text(experience),
            value: experience,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedExperience = value;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String labelText) {
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
      child: TextFormField(
        controller: _dobController,
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
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _dobController.text =
                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
            });
          }
        },
      ),
    );
  }
}
