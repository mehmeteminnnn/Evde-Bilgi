import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IlanListPage extends StatefulWidget {
  final String? familyId; // Aile ID alacağız
  const IlanListPage({super.key, this.familyId});

  @override
  State<IlanListPage> createState() => _IlanListPageState();
}

class _IlanListPageState extends State<IlanListPage> {
  List<Map<String, dynamic>> ilanDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayIlanDetails();
  }

  // Aile koleksiyonundan ilanId'leri al ve ilanlar koleksiyonundan ilan detaylarını getir
  Future<void> fetchAndDisplayIlanDetails() async {
    final ilanIds = await getIlanIdsFromFamily(widget.familyId);
    final ilanDetails = await getIlanDetails(ilanIds);

    setState(() {
      this.ilanDetails = ilanDetails;
      isLoading = false;
    });
  }

  // Aile koleksiyonundan ilanId'leri alır
  Future<List<String>> getIlanIdsFromFamily(String? familyId) async {
    if (familyId == null) return [];

    final familyDoc = FirebaseFirestore.instance.collection('aile').doc(familyId);
    final familySnapshot = await familyDoc.get();

    if (familySnapshot.exists) {
      final data = familySnapshot.data();
      final ilanlarim = List.from(data?['ilanlarım'] ?? []);
      return ilanlarim.map<String>((ilan) => ilan['ilanId']).toList();
    }
    return [];
  }

  // İlanlar koleksiyonundan ilan detaylarını alır
  Future<List<Map<String, dynamic>>> getIlanDetails(List<String> ilanIds) async {
    final ilanCollection = FirebaseFirestore.instance.collection('ilanlar');
    final ilanDetails = <Map<String, dynamic>>[];

    for (String ilanId in ilanIds) {
      final ilanDoc = await ilanCollection.doc(ilanId).get();
      if (ilanDoc.exists) {
        ilanDetails.add(ilanDoc.data()!);
      }
    }
    return ilanDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlanlarım'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ilanDetails.isEmpty
              ? const Center(child: Text('Hiç ilan bulunamadı.'))
              : ListView.builder(
                  itemCount: ilanDetails.length,
                  itemBuilder: (context, index) {
                    final ilan = ilanDetails[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: Text(ilan['title'] ?? 'Başlık Yok'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ilan['details'] ?? 'Detay yok'),
                              const SizedBox(height: 8),
                              Text(
                                '${ilan['salary']} TL',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Konum: ${ilan['city'] ?? 'Bilinmiyor'}'),
                              Text('İletişim: ${ilan['phoneNumber'] ?? 'Telefon yok'}'),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
