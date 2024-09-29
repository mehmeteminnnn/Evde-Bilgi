import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:evde_bilgi/appbarlar/ogretmen_drawer.dart';
import 'package:evde_bilgi/basvurularim.dart';
import 'package:evde_bilgi/is_ilan/ilan_detay.dart';
import 'package:evde_bilgi/mesaj_ekranlari/ogretmen_mesaj.dart';
import 'package:evde_bilgi/mesaj_gonder.dart';
import 'package:evde_bilgi/odeme_ekrani.dart';
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
  bool isConfirmed = false;

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
          setState(() {
            isConfirmed = true; // Sınıf düzeyindeki değişkeni güncelliyoruz
          });
          _showResumeReminder(context);
        }
      }
    });
  }

  void Basvur(String ilanId, String teacherId, String familyId) async {
    // Kullanıcıdan başvuruyu onaylamasını isteyen bir diyalog gösterelim
    bool isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Başvuruyu Onaylıyor Musunuz?'),
          content: const Text('Bu ilana başvurmak istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // İptal
              },
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Onayla
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );

    // Eğer başvuru onaylandıysa
    if (isConfirmed) {
      try {
        // Aile koleksiyonundan ilgili belgeyi çekelim
        DocumentReference ilanRef =
            FirebaseFirestore.instance.collection('aile').doc(familyId);
        DocumentSnapshot ilanDoc = await ilanRef.get();

        if (ilanDoc.exists) {
          Map<String, dynamic>? data = ilanDoc.data() as Map<String, dynamic>?;
          List<dynamic> ilanlarim = data?['ilanlarım'] ?? [];

          // İlgili ilanı bulalım
          Map<String, dynamic>? ilan = ilanlarim.firstWhere(
              (ilan) => ilan['ilanId'] == ilanId,
              orElse: () => null);

          List<dynamic> basvuranlar =
              ilan != null ? ilan['basvuranlar'] ?? [] : [];

          // Kullanıcının daha önce başvurup başvurmadığını kontrol edelim
          bool hasApplied = basvuranlar
              .any((application) => application['userId'] == teacherId);

          if (hasApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bu ilana zaten başvurmuşsunuz.'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          Timestamp basvuruTarihi = Timestamp.now();

          // Öğretmenin "basvurularim" listesine ilanı ekliyoruz
          DocumentReference teacherRef =
              FirebaseFirestore.instance.collection('ogretmen').doc(teacherId);
          await teacherRef.update({
            'basvurularim': FieldValue.arrayUnion([ilanId])
          });

          // Başvuranlar listesine yeni öğretmen ekleniyor
          basvuranlar.add({
            'userId': teacherId,
            'basvuru_tarihi': basvuruTarihi,
          });

          // İlanı güncelleme: önce eski ilanı kaldırıyoruz
          if (ilan != null) {
            await ilanRef.update({
              'ilanlarım': FieldValue.arrayRemove([ilan]),
            });
          }

          // Yeni ilan yapısını oluşturuyoruz ve tekrar ekliyoruz
          ilan = {
            'ilanId': ilanId,
            'basvuranlar': basvuranlar,
          };

          await ilanRef.update({
            'ilanlarım': FieldValue.arrayUnion([ilan]),
          });

          // Başvuru başarıyla eklendiği mesajını gösterelim
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Başvuru başarıyla eklendi!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İlan bulunamadı.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Eğer bir hata olursa, kullanıcıya hata mesajı gösterelim
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başvuru sırasında bir hata oluştu.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showResumeReminder(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Özgeçmiş Uyarısı'),
          content: const Text(
            'Lütfen özgeçmişinizi doldurun. Özgeçmişlerini doldurmayan adaylar ailelerimize görünmeyecektir.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _onPaymentSuccess() {
    // Ödeme başarılı olduğunda bu fonksiyon çağrılacak
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OzgecmisimEkrani(teacherId: widget.id),
      ),
    );
  }

  void _checkResumeAndNavigate(BuildContext context) {
    FirebaseFirestore.instance
        .collection('ogretmen')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        // Özgeçmiş alanını kontrol et
        if (!userData.containsKey('resume') ||
            userData['resume'] == null ||
            userData['resume'].isEmpty) {
          // Özgeçmiş boşsa kullanıcıyı ödeme ekranına yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OdemeEkrani(
                totalAmount: 50,
                onPaymentSuccess:
                    _onPaymentSuccess, // Ödeme başarılı olunca çağrılacak
              ),
            ),
          );
        } else {
          // Özgeçmiş varsa direkt özgeçmiş ekranına yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OzgecmisimEkrani(teacherId: widget.id),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EvdeBilgiAppBar(),
      drawer: OgretmenDrawer(
        uid: widget.id,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
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
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApplicationsPage(
                  teacherId: widget.id!,
                ),
              ),
            ).then((_) {
              // Sayfa geri dönüldüğünde indexi sıfırla
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
          if (index == 2) {
            // Özgeçmiş bilgilerini kontrol ediyoruz
            _checkResumeAndNavigate(context);
            setState(() {
              _selectedIndex = 0;
            });
          }

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherMessagesScreen(
                  teacherId: widget.id!,
                ),
              ),
            ).then((_) {
              // Sayfa geri dönüldüğünde indexi sıfırla
              setState(() {
                _selectedIndex = 0;
              });
            });
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
                      return const Center(child: Text('Bir hata oluştu.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                                      const SizedBox(height: 8),
                                      Text(
                                        '${ilan['salary']} TL',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Basvur(ilan.id, widget.id!,
                                                    ilan['userId']);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.orange,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Şimdi Başvur'),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMessagePage(
                                                      senderId: widget.id!,
                                                      receiverId:
                                                          ilan['userId'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    Colors.blueGrey,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Mesaj Gönder'),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobDetailPage(
                                                      senderId: widget.id!,
                                                      receiverId:
                                                          ilan['userId'],
                                                      jobId: ilan.id,
                                                      isConfirmed: isConfirmed,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.green,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Görüntüle'),
                                            ),
                                          ),
                                        ],
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
                              const SizedBox(height: 8),
                              Text(
                                '${job['salary']} TL',
                                style: const TextStyle(
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Şimdi Başvur'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SendMessagePage(
                                                      senderId: widget.id!,
                                                      receiverId: job['userId'],
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Mesaj Gönder'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobDetailPage(
                                              senderId: widget.id!,
                                              receiverId: job['userId'],
                                              jobId: job['id'],
                                              isConfirmed: isConfirmed,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Görüntüle'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          /* Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Filtreleme sayfasına yönlendirme yapıyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(),
                  ),
                );
              },
              child: const Icon(Icons.filter_list),
              backgroundColor: Colors.blue,
            ),
          ),*/
        ],
      ),
    );
  }
}
