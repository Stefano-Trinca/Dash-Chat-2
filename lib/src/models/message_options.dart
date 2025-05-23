part of '../../dash_chat_2.dart';

/// {@category Customization}
class MessageOptions {
  const MessageOptions({
    this.showCurrentUserAvatar = false,
    this.showOtherUsersAvatar = true,
    this.showOtherUsersName = true,
    this.userNameBuilder,
    this.avatarBuilder,
    this.onPressAvatar,
    this.onLongPressAvatar,
    this.onLongPressMessage,
    this.onPressMessage,
    this.onPressMention,
    this.messagePadding = const EdgeInsets.all(11),
    this.typingPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    this.maxWidth,
    this.maxWidthFactor = 0.7,
    this.messageDecorationBuilder,
    this.top,
    this.bottom,
    this.messageRowBuilder,
    this.messageTextBuilder,
    this.parsePatterns,
    this.textBeforeMedia = true,
    this.onTapMedia,
    this.showTime = false,
    this.timeFormat,
    this.messagePrefixBuilder,
    this.messageTimeBuilder,
    this.messageActionsBuilder,
    this.messageMediaBuilder,
    this.borderRadius = 18.0,
    this.marginDifferentAuthor = const EdgeInsets.only(top: 15),
    this.marginSameAuthor = const EdgeInsets.only(top: 2),
    this.spaceWhenAvatarIsHidden = 10.0,
    this.timeFontSize = 10.0,
    this.timePadding = const EdgeInsets.only(top: 5),
    this.markdownStyleSheet,
    this.markdownBodyBuilder,
    this.messageStreamBuilder,
    this.selectable = true,
    Color? currentUserContainerColor,
    Color? currentUserTextColor,
    Color? containerColor,
    Color? textColor,
    Color? textColorFailed,
    Color? currentUserTimeTextColor,
    Color? timeTextColor,
    Color? typingTextColor,
    Color? typingTextColorShimmer,
  })  : _currentUserContainerColor = currentUserContainerColor,
        _containerColor = containerColor,
        _currentUserTextColor = currentUserTextColor,
        _currentUserTimeTextColor = currentUserTimeTextColor,
        _textColor = textColor,
        _textColorFailed = textColorFailed,
        _timeTextColor = timeTextColor,
        _typingTextColor = typingTextColor,
        _typingTextColorShimmer = typingTextColorShimmer;

  // Fields for color options

  /// Color of the current user's chat bubbles
  final Color? _currentUserContainerColor;

  /// Color of the other users' chat bubbles
  final Color? _containerColor;

  /// Color of the current user's text in chat bubbles
  final Color? _currentUserTextColor;

  /// Color of the other users' text in chat bubbles
  final Color? _textColor;

  /// Color of the text in failed messages
  final Color? _textColorFailed;

  /// Color of the current user's time text in chat bubbles
  final Color? _currentUserTimeTextColor;

  /// Color of the other users' time text in chat bubbles
  final Color? _timeTextColor;

  /// Color of the typing text in chat bubbles
  final Color? _typingTextColor;

  /// Color of the typing text shimmer in chat bubbles
  final Color? _typingTextColorShimmer;

  /// General method to get the container color based on the user type.
  /// If [isOwnMessage] is true, it will return the current user's container color.
  /// Otherwise, it will return the other user's container color.
  Color getContainerColor(BuildContext context, bool isOwnMessage) {
    return isOwnMessage
        ? (_currentUserContainerColor ?? Theme.of(context).primaryColor)
        : (_containerColor ?? Theme.of(context).colorScheme.secondaryContainer);
  }

  /// General method to get the text color based on the user type.
  /// If [isOwnMessage] is true, it will return the current user's text color.
  /// Otherwise, it will return the other user's text color.
  Color getTextColor(BuildContext context, bool isOwnMessage) {
    return isOwnMessage
        ? (_currentUserTextColor ?? Theme.of(context).colorScheme.onPrimary)
        : (_textColor ?? Theme.of(context).colorScheme.onSurface);
  }

  /// General method to get the text color for failed messages.
  /// if setted, it will return the failed text color.
  /// Otherwise, it will return the default text color.
  Color getTextColorFailed(BuildContext context, bool isOwnMessage) {
    return _textColorFailed ?? getTextColor(context, isOwnMessage);
  }

  /// General method to get the time text color based on the user type.
  /// If [isOwnMessage] is true, it will return the current user's time text color.
  /// Otherwise, it will return the other user's time text color.
  Color getTimeTextColor(BuildContext context, bool isOwnMessage) {
    return isOwnMessage
        ? (_currentUserTimeTextColor ??
            getTextColor(context, true).withOpacity(0.6))
        : (_timeTextColor ?? getTextColor(context, false).withOpacity(0.6));
  }

  /// General method to get the typing text color based on the user type.
  Color getTypingTextColor(BuildContext context) {
    return _typingTextColor ?? getTextColor(context, false).withAlpha(246);
  }

  /// General method to get the typing text shimmer color based on the user type.
  Color getTypingTextColorShimmer(BuildContext context) {
    return _typingTextColorShimmer ??
        getContainerColor(context, false).withAlpha(200);
  }

  // Rest of the properties and methods remain unchanged

