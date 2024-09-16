import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/ogretmen_bilgi/ogretmen_ayrinti.dart';
import 'package:flutter/material.dart';

class BasvuranOgretmenlerPage extends StatefulWidget {
  final String aileId; // Aile id'si
  const BasvuranOgretmenlerPage({Key? key, required this.aileId})
      : super(key: key);

  @override
  _BasvuranOgretmenlerPageState createState() =>
      _BasvuranOgretmenlerPageState();
}

class _BasvuranOgretmenlerPageState extends State<BasvuranOgretmenlerPage> {
  List<String> basvuranOgretmenIds = [];

  @override
  void initState() {
    super.initState();
    _getBasvuranOgretmenler();
  }

  // Aile koleksiyonundan basvuran öğretmenlerin id'lerini al
  Future<void> _getBasvuranOgretmenler() async {
    try {
      DocumentSnapshot aileDoc = await FirebaseFirestore.instance
          .collection('aile')
          .doc(widget.aileId)
          .get();

      List<dynamic> basvuranlar = aileDoc.get('basvuranlar');

      setState(() {
        basvuranOgretmenIds = List<String>.from(basvuranlar);
      });
    } catch (e) {
      print('Başvuran öğretmenler alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Başvuran Öğretmenler"),
      ),
      body: basvuranOgretmenIds.isEmpty
          ? const Center(child: Text('Henüz başvuru yapılmadı.'))
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[100]!, Colors.blue[300]!],
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: basvuranOgretmenIds.length,
                itemBuilder: (context, index) {
                  String ogretmenId = basvuranOgretmenIds[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('ogretmen')
                        .doc(ogretmenId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData) {
                        return const Text("Veri bulunamadı.");
                      }

                      var ogretmenData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        ogretmenData["image_url"] != null
                                            ? NetworkImage(
                                                ogretmenData["image_url"]!)
                                            : null,
                                    backgroundColor:
                                        ogretmenData["image_url"] == null
                                            ? Colors.grey[300]
                                            : null,
                                    child: ogretmenData["image_url"] == null
                                        ? Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.grey[700],
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ogretmenData['name'] ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                              '${ogretmenData['selectedCity'] ?? ""} - ${ogretmenData['selectedDistrict'] ?? ""}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                ogretmenData['deneyim'] ??
                                    "Deneyim bilgisi yok.",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                                id: ogretmenId,
                                              )),
                                    );
                                  },
                                  child: const Text('Detaylara Bak'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
