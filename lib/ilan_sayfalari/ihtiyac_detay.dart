import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_sayfalari/maas_sayfa.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final JobModel jobModel;

  DetailPage({required this.jobModel});
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
      appBar: const EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İhtiyaçlarınızı Detaylandırınız',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'İhtiyaçlarınızı detaylıca belirtiniz.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controlller,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                hintText: 'Örnek: Çocuğum İçin Gölge Öğretmen Arıyorum',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controlller2,
              decoration: const InputDecoration(
                labelText: 'İlan Detayı Giriniz',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        print(widget.jobModel.userId);
                        widget.jobModel.title = controlller.text;
                        widget.jobModel.details = controlller2.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalaryPage(
                              jobModel: widget.jobModel,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('İleri'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
