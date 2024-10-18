part of '../../../dash_chat_2.dart';

/// {@category Default widgets}
class DefaultMessageText extends StatelessWidget {
  const DefaultMessageText({
    required this.message,
    required this.isOwnMessage,
    this.messageOptions = const MessageOptions(),
    Key? key,
  }) : super(key: key);

  /// Message tha contains the text to show
  final ChatMessage message;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        getMessage(context),
        if (messageOptions.showTime)
          messageOptions.messageTimeBuilder != null
              ? messageOptions.messageTimeBuilder!(message, isOwnMessage)
              : Padding(
                  padding: messageOptions.timePadding,
                  child: Text(
                    (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
                        .format(message.createdAt),
                    style: TextStyle(
                      color: isOwnMessage
                          ? messageOptions.currentUserTimeTextColor(context)
                          : messageOptions.timeTextColor(),
                      fontSize: messageOptions.timeFontSize,
                    ),
                  ),
                ),
      ],
    );
  }

  Widget getMessage(BuildContext context) {
    if (message.isMarkdown) {
      return MarkdownBody(
        data: message.text,
        selectable: true,
        styleSheet: messageOptions.markdownStyleSheet,
        onTapLink: (String value, String? href, String title) {
          if (href != null) {
            openLink(href);
          } else {
            openLink(value);
          }
        },
      );
    } else if (message.mentions != null && message.mentions!.isNotEmpty) {
      List<TextSpan> spans = <TextSpan>[];

      Color textColor = message.type == MessageType.system
          ? messageOptions.timeTextColor()
          : isOwnMessage
              ? messageOptions.currentUserTextColor(context)
              : messageOptions.textColor;

      String remainingText = message.text;
      for (final Mention mention in message.mentions!) {
        int mentionIndex = remainingText.indexOf(mention.title);

        if (mentionIndex != -1) {
          if (mentionIndex > 0) {
            spans.add(TextSpan(
              text: remainingText.substring(0, mentionIndex),
              style: TextStyle(
                color: textColor,
              ),
            ));
          }

          spans.add(TextSpan(
            text: mention.title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (messageOptions.onPressMention != null) {
                  messageOptions.onPressMention!(mention);
                }
              },
          ));

          remainingText =
              remainingText.substring(mentionIndex + mention.title.length);
        }
      }

      if (remainingText.isNotEmpty) {
        spans.add(TextSpan(
          text: remainingText,
          style: TextStyle(
            color: textColor,
          ),
        ));
      }

      return RichText(
        text: TextSpan(children: spans),
      );
    }

    return RichText(
      text: TextSpan(
        text: message.text,
        style: TextStyle(
          color: isOwnMessage
              ? messageOptions.currentUserTextColor(context)
              : messageOptions.textColor,
        ),
      ),
    );
  }

  Widget getParsePattern(BuildContext context, String text, bool isMarkdown) {
    return isMarkdown
        ? MarkdownBody(
            data: text,
            selectable: true,
            styleSheet: messageOptions.markdownStyleSheet,
            onTapLink: (String value, String? href, String title) {
              if (href != null) {
                openLink(href);
              } else {
                openLink(value);
              }
            },
          )
        : ParsedText(
            parse: messageOptions.parsePatterns != null
                ? messageOptions.parsePatterns!
                : defaultParsePatterns,
            text: text,
            style: TextStyle(
              color: isOwnMessage
                  ? messageOptions.currentUserTextColor(context)
                  : messageOptions.textColor,
            ),
          );
  }

  Widget getMention(BuildContext context, Mention mention) {
    return RichText(
      text: TextSpan(
        text: mention.title,
        recognizer: TapGestureRecognizer()
          ..onTap = () => messageOptions.onPressMention != null
              ? messageOptions.onPressMention!(mention)
              : null,
        style: TextStyle(
          color: isOwnMessage
              ? messageOptions.currentUserTextColor(context)
              : messageOptions.textColor,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
