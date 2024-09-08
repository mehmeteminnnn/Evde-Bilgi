import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessagePage extends StatefulWidget {
  final String jobId;
  final String senderId;

  const SendMessagePage({
    Key? key,
    required this.jobId,
    required this.senderId,
  }) : super(key: key);

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'jobId': widget.jobId,
        'senderId': widget.senderId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mesaj gönderme hatası: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
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
              decoration: const InputDecoration(
                labelText: 'Mesajınızı yazın...',
              ),
              maxLines: 4,
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
