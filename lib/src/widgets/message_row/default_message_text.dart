part of '../../../dash_chat_2.dart';

/// {@category Default widgets}
class DefaultMessageText extends StatelessWidget {
  const DefaultMessageText({
    required this.message,
    required this.isOwnMessage,
    this.messageOptions = const MessageOptions(),
    super.key,
  });

  /// Message tha contains the text to show
  final ChatMessage message;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  @override
  Widget build(BuildContext context) {
    Widget messageContent = getMessage(context);
    Widget? messagePrefix = messageOptions.messagePrefixBuilder?.call(
      message,
      isOwnMessage,
    );

    if (messagePrefix != null) {
      messageContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          messagePrefix,
          Flexible(child: messageContent),
        ],
      );
    }

    if (!messageOptions.showTime &&
        messageOptions.messageActionsBuilder == null) {
      return messageContent;
    }

    return Column(
      crossAxisAlignment:
          // CrossAxisAlignment.end,
          isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        messageContent,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (messageOptions.messageActionsBuilder != null)
              messageOptions.messageActionsBuilder!.call(message, isOwnMessage)
            else
              const SizedBox(),
            if (!messageOptions.showTime)
              const SizedBox()
            else
              messageOptions.messageTimeBuilder != null
                  ? messageOptions.messageTimeBuilder!(message, isOwnMessage)
                  : Padding(
                      padding: messageOptions.timePadding,
                      child: Text(
                        (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
                            .format(message.createdAt),
                        style: TextStyle(
                          color: messageOptions.getTimeTextColor(
                              context, isOwnMessage),
                          fontSize: messageOptions.timeFontSize,
                        ),
                      ),
                    )
          ],
        ),
      ],
    );
  }

  Widget getMessage(BuildContext context) {
    // print('message status: ${message.toJson()}');
    if (message.status == MessageStatus.streaming) {
      return StreamBuilder<String>(
        stream: messageOptions.messageStreamBuilder?.call(message) ??
            Stream<String>.value(message.text),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            _getMessage(context, snapshot.data ?? ''),
      );
    } else {
      return _getMessage(context, message.text);
    }
  }

  Widget _getMessage(BuildContext context, String messageText) {
    if (message.isMarkdown) {
      return SelectionArea(
        child: messageOptions.markdownBodyBuilder
                ?.call(messageText, messageOptions.markdownStyleSheet) ??
            MarkdownBody(
              data: messageText,
              styleSheet: messageOptions.markdownStyleSheet,
              onTapLink: (String value, String? href, String title) {
                if (href != null) {
                  openLink(href);
                } else {
                  openLink(value);
                }
              },
            ),
      );
    }

    Color textColor = message.type == MessageType.system
        ? messageOptions.getTimeTextColor(context, false)
        : ((message.status?.isFailed ?? false)
            ? messageOptions.getTextColorFailed(context, isOwnMessage)
            : messageOptions.getTextColor(context, isOwnMessage));

    if (message.mentions != null && message.mentions!.isNotEmpty) {
      List<TextSpan> spans = <TextSpan>[];

      String remainingText = messageText;
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

      final TextSpan span = TextSpan(children: spans);
      if (messageOptions.selectable) {
        return SelectableText.rich(span);
      } else {
        return RichText(
          text: span,
        );
      }
    }

    final TextSpan textSpan = TextSpan(
      text: messageText,
      style: TextStyle(
        color: textColor,
      ),
    );

    return messageOptions.selectable
        ? SelectableText.rich(textSpan)
        : RichText(text: textSpan);
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
              color: messageOptions.getTextColor(context, isOwnMessage),
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
          color: messageOptions.getTextColor(context, isOwnMessage),
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
