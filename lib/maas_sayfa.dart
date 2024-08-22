import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_haz%C4%B1r.dart';
import 'package:flutter/material.dart';

class SalaryPage extends StatefulWidget {
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
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maaş Belirtiniz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Ücret belirtmeniz başvuru sayısını yükseltecektir.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Günlük Ücret',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isNegotiable,
                  onChanged: _onCheckboxChanged,
                ),
                Text('Ücret karşılıklı görüşülecektir'),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonActive
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessPage(),
                          ),
                        );
                      }
                    : null, // Eğer form tamamlanmadıysa buton devre dışı kalır
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
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
