import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/ilan_sayfalari/ogretmen_bilgi.dart';
import 'package:evde_bilgi/models/ilan_model.dart';
import 'package:flutter/material.dart';

class IlanVer extends StatefulWidget {
   final JobModel jobModel;
   IlanVer({required this.jobModel});
  @override
  State<IlanVer> createState() => _IlanVerState();
}

class _IlanVerState extends State<IlanVer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: EvdeBilgiAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kime ihtiyacınız var?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {widget.jobModel.position = "Gölge Öğretmen";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalismaAdresiScreen(jobModel: widget.jobModel,),
                    ),
                  );
                },
                child: Row(
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {widget.jobModel.position = "Özel Eğitim";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: Row(
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {widget.jobModel.position = "Oyun Ablası / Abisi";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: Row(
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
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {widget.jobModel.position = "Yaşam Koçu";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalismaAdresiScreen(jobModel: widget.jobModel),
                    ),
                  );
                },
                child: Row(
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
