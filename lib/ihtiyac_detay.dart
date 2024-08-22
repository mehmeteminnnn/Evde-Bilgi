import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/maas_sayfa.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final controlller = TextEditingController();
  final controlller2 = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    controlller.addListener(_onTextChanged);
    controlller2.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isButtonActive =
          controlller.text.isNotEmpty && controlller2.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    controlller.dispose();
    controlller2.dispose();
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
              'İhtiyaçlarınızı Detaylandırınız',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'İhtiyaçlarınızı detaylıca belirtiniz.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controlller,
              decoration: InputDecoration(
                labelText: 'Başlık',
                hintText: 'Örnek: Çocuğum İçin Gölge Öğretmen Arıyorum',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controlller2,
              decoration: InputDecoration(
                labelText: 'İlan Detayı Giriniz',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalaryPage(),
                          ),
                        );
                      }
                    : null,
                child: Text('İleri'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
