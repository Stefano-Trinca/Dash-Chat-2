import 'package:dash_chat_2/dash_chat_2.dart';
import '../data.dart';
import 'package:flutter/material.dart';

class QuickRepliesSample extends StatefulWidget {
  @override
  State<QuickRepliesSample> createState() => QuickRepliesSampleState();
}

class QuickRepliesSampleState extends State<QuickRepliesSample> {
  List<ChatMessage> messages = quickReplies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickReplies example'),
      ),
      body: DashChat(
        currentUser: '0',
        handler: ChatHandler(onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        }),
        quickReplyOptions: QuickReplyOptions(onTapQuickReply: (QuickReply r) {
          final ChatMessage m = ChatMessage(
            user: '0',
            text: r.value ?? r.title,
            createdAt: DateTime.now(),
          );
          setState(() {
            messages.insert(0, m);
          });
        }),
        messages: messages,
      ),
    );
  }
}
