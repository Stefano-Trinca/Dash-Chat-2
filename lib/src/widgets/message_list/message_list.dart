part of '../../../dash_chat_2.dart';

class MessagesList extends StatelessWidget {
  const MessagesList(
      {super.key, required this.controller, required this.builders});

  final ChatController controller;
  final ChatBuilders builders;

  @override
  Widget build(BuildContext context) {
    final ValueListenableBuilder<List<ChatMessage>> list =
        ValueListenableBuilder(
      valueListenable: controller.notifierMessages,
      builder:
          (BuildContext context, List<ChatMessage> messages, Widget? child) {
        if (messages.isEmpty) {
          return builders.emptyBuilder?.call(context) ??
              const DefaultListEmptyBuilder();
        } else {
          return ValueListenableBuilder(
              valueListenable: controller.notifierTypingUsers,
              builder: (BuildContext context, Map<String, String> typingUsers,
                  Widget? child) {
                return _ListView(
                  controller: controller,
                  messages: typingUsers.isEmpty
                      ? messages
                      : [
                          for (var u in typingUsers.entries)
                            ChatMessage(
                              user: u.key,
                              createdAt: DateTime.now(),
                              type: MessageType.typing,
                              text: u.value,
                            ),
                          ...messages
                        ],
                  chatBuilders: builders,
                  messageOptions: controller.messageOptions,
                );
              });
        }
      },
    );

    final ValueListenableBuilder<bool> scrollToBottom = ValueListenableBuilder(
      valueListenable: controller.notifierShowScrollToBottom,
      builder: (BuildContext context, bool value, Widget? child) {
        if (value) {
          return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: DeafultScrollToBottom(
                  onPressed: controller.scrollToBottom,
                  backgroundColor: controller.messageListOptions
                      .scrollToBottomIconButtonBackgroundColor,
                  foregroundColor: controller.messageListOptions
                      .scrollToBottomIconButtonForegroundColor,
                ),
              ));
        } else {
          return SizedBox();
        }
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        list,
        // load more
        //TODO: add load more
        scrollToBottom,
      ],
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    super.key,
    required this.controller,
    required this.messages,
    required this.chatBuilders,
    required this.messageOptions,
  });

  final ChatController controller;
  final List<ChatMessage> messages;
  final ChatBuilders chatBuilders;
  final MessageOptions messageOptions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: ListView.builder(
          // physics: widget.messageListOptions.scrollPhysics,
          padding: controller.messageListOptions.messageListPadding,
          controller: controller.scrollController,
          reverse: true,

          itemCount: messages.length,
          itemBuilder: (BuildContext context, int i) {
            final ChatMessage? prevMessage =
                (i < messages.length - 1) ? messages[i + 1] : null;
            final ChatMessage? nextMessage = (i > 0) ? messages[i - 1] : null;
            final ChatMessage message = messages[i];

            final bool isAfterDateSeparator = _shouldShowDateSeparator(
                prevMessage, message, chatBuilders.separatorFrequency);
            bool isBeforeDateSeparator = false;
            if (nextMessage != null) {
              isBeforeDateSeparator = _shouldShowDateSeparator(
                  message, nextMessage, chatBuilders.separatorFrequency);
            }

            final Widget messageRow = messageOptions.messageRowBuilder != null
                ? messageOptions.messageRowBuilder!.call(
                    message,
                    prevMessage,
                    nextMessage,
                    isAfterDateSeparator,
                    isBeforeDateSeparator,
                  )
                : MessageRow(
                    currentUser: controller.currentUser,
                    message: message,
                    getChatUser: controller.handler.getChatUser,
                    nextMessage: nextMessage,
                    previousMessage: prevMessage,
                    isAfterDateSeparator: isAfterDateSeparator,
                    isBeforeDateSeparator: isBeforeDateSeparator,
                    messageOptions: messageOptions,
                    maxWidth:
                        constraints.maxWidth * messageOptions.maxWidthFactor,
                  );

            if (isAfterDateSeparator) {
              final Widget dateSeparator = chatBuilders.dateSeparatorBuilder !=
                      null
                  ? chatBuilders.dateSeparatorBuilder!.call(message.createdAt)
                  : DefaultDateSeparator(
                      date: message.createdAt,
                    );

              return Column(
                children: <Widget>[
                  dateSeparator,
                  messageRow,
                ],
              );
            } else {
              return messageRow;
            }
          },
        ),
      );
    });
  }

  /// Check if a date separator needs to be shown
  bool _shouldShowDateSeparator(ChatMessage? previousMessage,
      ChatMessage message, SeparatorFrequency separatorFrequency) {
    if (previousMessage == null) {
      // Means this is the first message
      return true;
    }
    switch (separatorFrequency) {
      case SeparatorFrequency.days:
        final DateTime previousDate = DateTime(
          previousMessage.createdAt.year,
          previousMessage.createdAt.month,
          previousMessage.createdAt.day,
        );
        final DateTime messageDate = DateTime(
          message.createdAt.year,
          message.createdAt.month,
          message.createdAt.day,
        );
        return previousDate.difference(messageDate).inDays.abs() > 0;
      case SeparatorFrequency.hours:
        final DateTime previousDate = DateTime(
          previousMessage.createdAt.year,
          previousMessage.createdAt.month,
          previousMessage.createdAt.day,
          previousMessage.createdAt.hour,
        );
        final DateTime messageDate = DateTime(
          message.createdAt.year,
          message.createdAt.month,
          message.createdAt.day,
          message.createdAt.hour,
        );
        return previousDate.difference(messageDate).inHours.abs() > 0;
      default:
        return false;
    }
  }
}