  /// Format of the time if [showTime] is true
  /// Default to: DateFormat('HH:mm')
  final intl.DateFormat? timeFormat;

  /// If you want to show the time under the text of each message
  final bool showTime;

  /// If you want to show the avatar of the current user
  final bool showCurrentUserAvatar;

  /// If you want to show the avatar of the other users
  final bool showOtherUsersAvatar;

  /// If you want to show the name of the other users above the messages
  /// Useful in group chats
  final bool showOtherUsersName;

  /// If you want to create your own userName widget when [showOtherUsersName] is true
  /// You can use DefaultUserName to only override some variables
  final Widget Function(String userUid)? userNameBuilder;

  /// Builder to create your own avatar
  /// You can use DefaultAvatar to only override some variables
  final Widget Function(
          String userUid, Function? onPressAvatar, Function? onLongPressAvatar)?
      avatarBuilder;

  /// Widget prefix inside the message container
  final Widget? Function(ChatMessage message, bool isOwnMessage)?
      messagePrefixBuilder;

  /// Function to call when the user press on an avatar
  final Function(String userUid)? onPressAvatar;

  /// Function to call when the user long press on an avatar
  final Function(String userUi)? onLongPressAvatar;

  /// Function to call when the user long press on a message
  final Function(ChatMessage)? onLongPressMessage;

  /// Function to call when the user press on a message
  final Function(ChatMessage)? onPressMessage;

  /// Function to call when the user press on a message mention
  final Function(Mention)? onPressMention;

  /// Builder to create the entire message row yourself
  final Widget Function(
      ChatMessage message,
      ChatMessage? previousMessage,
      ChatMessage? nextMessage,
      bool isAfterDateSeparator,
      bool isBeforeDateSeparator)? messageRowBuilder;

  /// Builder to create own message text widget
  ///
  /// you can access the 'DefaultMessageText' to only override some variables
  final Widget? Function(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage)? messageTextBuilder;

  /// Builder to create your own media container widget
  final Widget Function(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage)? messageMediaBuilder;

  /// Builder to create your own time widget
  /// (shown under the text when [showTime] is true)
  final Widget Function(ChatMessage message, bool isOwnMessage)?
      messageTimeBuilder;

  /// Builder for create a custom actions on the bottom of the bubble
  final Widget Function(ChatMessage message, bool isOwnMessage)?
      messageActionsBuilder;

  /// List of MatchText using flutter_parsed_text library
  /// to parse and customize accordingly some part of the text
  /// By default ParsedType.URL is set and will use launchUrl to open the link
  final List<MatchText>? parsePatterns;

  /// Padding around the text in chat bubbles
  ///
  /// Default to: EdgeInsets.all(11)
  final EdgeInsets messagePadding;

  /// Padding around the text in chat bubbles
  ///
  /// Default to: EdgeInsets.symetric(horizontal: 24, vertical: 4)
  final EdgeInsets typingPadding;

  /// Max message width
  ///
  /// Default to: BoxConstraints.maxWidth * 0.7
  final double? maxWidth;

  /// Max message with factor
  ///
  /// Default to: 0.7
  final double maxWidthFactor;

  /// When a message has both text and a list of media
  /// it will determine which one to show first
  final bool textBeforeMedia;

  /// To create your own BoxDecoration for the chat bubble
  /// You can use defaultMessageDecoration to only override some variables
  final BoxDecoration Function(
      ChatMessage message,
      ChatMessage? previousMessage,
      ChatMessage? nextMessage)? messageDecorationBuilder;

  /// A widget to show above the chat bubble
  final Widget Function(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage)? top;

  /// A widget to show under the chat bubble
  final Widget Function(ChatMessage message, ChatMessage? previousMessage,
      ChatMessage? nextMessage)? bottom;

  /// Function to call when the user clicks on a media
  /// Will not work with the default video player
  final void Function(ChatMedia media)? onTapMedia;

  /// Border radius of the chat bubbles
  ///
  /// Default to: 18.0
  final double borderRadius;

  /// Margin around the chat bubble when the previous author is different
  ///
  /// Default to: const EdgeInsets.only(top: 15)
  final EdgeInsets marginDifferentAuthor;

  /// Margin around the chat bubble when the previous author is the same
  ///
  /// Default to: const EdgeInsets.only(top: 2)
  final EdgeInsets marginSameAuthor;

  /// Space between chat bubble and edge of the list when avatar is hidden via [showOtherUsersAvatar] or [showCurrentUserAvatar]
  ///
  /// Default to: 10.0
  final double spaceWhenAvatarIsHidden;

  /// Font size of the time text in chat bubbles
  ///
  /// Default to: 10.0
  final double timeFontSize;

  /// Space between time and message text in chat bubbles
  ///
  /// Default to: const EdgeInsets.only(top: 5)
  final EdgeInsets timePadding;

  /// Stylesheet for markdown message rendering
  final MarkdownStyleSheet? markdownStyleSheet;

  /// Custom markdown body builder
  final Widget Function(String data, MarkdownStyleSheet? markdownStyleSheet)?
      markdownBodyBuilder;

  /// Message stream for message that are in stream status
  final Stream<String> Function(ChatMessage message)? messageStreamBuilder;

  /// if the message is selectable
  final bool selectable;
}
