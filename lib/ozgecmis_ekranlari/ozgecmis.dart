import 'dart:convert';
import 'package:evde_bilgi/models/ogretmen_model.dart';
import 'package:evde_bilgi/ozgecmis_ekranlari/ek_bilgi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class OzgecmisimEkrani extends StatefulWidget {
  final String? teacherId; // Öğretmen ID'si

  const OzgecmisimEkrani({required this.teacherId}); // Constructor ile ID almak

  @override
  _OzgecmisimEkraniState createState() => _OzgecmisimEkraniState();
}

class _OzgecmisimEkraniState extends State<OzgecmisimEkrani> {
  String? ad;
  String? ulke;

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

  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _experienceDescriptionController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadTeacherInfo(); // Öğretmen bilgilerini yükle
  }

  Future<void> _loadTeacherInfo() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('ogretmen') // Koleksiyon adı
          .doc(widget.teacherId)
          .get();

      if (userDoc.exists) {
        setState(() {
          ad = userDoc['name'] ?? '';
          ulke = userDoc['nationality'] ?? '';
        });
      }
    } catch (e) {
      print('Kullanıcı bilgileri alınamadı: $e');
    }
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

    if (ad == null || ulke == null || selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eksik veya geçersiz bilgiler!')),
      );
      return;
    }

    try {
      int minSalary = int.tryParse(_minSalaryController.text) ?? 0;
      int maxSalary = int.tryParse(_maxSalaryController.text) ?? 0;

      Teacher ogretmen = Teacher(
        nationality: ulke!,
        name: ad!,
        teacherId: widget.teacherId!,
        selectedCity: selectedCityName!,
        selectedDistrict: selectedDistrictName!,
        selectedExperience: selectedExperience!,
        positions: pozisyonlar
            .asMap()
            .entries
            .where((entry) => seciliPozisyonlar[entry.key])
            .map((entry) => entry.value)
            .toList(),
        workingTypes: calismaSekilleri
            .asMap()
            .entries
            .where((entry) => seciliCalismaSekilleri[entry.key])
            .map((entry) => entry.value)
            .toList(),
        minSalary: minSalary,
        maxSalary: maxSalary,
        experienceDescription: _experienceDescriptionController.text,
        dob: _dobController.text,
      );

      await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(ogretmen.teacherId)
          .update({
        'selectedCity': ogretmen.selectedCity,
        'selectedDistrict': ogretmen.selectedDistrict,
        'selectedExperience': ogretmen.selectedExperience,
        'pozisyonlar': ogretmen.positions,
        'calismaSekilleri': ogretmen.workingTypes,
        'minSalary': ogretmen.minSalary,
        'maxSalary': ogretmen.maxSalary,
        'experienceDescription': ogretmen.experienceDescription,
        'dob': ogretmen.dob,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veriler başarıyla güncellendi!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EkBilgilerEkrani(ogretmen: ogretmen),
        ),
      );
    } catch (e) {
      print('Veri güncelleme hatası: $e');
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text('İleri'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedCityName,
        hint: const Text('Şehir seçin'),
        isExpanded: true,
        items: cities.map((city) {
          return DropdownMenuItem<String>(
            value: city['name'],
            child: Text(city['name']),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCityName = newValue;
            _updateDistricts(); // İlçe listesini güncelle
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedDistrictName,
        hint: const Text('İlçe seçin'),
        isExpanded: true,
        items: districts.map((district) {
          return DropdownMenuItem<String>(
            value: district['name'],
            child: Text(district['name']),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedDistrictName = newValue;
          });
        },
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedExperience,
        hint: const Text('Deneyim seviyenizi seçin'),
        isExpanded: true,
        items: experienceOptions.map((exp) {
          return DropdownMenuItem<String>(
            value: exp,
            child: Text(exp),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedExperience = newValue;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, String label) {
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _dobController,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _dobController.text =
                      '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
                });
              }
            },
          ),
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
