import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApplicationsPage extends StatefulWidget {
  final String teacherId;

  const MyApplicationsPage({Key? key, required this.teacherId})
      : super(key: key);

  @override
  _MyApplicationsPageState createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  List<String> applicationIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      var teacherDoc = await FirebaseFirestore.instance
          .collection('ogretmen')
          .doc(widget.teacherId)
          .get();

      if (teacherDoc.exists) {
        List<dynamic> applications = teacherDoc.data()?['basvurularim'] ?? [];
        setState(() {
          applicationIds = List<String>.from(applications);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Başvurular alınırken hata: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Başvurularım'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicationIds.isEmpty
              ? const Center(child: Text('Henüz başvuru yapılmamış.'))
              : ListView.builder(
                  itemCount: applicationIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('ilanlar')
                          .doc(applicationIds[index])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const ListTile(
                            title: Text('İlan bulunamadı.'),
                          );
                        }
                        var ilan = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    ilan['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(ilan['details'] ?? "Detay yok"),
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
                                    ],
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
    );
  }
}
