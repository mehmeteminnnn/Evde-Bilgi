import 'package:evde_bilgi/mesaj_gonder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;
  final String? receiverId;
  final String? senderId;
  final bool isAile;
  final bool isConfirmed;

  JobDetailPage(
      {super.key,
      required this.jobId,
      this.receiverId,
      this.senderId,
      this.isAile = false,
      this.isConfirmed = false});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
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
          // ignore: use_build_context_synchronously
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Detayı'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('ilanlar')
            .doc(widget.jobId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('İlan bulunamadı'));
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Text(
                        jobData['title'],
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        jobData['city'] ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ..._buildTags(jobData['jobTypes'] ?? []),
                            Card(child: _buildTag('${jobData['salary']} TL')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInfoBox(jobData),
                SizedBox(
                  width: double.infinity,
                  child: _buildBox('İş Tanımı', jobData['details'] ?? ""),
                ),
                SizedBox(
                  width: double.infinity,
                  child: _buildBox('Maaş', '${jobData['salary']} TL'),
                ),
                SizedBox(
                  width: double.infinity,
                  child: _buildBox(
                    'Çalışma Günü',
                    jobData['workingDays'] != null &&
                            jobData['workingDays'].isNotEmpty
                        ? (jobData['workingDays'] as List<dynamic>).join(', ')
                        : 'Belirtilmemiş',
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: _buildBox(
                      'Çalışma Saati(Günlük)', jobData['hoursPerDay'] ?? ''),
                ),
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTags(List<dynamic> jobTypes) {
    return jobTypes
        .map((type) => Card(child: _buildTag(type.toString())))
        .toList();
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildInfoBox(Map<String, dynamic> jobData) {
    String publishDateText;

    if (jobData['publishDate'] != null) {
      try {
        publishDateText =
            DateFormat('dd/MM/yyyy').format(jobData['publishDate'].toDate());
      } catch (e) {
        publishDateText = 'Belirtilmemiş';
      }
    } else {
      publishDateText = 'Belirtilmemiş';
    }
    bool hideContactInfo = widget.isConfirmed;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            columnWidths: {
              0: const FlexColumnWidth(2),
              1: const FlexColumnWidth(3),
            },
            children: [
              _buildTableRow('Yayınlanma Tarihi', publishDateText),
              _buildTableRow(
                  'Ad-Soyad', jobData['fullName'] ?? 'Belirtilmemiş'),
              _buildTableRow(
                  'Pozisyon', jobData['position'] ?? 'Belirtilmemiş'),
              _buildTableRow('Telefon Numarası',
                  jobData['phoneNumber']?.toString() ?? 'Belirtilmemiş',
                  hideInfo: hideContactInfo),
              _buildTableRow(
                  'E-posta Adresi', jobData['email'] ?? 'Belirtilmemiş',
                  hideInfo: hideContactInfo),
              _buildAddressRow(
                jobData['neighborhood'] ?? 'Belirtilmemiş',
                jobData['city'] ?? 'Belirtilmemiş',
                jobData['district'] ?? 'Belirtilmemiş',
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value,
      {bool hideInfo = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: hideInfo
              ? const Text('Bilgileri görmek için özgeçmişinizi doldurun')
              : Text(value?.toString() ?? 'Belirtilmemiş'),
        ),
      ],
    );
  }

  TableRow _buildAddressRow(String neighborhood, String city, String district) {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Adres',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                neighborhood,
                style: const TextStyle(overflow: TextOverflow.visible),
                softWrap: true,
              ),
              Text(
                city,
                style: const TextStyle(overflow: TextOverflow.visible),
                softWrap: true,
              ),
              Text(
                district,
                style: const TextStyle(overflow: TextOverflow.visible),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBox(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (widget.isAile) {
      return SizedBox.shrink(); // Eğer isAile true ise, boş bir widget döndür
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Basvur(widget.jobId, widget.senderId!, widget.receiverId!);
              // Şimdi Başvur butonuna tıklama işlevi
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Şimdi Başvur'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendMessagePage(
                    senderId: widget.senderId!,
                    receiverId: widget.receiverId!,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Mesaj Gönder'),
          ),
        ],
      ),
    );
  }
}
