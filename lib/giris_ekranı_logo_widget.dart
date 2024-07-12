import 'package:flutter/material.dart';

class giris_ekrani extends StatelessWidget {
  final IconData iconData;
  final String text;

  const giris_ekrani({super.key, required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Icon(
            iconData,
            size: 50,
          ),
          SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
