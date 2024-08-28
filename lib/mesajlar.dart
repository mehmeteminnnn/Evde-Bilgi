import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  final List<String> messages;

  MessagesPage({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesajlar'),
        backgroundColor: Colors.teal,
      ),
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Yeni Bir Mesajınız Yok',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      messages[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Mesaj detayı buraya gelecek.'),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                    onTap: () {
                      // Mesaj detayına gitmek için bir navigasyon işlemi yapabilirsiniz.
                    },
                  ),
                );
              },
            ),
    );
  }
}

