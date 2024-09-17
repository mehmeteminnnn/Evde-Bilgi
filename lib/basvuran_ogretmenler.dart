import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/basvuran_ogretmen%20detay.dart';
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

  // Aile koleksiyonundan ilanId'leri ve başvuranları al ve ilanlar koleksiyonundan ilan detaylarını getir
  Future<void> fetchAndDisplayIlanDetails() async {
    final ilanDetails = await getIlanDetailsFromFamily(widget.familyId);

    setState(() {
      this.ilanDetails = ilanDetails;
      isLoading = false;
    });
  }

  // Aile koleksiyonundan ilan ve başvuran bilgilerini alır
  Future<List<Map<String, dynamic>>> getIlanDetailsFromFamily(
      String? familyId) async {
    if (familyId == null) return [];

    final familyDoc =
        FirebaseFirestore.instance.collection('aile').doc(familyId);
    final familySnapshot = await familyDoc.get();

    if (familySnapshot.exists) {
      final data = familySnapshot.data();
      final ilanlarim = List.from(data?['ilanlarım'] ?? []);

      // Her ilanId için ilan detaylarını ve başvuranları döndür
      return await Future.wait(ilanlarim.map((ilan) async {
        final ilanId = ilan['ilanId'];
        final ilanDetails = await getIlanDetails(ilanId);

        return {
          ...ilanDetails,
          'basvuranlar': ilan['basvuranlar'] ?? [],
        };
      }).toList());
    }
    return [];
  }

  // İlanlar koleksiyonundan ilan detaylarını alır
  Future<Map<String, dynamic>> getIlanDetails(String ilanId) async {
    final ilanCollection = FirebaseFirestore.instance.collection('ilanlar');
    final ilanDoc = await ilanCollection.doc(ilanId).get();

    if (ilanDoc.exists) {
      return ilanDoc.data()!;
    }
    return {};
  }

  // Başvuranları dialog olarak göstermek için bir fonksiyon
  /* void showApplicantsDialog(String ilanId, List<dynamic> applicants) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: applicants.isEmpty
              ? const Text('Bu ilana henüz başvuru yapılmamış.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: applicants.map((applicant) {
                    return ListTile(
                      title: Text('User ID: ${applicant['userId']}'),
                      subtitle: Text(
                          'Başvuru Tarihi: ${applicant['basvuru_tarihi'].toDate()}'),
                    );
                  }).toList(),
                ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

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
                              Text(
                                  'İletişim: ${ilan['phoneNumber'] ?? 'Telefon yok'}'),
                              const SizedBox(height: 8),
                              // Başvuranları görüntüle butonu
                              ElevatedButton(
                                //ilan['basvuranlar'] ?? []);  //ilan['ilanId'] ?? 'İlan ID yok',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApplicantsPage(
                                       
                                        applicants: ilan['basvuranlar'] ?? [],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Başvuranları Görüntüle'),
                              ),
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
