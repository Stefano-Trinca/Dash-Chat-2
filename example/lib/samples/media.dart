import 'package:dash_chat_2/dash_chat_2.dart';
import '../data.dart';
import 'package:flutter/material.dart';

class Media extends StatefulWidget {
  @override
  State<Media> createState() => MediaState();
}

class MediaState extends State<Media> {
  List<ChatMessage> messages = media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media example'),
      ),
      body: DashChat(
        currentUser: '0',
        handler: ChatHandler(onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        }),
        messages: messages,
      ),
    );
  }
}
