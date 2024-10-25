part of '../../dash_chat_2.dart';

/// {@category Customization}
class InputOptions {
  const InputOptions({
    this.alwaysShowSend = false,
    this.alwaysShowTrailing = false,
    this.autocorrect = true,
    this.cursorStyle = const CursorStyle(),
    this.focusNode,
    this.inputCapitalization = TextCapitalization.none,
    this.inputController,
    this.inputDecoration,
    this.inputDisabled = false,
    this.inputMaxLines = 5,
    this.inputTextDirection = TextDirection.ltr,
    this.inputTextStyle,
    this.inputToolbarMargin = const EdgeInsets.only(top: 8.0),
    this.inputToolbarPadding = const EdgeInsets.all(8.0),
    this.inputToolbarStyle,
    this.leading,
    this.maxInputLength,
    this.mentionTileBuilder,
    this.onMentionTriggers = const <String>['@'],
    this.onTextChange,
    this.sendButtonBuilder,
    this.sendIcon = Icons.send,
    this.sendOnEnter = true,
    this.showTrailingBeforeSend = false,
    this.textInputAction,
    this.trailing,
  });

  /// Always show the send button; will be hidden when the text is empty otherwise
  final bool alwaysShowSend;

  /// Always show the trailing widget; will be hidden when the text is not empty otherwise
  final bool alwaysShowTrailing;

  /// Whether to enable auto-correction. Defaults to true.
  final bool autocorrect;

  /// Style of the cursor
  final CursorStyle cursorStyle;

  /// Focus node of the input field
  final FocusNode? focusNode;

  /// Use to override the default TextCapitalization
  final TextCapitalization inputCapitalization;

  /// Text controller for the input field
  final TextEditingController? inputController;

  /// Input decoration to customize the design of the input field
  /// You can use defaultInputDecoration to only override some variables
  final InputDecoration? inputDecoration;

  /// To disable the input
  final bool inputDisabled;

  /// Max number of visible lines of the input; it will grow until this value and then scroll
  final int inputMaxLines;

  /// Use to change the direction of the text
  final TextDirection inputTextDirection;

  /// To customize the text style of the input
  final TextStyle? inputTextStyle;

  /// Margin of the overall container of the input
  final EdgeInsets? inputToolbarMargin;

  /// Padding of the overall container of the input
  final EdgeInsets? inputToolbarPadding;

  /// To customize the overall container of the input
  final BoxDecoration? inputToolbarStyle;

  /// A list of widgets to show before the input
  final List<Widget>? leading;

  /// If you want to limit the length of the text
  final int? maxInputLength;

  /// The list of string triggers for the onMention callback
  /// By default, it only includes '@' character
  final List<String> onMentionTriggers;

  final Widget Function(
          Object item, Function(String value, Mention mention) onSelect)?
      mentionTileBuilder;

  /// Function to call when the input text changes
  final void Function(String value)? onTextChange;

  /// Builder to create your own send button widget
  /// You can use defaultSendButton to only override some variables
  final Widget Function(void Function() send)? sendButtonBuilder;

  /// Icon for the send button
  final IconData sendIcon;

  /// Send the message when the user presses the enter key
  final bool sendOnEnter;

  /// If [trailing] should be shown before or after the send button
  final bool showTrailingBeforeSend;

  /// An action the user has requested the text input control to perform
  final TextInputAction? textInputAction;

  /// A list of widgets to show after the input
  final List<Widget>? trailing;
}
