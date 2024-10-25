import 'package:flutter/material.dart';

import '../../dash_chat_2.dart';
import 'chat_handler.dart';

class ChatController {
  ChatController({
    required this.currentUser,
    List<ChatMessage> initialMessages = const <ChatMessage>[],
    List<String> initilTypingUsers = const <String>[],
    this.readOnly = false,
    this.showScrollToBottomOption = true,
    this.handler = const ChatHandler(),
    this.messageListOptions = const MessageListOptions(),
    this.messageOptions = const MessageOptions(),
    this.quickReplyOptions = const QuickReplyOptions(),
  }) {
    notifierMessages.value = initialMessages;
    notifierTypingUsers.value = initilTypingUsers;
    scrollController.addListener(_listenerScrollController);
  }

  final ScrollController scrollController = ScrollController();
  final bool readOnly;
  final String currentUser;
  final ChatHandler handler;

  final bool showScrollToBottomOption;
  final ValueNotifier<bool> notifierShowScrollToBottom = ValueNotifier(false);
  final ValueNotifier<List<String>> notifierTypingUsers =
      ValueNotifier(<String>[]);
  List<String> get typingUsers => notifierTypingUsers.value;
  final ValueNotifier<List<ChatMessage>> notifierMessages =
      ValueNotifier(<ChatMessage>[]);
  List<ChatMessage> get messages => notifierMessages.value;

  final MessageListOptions messageListOptions;
  final MessageOptions messageOptions;
  final QuickReplyOptions quickReplyOptions;

  void _listenerScrollController() {
    if (showScrollToBottomOption) {
      if (scrollController.offset > 200 && !notifierShowScrollToBottom.value) {
        notifierShowScrollToBottom.value = true;
      } else if (scrollController.offset <= 200 &&
          notifierShowScrollToBottom.value) {
        notifierShowScrollToBottom.value = false;
      }
    }
  }

  void updateMessages(List<ChatMessage> source) {
    notifierMessages.value = source;
  }

  void sendMessage(ChatMessage message) {
    handler.onSend?.call(message);
  }

  void scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    scrollController.removeListener(_listenerScrollController);
  }
}
