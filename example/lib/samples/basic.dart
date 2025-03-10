import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class Basic extends StatefulWidget {
  @override
  State<Basic> createState() => BasicState();
}

class BasicState extends State<Basic> {
  List<ChatMessage> messages = basicSample;

  InputStatus inputStatus = InputStatus.none;

  void onSend(ChatMessage m) async {
    // log('mentions = ${m.mentions}');
    setState(() {
      messages.insert(0, m);
      inputStatus = InputStatus.loading;
    });

    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      inputStatus = InputStatus.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = DashChat(
      currentUser: 'user',
      inputEnabled: true,
      inputStatus: inputStatus,
      handler: ChatHandler(
        onSend: onSend,
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
      typingUsers: {'assistant': 'sto scrivendo...'},
      inputOptions: InputOptions(
        sendOnEnter: true,
        inputDecoration: const InputDecoration(hintText: 'Scrivi un Messaggio'),
        sendButtonBuilder: (status, send) => IconButton(
          onPressed: send,
          icon:
              Icon(status.isLoading ? Icons.stop_rounded : Icons.send_rounded),
        ),
        trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.mic))],
        mentionTileBuilder: (item, onSelect) => ListTile(
          onTap: () => onSelect(
              (item as ChatUser).firstName ?? 'name', Mention(title: 'name')),
          title: Text((item as ChatUser).firstName ?? ''),
        ),
        showTrailingBeforeSend: true,
        alwaysShowSend: true,
      ),
      messages: messages,
      // messages: [],
      messageOptions: MessageOptions(
        showTime: true,
        typingTextColor: Theme.of(context).colorScheme.primary,
        typingTextColorShimmer:
            Theme.of(context).colorScheme.onSecondary.withAlpha(160),
        messagePadding: EdgeInsets.all(12),
        messageStreamBuilder: (message) => generateWordStream(),
        messageActionsBuilder: (message, isOwnMessage) {
          if (isOwnMessage) return SizedBox();
          return Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.thumb_up_off_alt,
                  ))
            ],
          );
        },
      ),
      messageListOptions: MessageListOptions(
        scrollToBottomIconButtonBackgroundColor: Colors.blue,
        scrollToBottomIconButtonForegroundColor: Colors.cyanAccent,
        messageListPadding: const EdgeInsets.only(top: 200),
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
          Expanded(child: Column(children: [])),
          Expanded(child: chat),
        ],
      ),
    );
  }
}

Stream<String> generateWordStream() {
  return SentenceStreamer(
    sentence:
        'Ciao come stai? Ti va di raccontarmi qualcosa solo per vedere se questa cosa funziona?',
    interval: const Duration(milliseconds: 200),
  ).stream;
}

class SentenceStreamer {
  final String sentence;
  final Duration interval;
  late Stream<String> _stream;

  SentenceStreamer({
    required this.sentence,
    this.interval = const Duration(milliseconds: 100),
  }) {
    _stream = _createStream();
  }

  Stream<String> get stream => _stream;

  Stream<String> _createStream() async* {
    List<String> words = sentence.split(' ');
    int index = 0;
    String currentSentence = "";

    while (true) {
      currentSentence += (index == 0 ? "" : " ") + words[index];
      yield currentSentence;

      index = (index + 1) % words.length;

      if (index == 0) {
        await Future.delayed(interval);
        currentSentence = "";
      }

      await Future.delayed(interval);
    }
  }
}
