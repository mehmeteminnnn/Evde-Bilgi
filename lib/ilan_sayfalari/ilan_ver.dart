import 'package:evde_bilgi/ilan_sayfalari/ogretmen_bilgi.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/aile_talep_formu/aile_talep_formu.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/models/ilan_model.dart';

class IlanVer extends StatefulWidget {
  final JobModel jobModel;
  final String userId;

  IlanVer({required this.jobModel, required this.userId});

  @override
  State<IlanVer> createState() => _IlanVerState();
}

class _IlanVerState extends State<IlanVer> {
  bool? isApproved;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('aile')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          isApproved = userDoc['isApproved'] ?? false;
          widget.jobModel.fullName = userDoc['name'] ?? '';
          widget.jobModel.email = userDoc['email'] ?? '';
          widget.jobModel.phoneNumber = userDoc['phone'] ?? '';
          widget.jobModel.address = 'Belirtilmemiş';
        });
      }
    } catch (e) {
      print('Kullanıcı bilgileri alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Eğer isApproved false ise, uyarı göster
    if (isApproved == false || isApproved == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAlertDialog(context);
      });

      return Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: const EvdeBilgiAppBar(),
        body: const Center(
          child:
              CircularProgressIndicator(), // Ekran yüklendiğinde spinner göster
        ),
      );
    }

    // Eğer isApproved true ise, ilan ekranını göster
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
                      builder: (context) =>
                          CalismaAdresiScreen(jobModel: widget.jobModel),
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
            ],
          ),
        ),
      ),
    );
  }

  // Uyarı mesajı veren AlertDialog fonksiyonu
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 30),
              const SizedBox(width: 10),
              const Text(
                "Uyarı",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "İlan verebilmek için lütfen aile talep formunu doldurun.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // AlertDialog'u kapat
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AileTalepFormu(), // Talep formuna git
                  ),
                );
              },
              child: const Text(
                'Talep Formuna Git',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
