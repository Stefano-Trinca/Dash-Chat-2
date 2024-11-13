part of '../../../dash_chat_2.dart';

/// @nodoc
class MessageRow extends StatelessWidget {
  const MessageRow({
    super.key,
    required this.message,
    required this.currentUser,
    this.previousMessage,
    this.nextMessage,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageOptions = const MessageOptions(),
    required this.maxWidth,
    this.getChatUser,
  });

  /// Current message to show
  final ChatMessage message;

  /// Previous message in the list
  final ChatMessage? previousMessage;

  /// Next message in the list
  final ChatMessage? nextMessage;

  /// Current user of the chat
  final String currentUser;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before a date separator
  final bool isBeforeDateSeparator;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// message max width based on the view width
  final double maxWidth;

  final Future<ChatUser> Function(String uid)? getChatUser;

  /// Get the avatar widget
  Widget getAvatar() {
    return messageOptions.avatarBuilder != null
        ? messageOptions.avatarBuilder!(
            message.user,
            messageOptions.onPressAvatar,
            messageOptions.onLongPressAvatar,
          )
        : DefaultAvatar(
            user: message.user,
            onLongPressAvatar: messageOptions.onLongPressAvatar,
            onPressAvatar: messageOptions.onPressAvatar,
            getChatUser: getChatUser,
          );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSystem = message.type == MessageType.system;
    final bool isOwnMessage = message.user == currentUser;
    bool isPreviousSameAuthor = false;
    bool isNextSameAuthor = false;
    if (previousMessage != null && previousMessage!.user == message.user) {
      isPreviousSameAuthor = true;
    }
    if (nextMessage != null && nextMessage!.user == message.user) {
      isNextSameAuthor = true;
    }

    Widget? userNameWidget;
    if (!isOwnMessage &&
        messageOptions.showOtherUsersName &&
        messageOptions.userNameBuilder != null &&
        (!isPreviousSameAuthor || isAfterDateSeparator)) {
      userNameWidget = messageOptions.userNameBuilder!.call(message.user);
    }

    return Container(
      margin: isAfterDateSeparator
          ? EdgeInsets.zero
          : isPreviousSameAuthor
              ? messageOptions.marginSameAuthor
              : messageOptions.marginDifferentAuthor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (messageOptions.showOtherUsersAvatar)
            Opacity(
              opacity: !isOwnMessage &&
                      (!isNextSameAuthor || isBeforeDateSeparator) &&
                      !isSystem
                  ? 1
                  : 0,
              child: getAvatar(),
            ),
          if (!messageOptions.showOtherUsersAvatar)
            SizedBox(width: messageOptions.spaceWhenAvatarIsHidden),
          GestureDetector(
            onLongPress: messageOptions.onLongPressMessage != null
                ? () => messageOptions.onLongPressMessage!(message)
                : null,
            onTap: messageOptions.onPressMessage != null
                ? () => messageOptions.onPressMessage!(message)
                : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: messageOptions.maxWidth ?? maxWidth,
              ),
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (messageOptions.top != null)
                    messageOptions.top!(message, previousMessage, nextMessage),
                  if (userNameWidget != null) userNameWidget,
                  if (message.medias != null &&
                      message.medias!.isNotEmpty &&
                      messageOptions.textBeforeMedia)
                    messageOptions.messageMediaBuilder != null
                        ? messageOptions.messageMediaBuilder!(
                            message, previousMessage, nextMessage)
                        : MediaContainer(
                            message: message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: messageOptions,
                          ),
                  if (message.text.isNotEmpty ||
                      message.type == MessageType.typing)
                    TextContainer(
                      messageOptions: messageOptions,
                      message: message,
                      previousMessage: previousMessage,
                      nextMessage: nextMessage,
                      isOwnMessage: isOwnMessage,
                      isNextSameAuthor: isNextSameAuthor,
                      isPreviousSameAuthor: isPreviousSameAuthor,
                      isAfterDateSeparator: isAfterDateSeparator,
                      isBeforeDateSeparator: isBeforeDateSeparator,
                      messageTextBuilder: messageOptions.messageTextBuilder,
                    ),
                  if (message.medias != null &&
                      message.medias!.isNotEmpty &&
                      !messageOptions.textBeforeMedia)
                    messageOptions.messageMediaBuilder != null
                        ? messageOptions.messageMediaBuilder!(
                            message, previousMessage, nextMessage)
                        : MediaContainer(
                            message: message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: messageOptions,
                          ),
                  if (messageOptions.bottom != null)
                    messageOptions.bottom!(
                        message, previousMessage, nextMessage),
                ],
              ),
            ),
          ),
          if (messageOptions.showCurrentUserAvatar)
            Opacity(
              opacity: isOwnMessage && !isNextSameAuthor ? 1 : 0,
              child: getAvatar(),
            ),
          if (!messageOptions.showCurrentUserAvatar)
            SizedBox(width: messageOptions.spaceWhenAvatarIsHidden),
        ],
      ),
    );
  }
}
