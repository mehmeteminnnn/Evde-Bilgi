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
        title: const Text('Evde Bilgi'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ..._buildTags(jobData['jobTypes'] ?? []),
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
                  child: _buildBox(
                    'Çalışma Günü',
                    jobData['workingDays'] != null &&
                            jobData['workingDays'].isNotEmpty
                        ? (jobData['workingDays'] as List<dynamic>).join(', ')
                        : 'Belirtilmemiş',
                  ),
                  width: double.infinity,
                ),
                SizedBox(
                  child: _buildBox(
                      'Çalışma Saati(Günlük)', jobData['hoursPerDay'] ?? ''),
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
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
            },
            children: [
              _buildTableRow('Yayınlanma Tarihi', publishDateText),
              _buildTableRow(
                  'Ad-Soyad', jobData['fullName'] ?? 'Belirtilmemiş'),
              _buildTableRow(
                  'Pozisyon', jobData['position'] ?? 'Belirtilmemiş'),
              _buildTableRow('Telefon Numarası',
                  jobData['phoneNumber']?.toString() ?? 'Belirtilmemiş'),
              _buildTableRow(
                  'E-posta Adresi', jobData['email'] ?? 'Belirtilmemiş'),
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

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(value?.toString() ?? 'Belirtilmemiş'),
        ),
      ],
    );
  }

  TableRow _buildAddressRow(String neighborhood, String city, String district) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Adres',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                neighborhood,
                style: TextStyle(overflow: TextOverflow.visible),
                softWrap: true,
              ),
              Text(
                city,
                style: TextStyle(overflow: TextOverflow.visible),
                softWrap: true,
              ),
              Text(
                district,
                style: TextStyle(overflow: TextOverflow.visible),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Şimdi Başvur butonuna tıklama işlevi
            },
            child: const Text('Şimdi Başvur'),
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              // Mesaj Gönder butonuna tıklama işlevi
            },
            child: const Text('Mesaj Gönder'),
            style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }
}
