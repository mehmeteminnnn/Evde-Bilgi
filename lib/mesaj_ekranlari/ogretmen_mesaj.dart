import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherMessagesScreen extends StatelessWidget {
  final String teacherId;

  TeacherMessagesScreen({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EvdeBilgiAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ogretmen')
            .doc(teacherId)
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Hiç mesaj yok.'));
          }

          var messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('aile')
                    .doc(message.id)
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Yükleniyor...'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Hata: ${userSnapshot.error}'),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text('Kullanıcı bulunamadı.'),
                    );
                  }

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  var userName = userData['name'] ?? 'Bilinmeyen Kullanıcı';

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          userName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        subtitle: Text(
                          "Mesajı görmek için dokunun",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 20.0,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherMessageDetailScreen(
                                teacherId: teacherId,
                                receiverId: message.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TeacherMessageDetailScreen extends StatefulWidget {
  final String teacherId;
  final String receiverId;

  TeacherMessageDetailScreen(
      {required this.teacherId, required this.receiverId});

  @override
  _TeacherMessageDetailScreenState createState() =>
      _TeacherMessageDetailScreenState();
}

class _TeacherMessageDetailScreenState
    extends State<TeacherMessageDetailScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isSending = true;
      });

      final timestamp = FieldValue.serverTimestamp();
      final messageData = {
        'senderId': widget.teacherId,
        'receiverId': widget.receiverId,
        'message': message,
        'timestamp': timestamp,
      };

      try {
        // Alıcının mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'aile',
          docId: widget.receiverId,
          targetDocId: widget.teacherId,
          messageData: messageData,
        );

        // Gönderenin mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'ogretmen',
          docId: widget.teacherId,
          targetDocId: widget.receiverId,
          messageData: messageData,
        );

        // Mesaj gönderildikten sonra temizle
        _messageController.clear();
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yanıt gönderildi!')),
        );
      } catch (error) {
        setState(() {
          _isSending = false;
        });
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yanıt gönderilemedi: $error'),
          ),
        );
      }
    }
  }

  Future<void> _addMessage({
    required String collection,
    required String docId,
    required String targetDocId,
    required Map<String, dynamic> messageData,
  }) async {
    final docRef = FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .collection('messages')
        .doc(targetDocId)
        .collection('messages')
        .doc(); // Yeni mesaj belgesi oluştur
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .collection('messages')
        .doc(targetDocId)
        .set({'createdAt': FieldValue.serverTimestamp()});

    await docRef.set(messageData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mesaj Detayları')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ogretmen')
                  .doc(widget.teacherId)
                  .collection('messages')
                  .doc(widget.receiverId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Veri bekleniyor
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Veri hatası durumu
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }

                // Veri yoksa veya boşsa
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Hiç mesaj yok.'));
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSentByCurrentUser =
                        message['senderId'] == widget.teacherId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                        alignment: isSentByCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isSentByCurrentUser
                                ? Colors.blueAccent
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(
                                  color: isSentByCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                message['timestamp'] != null
                                    ? _formatTimestamp(message['timestamp'])
                                    : 'Tarih yok',
                                style: TextStyle(
                                  color: isSentByCurrentUser
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Yanıtınızı yazın...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSending ? null : _sendMessage,
                  child:
                      _isSending ? const CircularProgressIndicator() : const Text('Gönder'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 1) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }
}
