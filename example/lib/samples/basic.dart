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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic example'),
      ),
      body: DashChat(
        currentUser: user,
        onSend: (ChatMessage m) {
          log('mentions = ${m.mentions}');
          setState(() {
            messages.insert(0, m);
          });
        },
        inputOptions: InputOptions(
          sendOnEnter: true,
          inputDecoration:
              const InputDecoration(hintText: 'Scrivi un Messaggio'),
          sendButtonBuilder: (send) =>
              IconButton(onPressed: send, icon: const Icon(Icons.send_rounded)),
          trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.mic))],
          onMention: (trigger, value, onMentionClick) async {
            log('onMention build');
            return <Widget>[
              for (int i = 0; i < 10; i++)
                ListTile(
                  title: Text('gino'),
                  onTap: () => onMentionClick.call(
                      'gino',
                      Mention(
                        title: '@gino',
                      )),
                ),
            ];
          },
          showTraillingBeforeSend: true,
        ),
        // messages: messages,
        messages: [],
        messageOptions: MessageOptions(showTime: true),
        messageListOptions: MessageListOptions(
          onLoadEarlier: () async {
            await Future.delayed(const Duration(seconds: 3));
          },
          emptyListBuilder: (context) {
            return Center(
              child: Text('Nessun Messaggio inviato'),
            );
          },
        ),
      ),
    );
  }
}
