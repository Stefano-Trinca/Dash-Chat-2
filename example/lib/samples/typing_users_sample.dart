import 'package:dash_chat_2/dash_chat_2.dart';
import '../data.dart';
import 'package:flutter/material.dart';

class TypingUsersSample extends StatefulWidget {
  @override
  State<TypingUsersSample> createState() => TypingUsersSampleState();
}

class TypingUsersSampleState extends State<TypingUsersSample> {
  List<ChatMessage> messages = basicSample;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Typing user example'),
      ),
      body: DashChat(
        currentUser: '0',
        handler: ChatHandler(onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        }),
        typingUsers: {"3": "Sta scrivendo..."},
        messages: messages,
      ),
    );
  }
}
