part of '../../../dash_chat_2.dart';

/// @nodoc
class TextContainer extends StatelessWidget {
  const TextContainer({
    required this.message,
    this.messageOptions = const MessageOptions(),
    this.previousMessage,
    this.nextMessage,
    this.isOwnMessage = false,
    this.isPreviousSameAuthor = false,
    this.isNextSameAuthor = false,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageTextBuilder,
    Key? key,
  }) : super(key: key);

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// Message that contains the text to show
  final ChatMessage message;

  /// Previous message in the list
  final ChatMessage? previousMessage;

  /// Next message in the list
  final ChatMessage? nextMessage;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// If the previous message is from the same author as the current one
  final bool isPreviousSameAuthor;

  /// If the next message is from the same author as the current one
  final bool isNextSameAuthor;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before by a date separator
  final bool isBeforeDateSeparator;

  /// We could access that from messageOptions but we want to reuse this widget
  /// for media and be able to override the text builder
  final Widget? Function(ChatMessage, ChatMessage?, ChatMessage?)?
      messageTextBuilder;

  @override
  Widget build(BuildContext context) {
    final childMessage = (message.type == MessageType.typing)
        ? DefaultMessageTypingUser(
            message: message,
            messageOptions: messageOptions,
          )
        : messageTextBuilder?.call(message, previousMessage, nextMessage) ??
            DefaultMessageText(
              message: message,
              isOwnMessage: isOwnMessage,
              messageOptions: messageOptions,
            );

    if (message.type == MessageType.system) {
      return Padding(
        padding: messageOptions.messagePadding,
        child: childMessage,
      );
    }

    return Container(
      decoration: messageOptions.messageDecorationBuilder != null
          ? messageOptions.messageDecorationBuilder!(
              message, previousMessage, nextMessage)
          : defaultMessageDecoration(
              color: messageOptions.getContainerColor(context, isOwnMessage),
              borderTopLeft: (!isNextSameAuthor && !isOwnMessage) ||
                      (isAfterDateSeparator && !isOwnMessage)
                  ? 6.0
                  : messageOptions.borderRadius,
              borderTopRight: (!isNextSameAuthor && isOwnMessage) ||
                      (isAfterDateSeparator && isOwnMessage)
                  ? 6.0
                  : messageOptions.borderRadius,
              borderBottomLeft:
                  // !isOwnMessage && !isBeforeDateSeparator && isNextSameAuthor
                  //     ? 6.0 :
                  messageOptions.borderRadius,
              borderBottomRight:
                  // isOwnMessage && !isBeforeDateSeparator && isNextSameAuthor
                  //     ? 6.0 :
                  messageOptions.borderRadius,
            ),
      padding: message.type == MessageType.typing
          ? messageOptions.typingPadding
          : messageOptions.messagePadding,
      child: childMessage,
    );
  }
}
