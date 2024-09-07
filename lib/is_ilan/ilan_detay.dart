import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;

  JobDetailPage({required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evde Bilgi'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('ilanlar')
            .doc(widget.jobId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('İlan bulunamadı'));
          }

          var jobData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Text(
                        jobData['title'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        jobData['city'] ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(child: _buildTag(jobData['jobType'] ?? "")),
                          Card(child: _buildTag(jobData['isopen'] ?? "")),
                          Card(child: _buildTag('${jobData['salary']} TL')),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildInfoBox(jobData),
                SizedBox(
                  child: _buildBox('İş Tanımı', jobData['details'] ?? ""),
                  width: double.infinity,
                ),
                SizedBox(
                  child: _buildBox('Maaş', '${jobData['salary']} TL'),
                  width: double.infinity,
                ),
                SizedBox(
                  child:
                      _buildBox('Çalışma Günü', jobData['workingDays'] ?? ''),
                  width: double.infinity,
                ),
                SizedBox(
                  child: _buildBox(
                      'Çalışma Saati(Günlük)', jobData['workingHours'] ?? ''),
                  width: double.infinity,
                ),
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
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
            children: [
              _buildTableRow('Yayınlanma Tarihi', publishDateText),
              _buildTableRow(
                  'Ad-Soyad', jobData['namesurname'] ?? 'Belirtilmemiş'),
              _buildTableRow(
                  'Pozisyon', jobData['position'] ?? 'Belirtilmemiş'),
              _buildTableRow('Telefon Numarası',
                  jobData['phoneNumber']?.toString() ?? 'Belirtilmemiş'),
              _buildTableRow(
                  'E-posta Adresi', jobData['email'] ?? 'Belirtilmemiş'),
              _buildTableRow('Adres', jobData['address'] ?? 'Belirtilmemiş'),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(value?.toString() ?? 'Belirtilmemiş'),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Şimdi Başvur'),
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
