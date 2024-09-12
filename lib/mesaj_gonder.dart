import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessagePage extends StatefulWidget {
  final String receiverId;
  final String senderId;

  const SendMessagePage({
    Key? key,
    required this.receiverId,
    required this.senderId,
  }) : super(key: key);

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
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
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
        'message': message,
        'timestamp': timestamp,
      };

      try {
        // Gönderenin mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'ogretmen',
          docId: widget.senderId,
          targetDocId: widget.receiverId,
          messageData: messageData,
        );

        // Alıcının mesajlar koleksiyonuna ekle
        await _addMessage(
          collection: 'aile',
          docId: widget.receiverId,
          targetDocId: widget.senderId,
          messageData: messageData,
        );

        // Mesaj gönderildikten sonra temizle
        _messageController.clear();
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mesaj gönderildi!')),
        );
      } catch (error) {
        setState(() {
          _isSending = false;
        });
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mesaj gönderilemedi: $error'),
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
    // Eğer koleksiyon veya belge yoksa, Firestore'da oluşturulacaktır.
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
      appBar: AppBar(
        title: const Text('Mesaj Gönder'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Mesajınızı yazın...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSending ? null : _sendMessage,
              child: _isSending
                  ? const CircularProgressIndicator()
                  : const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