// class MessageList extends StatefulWidget {
//   const MessageList({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   /// The current user of the chat
//   final ChatUser currentUser;

//   /// List of messages visible in the chat
//   final List<ChatMessage> messages;

//   /// Whether the chat is read only, used for safe area
//   final bool readOnly;

//   /// Options to customize the behaviour and design of the messages
//   final MessageOptions messageOptions;

//   /// Options to customize the behaviour and design of the overall list of message
//   final MessageListOptions messageListOptions;

//   /// Options to customize the behaviour and design of the quick replies
//   final QuickReplyOptions quickReplyOptions;

//   /// Options to customize the behaviour and design of the scroll-to-bottom button
//   final ScrollToBottomOptions scrollToBottomOptions;

//   /// List of users currently typing in the chat
//   final List<ChatUser>? typingUsers;

//   @override
//   State<MessageList> createState() => MessageListState();
// }

// class MessageListState extends State<MessageList> {
//   bool scrollToBottomIsVisible = false;
//   bool isLoadingMore = false;
//   late ScrollController scrollController;

//   @override
//   void initState() {
//     scrollController =
//         widget.messageListOptions.scrollController ?? ScrollController();
//     scrollController.addListener(() => _onScroll());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return GestureDetector(
//         onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//         child: Stack(
//           children: <Widget>[
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   child: ListView.builder(
//                     physics: widget.messageListOptions.scrollPhysics,
//                     padding: widget.readOnly ? null : EdgeInsets.zero,
//                     controller: scrollController,
//                     reverse: true,
//                     itemCount: widget.messages.length,
//                     itemBuilder: (BuildContext context, int i) {
//                       final ChatMessage? previousMessage =
//                           i < widget.messages.length - 1
//                               ? widget.messages[i + 1]
//                               : null;
//                       final ChatMessage? nextMessage =
//                           i > 0 ? widget.messages[i - 1] : null;
//                       final ChatMessage message = widget.messages[i];
//                       final bool isAfterDateSeparator =
//                           _shouldShowDateSeparator(previousMessage, message,
//                               widget.messageListOptions);
//                       bool isBeforeDateSeparator = false;
//                       if (nextMessage != null) {
//                         isBeforeDateSeparator = _shouldShowDateSeparator(
//                             message, nextMessage, widget.messageListOptions);
//                       }
//                       return Column(
//                         children: <Widget>[
//                           if (isAfterDateSeparator)
//                             widget.messageListOptions.dateSeparatorBuilder !=
//                                     null
//                                 ? widget.messageListOptions
//                                     .dateSeparatorBuilder!(message.createdAt)
//                                 : DefaultDateSeparator(
//                                     date: message.createdAt,
//                                     messageListOptions:
//                                         widget.messageListOptions,
//                                   ),
//                           if (widget.messageOptions.messageRowBuilder !=
//                               null) ...<Widget>[
//                             widget.messageOptions.messageRowBuilder!(
//                               message,
//                               previousMessage,
//                               nextMessage,
//                               isAfterDateSeparator,
//                               isBeforeDateSeparator,
//                             ),
//                           ] else
//                             MessageRow(
//                               message: widget.messages[i],
//                               nextMessage: nextMessage,
//                               previousMessage: previousMessage,
//                               currentUser: widget.currentUser,
//                               isAfterDateSeparator: isAfterDateSeparator,
//                               isBeforeDateSeparator: isBeforeDateSeparator,
//                               messageOptions: widget.messageOptions,
//                               maxWidth: constraints.maxWidth * 0.7,
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 if (widget.typingUsers != null &&
//                     widget.typingUsers!.isNotEmpty)
//                   ...widget.typingUsers!.map((ChatUser user) {
//                     if (widget.messageListOptions.typingBuilder != null) {
//                       return widget.messageListOptions.typingBuilder!(user);
//                     }
//                     return DefaultTypingBuilder(user: user);
//                   }),
//                 if (widget.messageListOptions.showFooterBeforeQuickReplies &&
//                     widget.messageListOptions.chatFooterBuilder != null)
//                   widget.messageListOptions.chatFooterBuilder!,
//                 if (widget.messages.isNotEmpty &&
//                     widget.messages.first.quickReplies != null &&
//                     widget.messages.first.quickReplies!.isNotEmpty &&
//                     widget.messages.first.user.id != widget.currentUser.id)
//                   QuickReplies(
//                     quickReplies: widget.messages.first.quickReplies!,
//                     quickReplyOptions: widget.quickReplyOptions,
//                   ),
//                 if (!widget.messageListOptions.showFooterBeforeQuickReplies &&
//                     widget.messageListOptions.chatFooterBuilder != null)
//                   widget.messageListOptions.chatFooterBuilder!,
//               ],
//             ),
//             if (isLoadingMore)
//               Positioned(
//                 top: 8.0,
//                 right: 0,
//                 left: 0,
//                 child: widget.messageListOptions.loadEarlierBuilder ??
//                     const Center(
//                       child: SizedBox(
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//               ),
//             if (!widget.scrollToBottomOptions.disabled &&
//                 scrollToBottomIsVisible)
//               widget.scrollToBottomOptions.scrollToBottomBuilder != null
//                   ? widget.scrollToBottomOptions
//                       .scrollToBottomBuilder!(scrollController)
//                   : DefaultScrollToBottomOld(
//                       scrollController: scrollController,
//                       readOnly: widget.readOnly,
//                       backgroundColor:
//                           Theme.of(context).scaffoldBackgroundColor,
//                       textColor: Theme.of(context).primaryColor,
//                     ),
//           ],
//         ),
//       );
//     });
//   }

//   /// Check if a date separator needs to be shown
//   bool _shouldShowDateSeparator(ChatMessage? previousMessage,
//       ChatMessage message, MessageListOptions messageListOptions) {
//     if (!messageListOptions.showDateSeparator) {
//       return false;
//     }
//     if (previousMessage == null) {
//       // Means this is the first message
//       return true;
//     }
//     switch (messageListOptions.separatorFrequency) {
//       case SeparatorFrequency.days:
//         final DateTime previousDate = DateTime(
//           previousMessage.createdAt.year,
//           previousMessage.createdAt.month,
//           previousMessage.createdAt.day,
//         );
//         final DateTime messageDate = DateTime(
//           message.createdAt.year,
//           message.createdAt.month,
//           message.createdAt.day,
//         );
//         return previousDate.difference(messageDate).inDays.abs() > 0;
//       case SeparatorFrequency.hours:
//         final DateTime previousDate = DateTime(
//           previousMessage.createdAt.year,
//           previousMessage.createdAt.month,
//           previousMessage.createdAt.day,
//           previousMessage.createdAt.hour,
//         );
//         final DateTime messageDate = DateTime(
//           message.createdAt.year,
//           message.createdAt.month,
//           message.createdAt.day,
//           message.createdAt.hour,
//         );
//         return previousDate.difference(messageDate).inHours.abs() > 0;
//       default:
//         return false;
//     }
//   }
// }
