part of '../../dash_chat_2.dart';

/// {@category Customization}
class MessageListOptions {
  const MessageListOptions({
    this.showDateSeparator = true,
    this.dateSeparatorFormat,
    this.dateSeparatorBuilder,
    this.emptyListBuilder,
    this.separatorFrequency = SeparatorFrequency.hours,
    this.scrollController,
    this.chatFooterBuilder,
    this.showFooterBeforeQuickReplies = false,
    this.loadEarlierBuilder,
    this.onLoadEarlier,
    this.typingBuilder,
    this.scrollPhysics,
    this.scrollToBottomIconButtonBackgroundColor,
    this.scrollToBottomIconButtonForegroundColor,
    this.messageListPadding = const EdgeInsets.all(0),
  });

  /// If you want to who a date separator between messages of different dates
  final bool showDateSeparator;

  /// The formatting of the date in the date separator.
  /// By default it will adapt according to the difference with today
  final intl.DateFormat? dateSeparatorFormat;

  /// If you want to create you own separator widget
  /// You can use DefaultDateSeparator to only override some variables
  final Widget Function(DateTime date)? dateSeparatorBuilder;

  /// If no message in the list source
  final Widget Function(BuildContext context)? emptyListBuilder;

  /// The frequency of the separator
  final SeparatorFrequency separatorFrequency;

  /// Scroll controller of the list of message
  final ScrollController? scrollController;

  /// A widget to show at the bottom of the chat
  /// (between the input and the chat content)
  final Widget? chatFooterBuilder;

  /// If you want to show [chatFooterBuilder] before or after the quick replies
  final bool showFooterBeforeQuickReplies;

  /// If you want to show a widget when the top of the list is reached
  final Widget? loadEarlierBuilder;

  /// Function to call when the top of the list is reached
  /// Useful to load more messages
  final Future<void> Function()? onLoadEarlier;

  /// Builder to create your own typing widget
  final Widget Function(ChatUser user)? typingBuilder;

  /// Scroll physics of the ListView
  final ScrollPhysics? scrollPhysics;

  /// Color of the scroll to bottom icon button
  final Color? scrollToBottomIconButtonBackgroundColor;

  /// Color of the scroll to bottom icon
  final Color? scrollToBottomIconButtonForegroundColor;

  /// Padding of the message list
  final EdgeInsets messageListPadding;
}

enum SeparatorFrequency { days, hours }
