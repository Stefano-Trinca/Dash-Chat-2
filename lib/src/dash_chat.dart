part of '../dash_chat_2.dart';

/// {@category Entry point}
class DashChat extends StatefulWidget {
  const DashChat({
    required this.currentUser,
    this.handler = const ChatHandler(),
    this.builders = const ChatBuilders(),
    required this.messages,
    this.inputOptions = const InputOptions(),
    this.messageOptions = const MessageOptions(),
    this.messageListOptions = const MessageListOptions(),
    this.quickReplyOptions = const QuickReplyOptions(),
    this.showScrollToBottomOption = true,
    this.readOnly = false,
    this.typingUsers,
    Key? key,
  }) : super(key: key);

  /// The current user of the chat
  final String currentUser;

  /// Handle function for messages and chat
  final ChatHandler handler;

  /// List of messages visible in the chat
  final List<ChatMessage> messages;

  final ChatBuilders builders;

  /// Options to customize the behaviour and design of the chat input
  final InputOptions inputOptions;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// Options to customize the behaviour and design of the overall list of message
  final MessageListOptions messageListOptions;

  /// Options to customize the behaviour and design of the quick replies
  final QuickReplyOptions quickReplyOptions;

  /// Options show the scroll-to-bottom button
  final bool showScrollToBottomOption;

  /// Option to make the chat read only, it will hide the input field
  final bool readOnly;

  /// List of users currently typing in the chat with the optional message
  /// es.
  /// "user_uid" : "typing message (es. Sta scrivendo...)"
  final Map<String, String>? typingUsers;

  @override
  State<DashChat> createState() => _DashChatState();
}

class _DashChatState extends State<DashChat> {
  late final ChatController controller;

  @override
  void initState() {
    controller = ChatController(
      currentUser: widget.currentUser,
      handler: widget.handler,
      initialMessages: widget.messages,
      initilTypingUsers: widget.typingUsers ?? <String, String>{},
      messageListOptions: widget.messageListOptions,
      messageOptions: widget.messageOptions,
      quickReplyOptions: widget.quickReplyOptions,
      readOnly: widget.readOnly,
      showScrollToBottomOption: widget.showScrollToBottomOption,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DashChat oldWidget) {
    if (oldWidget.messages != widget.messages) {
      controller.updateMessages(widget.messages);
    }
    if (oldWidget.typingUsers != widget.typingUsers) {
      controller.updateTypingUsers(widget.typingUsers ?? <String, String>{});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Column(
        children: <Widget>[
          Expanded(
            child: widget.messages.isEmpty
                ? (widget.messageListOptions.emptyListBuilder?.call(context) ??
                    const DefaultListEmptyBuilder())
                : MessagesList(
                    controller: controller,
                    builders: widget.builders,
                  ),
          ),
          if (!widget.readOnly)
            InputToolbar(
              controller: controller,
              inputOptions: widget.inputOptions,
            ),
        ],
      ),
    );
  }
}
