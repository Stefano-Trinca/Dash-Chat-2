import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class MentionSample extends StatefulWidget {
  @override
  State<MentionSample> createState() => MentionSampleState();
}

class MentionSampleState extends State<MentionSample> {
  List<ChatMessage> messages = mentionSample;
  List<Mention> mentions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mention example'),
      ),
      body: DashChat(
        currentUser: '0',
        handler: ChatHandler(onSend: (ChatMessage m) {
          setState(() {
            messages.insert(0, m);
          });
        }),
        messages: messages,
        messageListOptions: MessageListOptions(
          onLoadEarlier: () async {
            await Future.delayed(const Duration(seconds: 3));
          },
        ),
        messageOptions: MessageOptions(
          onPressMention: (mention) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(mention.title),
                  content: Text(mention.customProperties.toString()),
                );
              },
            );
          },
        ),
        inputOptions: InputOptions(
          // onMention: (String trigger, String value,
          //     void Function(String, Mention) onMentionClick) {
          //   // Here you would typically do a request to your backend
          //   // to get the correct results to show
          //   // according to the trigger and value
          //   return Future.delayed(
          //     const Duration(milliseconds: 500),
          //     () {
          //       return <Widget>[
          //         ListTile(
          //           leading: DefaultAvatar(user: '8'),
          //           title: Text(user8.getFullName()),
          //           onTap: () {
          //             final mention = Mention(
          //               title: trigger + user8.getFullName(),
          //               customProperties: <String, dynamic>{
          //                 'userId': user8.id,
          //               },
          //             );
          //             onMentionClick(user8.getFullName(), mention);
          //           },
          //         ),
          //         const Divider(),
          //         ListTile(
          //           leading: DefaultAvatar(user: '5'),
          //           title: Text(user5.getFullName()),
          //           onTap: () {
          //             final mention = Mention(
          //               title: trigger + user8.getFullName(),
          //               customProperties: <String, dynamic>{
          //                 'userId': user5.id,
          //               },
          //             );
          //             onMentionClick(user5.getFullName(), mention);
          //           },
          //         )
          //       ];
          //     },
          //   );
          // },
          onMentionTriggers: ['@', '#'],
        ),
      ),
    );
  }
}
