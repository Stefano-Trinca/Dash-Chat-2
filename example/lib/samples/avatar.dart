import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class AvatarSample extends StatefulWidget {
  @override
  State<AvatarSample> createState() => AvatarSampleState();
}

class AvatarSampleState extends State<AvatarSample> {
  List<ChatMessage> messages = allUsersSample;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users example'),
      ),
      body: DashChat(
        currentUser: 'user',
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
