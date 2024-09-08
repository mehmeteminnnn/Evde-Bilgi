import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_sayfalari/ogretmen_bilgi.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class IlanVer extends StatefulWidget {
  final JobModel jobModel;
  final String userId; // Kullanıcı ID'si eklenir
  IlanVer({required this.jobModel, required this.userId});
  @override
  State<IlanVer> createState() => _IlanVerState();
}

class _IlanVerState extends State<IlanVer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: const EvdeBilgiAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kime ihtiyacınız var?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  widget.jobModel.position = "Gölge Öğretmen";
                  widget.jobModel.userId = widget.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalismaAdresiScreen(
                        jobModel: widget.jobModel,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Gölge Öğretmen',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  widget.jobModel.position = "Özel Eğitim";
                  widget.jobModel.userId = widget.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.book, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Özel Eğitim',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  print(widget.userId);
                  widget.jobModel.position = "Oyun Ablası / Abisi";
                  widget.jobModel.userId = widget.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.child_care, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Oyun Ablası / Abisi',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  widget.jobModel.position = "Yaşam Koçu";
                  widget.jobModel.userId = widget.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.pending, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Yaşam Koçu',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
