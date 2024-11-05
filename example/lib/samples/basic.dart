import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import '../data.dart';
import 'package:flutter/material.dart';

class Basic extends StatefulWidget {
  @override
  State<Basic> createState() => BasicState();
}

class BasicState extends State<Basic> {
  List<ChatMessage> messages = basicSample;

  @override
  Widget build(BuildContext context) {
    final chat = DashChat(
      currentUser: 'user',
      handler: ChatHandler(
        onSend: (ChatMessage m) {
          log('mentions = ${m.mentions}');
          setState(() {
            messages.insert(0, m);
          });
        },
        getChatUser: (uid) async {
          final idx = users.indexWhere((e) => e.id == uid);
          if (idx == -1) {
            return ChatUser(id: uid);
          } else {
            return users[idx];
          }
        },
        streamOnMentionTrigger: (trigger, value) => Stream.value([
          ...users.where((e) =>
              (e.firstName ?? '').toLowerCase().contains(value.toLowerCase()))
        ]),
      ),
      builders: ChatBuilders(),
      inputOptions: InputOptions(
        sendOnEnter: true,
        inputDecoration: const InputDecoration(hintText: 'Scrivi un Messaggio'),
        sendButtonBuilder: (send) =>
            IconButton(onPressed: send, icon: const Icon(Icons.send_rounded)),
        trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.mic))],
        mentionTileBuilder: (item, onSelect) => ListTile(
          onTap: () => onSelect(
              (item as ChatUser).firstName ?? 'name', Mention(title: 'name')),
          title: Text((item as ChatUser).firstName ?? ''),
        ),
        showTrailingBeforeSend: true,
      ),
      // messages: messages,
      messages: [],
      messageOptions: MessageOptions(
        showTime: true,
      ),
      messageListOptions: MessageListOptions(
        onLoadEarlier: () async {
          await Future.delayed(const Duration(seconds: 3));
        },
        emptyListBuilder: (context) {
          return Center(
            child: Text('Nessun Messaggio uff'),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic example'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SizedBox()),
          Expanded(child: chat),
        ],
      ),
    );
  }
}
