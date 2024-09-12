import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evde_bilgi/appbarlar/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FamilyMessagesScreen extends StatelessWidget {
  final String familyId;

  FamilyMessagesScreen({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EvdeBilgiAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('aile')
            .doc(familyId)
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Hiç mesaj yok.'));
          }

          var messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ogretmen')
                    .doc(message.id)
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Yükleniyor...'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Hata: ${userSnapshot.error}'),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
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
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          userName.toUpperCase(),
                          style: TextStyle(
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
                              builder: (context) => MessageDetailScreen(
                                familyId: familyId,
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

class MessageDetailScreen extends StatefulWidget {
  final String familyId;
  final String receiverId;

  MessageDetailScreen({required this.familyId, required this.receiverId});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
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
        'senderId': widget.familyId,
        'receiverId': widget.receiverId,
        'message': message,
        'timestamp': timestamp,
      };

      try {
        // Alıcının mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'ogretmen',
          docId: widget.receiverId,
          targetDocId: widget.familyId,
          messageData: messageData,
        );

        // Gönderenin mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'aile',
          docId: widget.familyId,
          targetDocId: widget.receiverId,
          messageData: messageData,
        );

        // Mesaj gönderildikten sonra temizle
        _messageController.clear();
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yanıt gönderildi!')),
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

    await docRef.set(messageData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mesaj Detayları')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('aile')
                  .doc(widget.familyId)
                  .collection('messages')
                  .doc(widget.receiverId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Veri bekleniyor
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Veri hatası durumu
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }

                // Veri yoksa veya boşsa
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Hiç mesaj yok.'));
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSentByCurrentUser =
                        message['senderId'] == widget.receiverId;
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
                    decoration: InputDecoration(
                      hintText: 'Yanıtınızı yazın...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSending ? null : _sendMessage,
                  child:
                      _isSending ? CircularProgressIndicator() : Text('Gönder'),
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