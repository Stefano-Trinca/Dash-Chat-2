import 'package:flutter/material.dart';

import '../../dash_chat_2.dart';

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
    this.inputOptions = const InputOptions(),
  }) {
    notifierMessages.value = initialMessages;
    notifierTypingUsers.value = initilTypingUsers;
    scrollController.addListener(_listenerScrollController);
    inputFocusNode.addListener(_listenerInputFocusNode);
    inputController.addListener(_listenerInputController);
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

  final TextEditingController inputController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ValueNotifier<bool> notifierShowInputOverlay = ValueNotifier(false);
  final ValueNotifier<bool> notifierInputIsWriting = ValueNotifier(false);
  final ValueNotifier<(String, String)> notifierMentionTriggerValue =
      ValueNotifier(('', ''));
  final ValueNotifier<List<Mention>> notifierMentions =
      ValueNotifier(<Mention>[]);
  List<Mention> get mentions => notifierMentions.value;

  final MessageListOptions messageListOptions;
  final MessageOptions messageOptions;
  final QuickReplyOptions quickReplyOptions;
  final InputOptions inputOptions;

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

  //
  //
  //
  //
  //
  //
  //
  // MESSAGES
  //

  void updateMessages(List<ChatMessage> source) {
    notifierMessages.value = source;
  }

  void updateTypingUsers(List<String> source) {
    notifierTypingUsers.value = source;
  }

  void sendMessage() {
    if (inputController.text.isNotEmpty) {
      inputFocusNode.unfocus();

      final String text = inputController.text;
      Map<String, Mention> cleanMentions = <String, Mention>{};
      for (var m in mentions) {
        cleanMentions[m.title] = m;
      }

      final ChatMessage message = ChatMessage(
        text: text,
        user: currentUser,
        createdAt: DateTime.now(),
        mentions: cleanMentions.values.toList(),
      );
      handler.onSend?.call(message);
      inputController.clear();
      if (inputOptions.onTextChange != null) {
        inputOptions.onTextChange!('');
      }

      //todo: find a better solution
      Future.delayed(const Duration(milliseconds: 50), () {
        inputFocusNode.requestFocus();
      });
      // inputFocusNode.requestFocus();
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

//
//
//
//
//
//
//
// MENTIONS
//
  bool get showInputOverlay => notifierShowInputOverlay.value;

  void _listenerInputFocusNode() {
    if (inputFocusNode.hasFocus && showInputOverlay) {
      Future.delayed(Durations.short2).then((_) {
        notifierShowInputOverlay.value = false;
      });
    }
  }

  void _listenerInputController() {
    _checkMentions(inputController.text);
    notifierInputIsWriting.value = inputController.text.isNotEmpty;
  }

  int currentMentionIndex = -1;
  String currentTrigger = '';
  Future<void> _checkMentions(String text) async {
    bool hasMatch = false;
    for (final String trigger in inputOptions.onMentionTriggers) {
      final RegExp regexp = RegExp(r'(?<![^\s<>])' + trigger + r'([^\s<>]+)$');
      if (regexp.hasMatch(text)) {
        hasMatch = true;
        currentMentionIndex = inputController.text.indexOf(regexp);
        currentTrigger = trigger;
        final String value = regexp.firstMatch(text)!.group(1)!;
        notifierMentionTriggerValue.value = (currentTrigger, value);
        notifierShowInputOverlay.value = true;
      }
    }
    if (!hasMatch && showInputOverlay) {
      clearOverlay();
    }
  }

  void onMentionClick(String value, Mention mention) {
    inputController.text = inputController.text.replaceRange(
      currentMentionIndex,
      inputController.text.length,
      currentTrigger + value,
    );
    inputController.selection = TextSelection.collapsed(
      offset: inputController.text.length,
    );
    List<Mention> _mentions = mentions.toList();
    _mentions.add(mention);
    notifierMentions.value = _mentions;
    clearOverlay();
  }

  void clearOverlay() {
    if (showInputOverlay) {
      notifierShowInputOverlay.value = false;
      notifierMentionTriggerValue.value = ('', '');
    }
  }

  void dispose() {
    notifierShowInputOverlay.value = false;
    notifierMentionTriggerValue.value = ('', '');
    scrollController.removeListener(_listenerScrollController);
    inputFocusNode.removeListener(_listenerInputFocusNode);
    inputController.removeListener(_listenerInputController);
  }
}
