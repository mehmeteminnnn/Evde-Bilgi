import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedCity;
  String? selectedPosition;
  String? selectedWorkType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtreler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdown('Şehir', ['İstanbul', 'Ankara', 'İzmir'], (value) {
              setState(() {
                selectedCity = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdown('Pozisyonlar', ['Gölge Öğretmen', 'Diğer'], (value) {
              setState(() {
                selectedPosition = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdown('Çalışma Şekli', ['Part Time', 'Full Time'], (value) {
              setState(() {
                selectedWorkType = value;
              });
            }),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Filtreleme işlemi burada yapılacak
              },
              child: Text('Filtreyi Uygula'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
