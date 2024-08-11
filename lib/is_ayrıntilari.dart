import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ihtiyac_detay.dart';
import 'package:flutter/material.dart';

class JobSelectionPage extends StatefulWidget {
  @override
  _JobSelectionPageState createState() => _JobSelectionPageState();
}

class _JobSelectionPageState extends State<JobSelectionPage> {
  List<String> selectedJobTypes = [];
  TextEditingController hoursController = TextEditingController();
  String? urgency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: EvdeBilgiAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'İş Türü*',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildJobTypeButton('Tam zamanlı'),
                _buildJobTypeButton('Yarı zamanlı'),
                _buildJobTypeButton('Geçici'),
                _buildJobTypeButton('Günlük'),
                _buildJobTypeButton('Saatlik'),
                _buildJobTypeButton('Yatılı'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Günlük kaç saat?',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(
                    () {}); // TextField değiştiğinde buton durumu güncellenir
              },
            ),
            SizedBox(height: 20),
            Text(
              'Ne kadar acil ihtiyacınız var?',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButtonFormField<String>(
              items: <String>['Hemen', '1 hafta içinde', '2 hafta içinde']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  urgency = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormComplete()
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(),
                            ),
                          );
                        }
                      : null, // Form eksikse buton devre dışı kalır
                  child: Text('İleri'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildJobTypeButton(String label) {
    final isSelected = selectedJobTypes.contains(label);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedJobTypes.remove(label);
          } else {
            selectedJobTypes.add(label);
          }
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : null,
      ),
      child: Text(label),
    );
  }

  bool isFormComplete() {
    return selectedJobTypes.isNotEmpty &&
        hoursController.text.isNotEmpty &&
        urgency != null;
  }
}
