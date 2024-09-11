import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_haz%C4%B1r.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class SalaryPage extends StatefulWidget {
  final JobModel jobModel;

  SalaryPage({required this.jobModel}); // JobModel nesnesi alınır

  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  final TextEditingController _salaryController = TextEditingController();
  bool _isNegotiable = false; // Checkbox durumu
  bool _isButtonActive = false; // Butonun aktif olup olmadığını kontrol eder

  @override
  void initState() {
    super.initState();
    _salaryController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isButtonActive = _salaryController.text.isNotEmpty || _isNegotiable;
    });
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _isNegotiable = value ?? false;
      _isButtonActive = _salaryController.text.isNotEmpty || _isNegotiable;
    });
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: const EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maaş Belirtiniz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ücret belirtmeniz başvuru sayısını yükseltecektir.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Günlük Ücret',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isNegotiable,
                  onChanged: _onCheckboxChanged,
                ),
                const Text('Ücret karşılıklı görüşülecektir'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonActive
                    ? () {
                        print(widget.jobModel.userId);
                        // Eğer maaş belirtildiyse onu kullan, belirtilmediyse "Ücret karşılıklı görüşülecektir" seçeneği işaretlenmişse salary "" olacak
                        widget.jobModel.salary =
                            _isNegotiable ? "" : _salaryController.text.trim();
                        widget.jobModel.isNegotiable = _isNegotiable;
                        widget.jobModel.publishDate = Timestamp.now();

                        // Firestore'a veriyi kaydetme
                        FirebaseFirestore.instance
                            .collection('ilanlar')
                            .add(
                              widget.jobModel.toMap(),
                            )
                            .then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuccessPage(),
                            ),
                          );
                        }).catchError((error) {
                          // Eğer Firestore'a veri kaydedilirken bir hata oluşursa
                          print("Veri kaydedilirken hata oluştu: $error");
                        });
                      }
                    : null, // Eğer form tamamlanmadıysa buton devre dışı kalır
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'İleri',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
