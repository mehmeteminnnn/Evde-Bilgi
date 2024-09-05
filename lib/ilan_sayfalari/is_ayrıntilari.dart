import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_sayfalari/ihtiyac_detay.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class JobSelectionPage extends StatefulWidget {
  final JobModel jobModel;
  JobSelectionPage({required this.jobModel});
  @override
  _JobSelectionPageState createState() => _JobSelectionPageState();
}

class _JobSelectionPageState extends State<JobSelectionPage> {
  List<String> selectedJobTypes = [];
  TextEditingController hoursController = TextEditingController();
  List<String> selectedDays = [];
  bool anyDay = false;

  final List<String> daysOfWeek = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
    'Fark etmez'
  ];

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
              'Haftanın hangi günleri çalışmak istersiniz?',
              style: TextStyle(fontSize: 16),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: daysOfWeek.map((day) => _buildDayButton(day)).toList(),
            ),
            Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormComplete()
                      ? () {
                          widget.jobModel.jobTypes = selectedJobTypes;
                          widget.jobModel.hoursPerDay =
                              hoursController.text.trim();
                          widget.jobModel.workingDays =
                              anyDay ? ['Fark etmez'] : selectedDays;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                jobModel: widget.jobModel,
                              ),
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

  Widget _buildDayButton(String day) {
    final isSelected = selectedDays.contains(day);
    final isAnyDaySelected = day == 'Fark etmez';

    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (isAnyDaySelected) {
            anyDay = !anyDay;
            if (anyDay) {
              selectedDays.clear();
            }
          } else {
            if (anyDay) return; // Fark etmez seçiliyse diğer günler seçilemez
            if (isSelected) {
              selectedDays.remove(day);
            } else {
              selectedDays.add(day);
            }
          }
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected || (isAnyDaySelected && anyDay) ? Colors.blue : null,
      ),
      child: Text(day),
    );
  }

  bool isFormComplete() {
    return selectedJobTypes.isNotEmpty &&
        hoursController.text.isNotEmpty &&
        (anyDay || selectedDays.isNotEmpty);
  }
}
