import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/appbarlar/ogretmen_drawer.dart';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:evde_bilgi/ozgecmis_ekranlari/ozgecmis.dart';
import 'package:flutter/material.dart';

class JobListingsPage extends StatefulWidget {
  final String? id;

  const JobListingsPage({Key? key, this.id}) : super(key: key);

  @override
  _JobListingsPageState createState() => _JobListingsPageState();
}

class _JobListingsPageState extends State<JobListingsPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSelectedCity();
    });
  }

  void _checkSelectedCity() {
    FirebaseFirestore.instance
        .collection('ogretmen')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;
        if (!userData.containsKey('selectedCity') ||
            userData['selectedCity'] == null) {
          _showResumeReminder(context);
        }
      }
    });
  }

  void _showResumeReminder(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Özgeçmiş Uyarısı'),
          content: Text(
            'Lütfen özgeçmişinizi doldurun. Özgeçmişlerini doldurmayan adaylar ailelerimize görünmeyecektir.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      drawer: OgretmenDrawer(
        uid: widget.id,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'İş İlanları',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Özgeçmişim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Başvurularım',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OzgecmisimEkrani(
                  teacherId: widget.id,
                ),
              ),
            );
          }
        },
      ),
      body: Stack(
        children: [
          filteredJobs.isEmpty
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ilanlar')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Bir hata oluştu.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.data!;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        var ilan = data.docs[index];
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
                                  title: Text(ilan['title']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(ilan['details'] ?? ""),
                                      SizedBox(height: 8),
                                      Text(
                                        '${ilan['salary']} TL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: Text('Şimdi Başvur'),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.orange,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                            jobId: ilan.id),
                                                  ),
                                                );
                                              },
                                              child: Text('Mesaj Gönder'),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                            jobId: ilan.id),
                                                  ),
                                                );
                                              },
                                              child: Text('Görüntüle'),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
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
                )
              : ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    var job = filteredJobs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: Text(job['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job['details'] ?? ""),
                              SizedBox(height: 8),
                              Text(
                                '${job['salary']} TL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text('Şimdi Başvur'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              jobId: job['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Mesaj Gönder'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              jobId: job['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Görüntüle'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
