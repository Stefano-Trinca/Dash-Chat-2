part of '../../../dash_chat_2.dart';

/// @nodoc
class InputToolbar extends StatefulWidget {
  const InputToolbar({
    required this.controller,
    this.inputOptions = const InputOptions(),
    Key? key,
  }) : super(key: key);

  final ChatController controller;

  /// Options to custom the toolbar
  final InputOptions inputOptions;

  @override
  State<InputToolbar> createState() => InputToolbarState();
}

class InputToolbarState extends State<InputToolbar>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final double bottomInset = View.of(context).viewInsets.bottom;
    final bool isKeyboardActive = bottomInset > 0.0;
    if (!isKeyboardActive) {
      widget.controller.clearOverlay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget trailing = ValueListenableBuilder(
      valueListenable: widget.controller.notifierInputIsWriting,
      builder: (BuildContext context, bool value, Widget? child) {
        // determinat if to show the trailing
        final bool showTrailing = (widget.inputOptions.trailing != null &&
                widget.inputOptions.trailing!.isNotEmpty) &&
            (value || widget.inputOptions.alwaysShowTrailing);

        if (showTrailing) {
          return Row(
            children: widget.inputOptions.trailing!,
          );
        } else {
          return const SizedBox();
        }
      },
    );

    final Widget sendButton = ValueListenableBuilder(
      valueListenable: widget.controller.notifierInputIsWriting,
      builder: (BuildContext context, bool value, Widget? child) {
        if (value || widget.inputOptions.alwaysShowSend) {
          return widget.inputOptions.sendButtonBuilder != null
              ? widget.inputOptions
                  .sendButtonBuilder!(() => widget.controller.sendMessage())
              : DefaultSendButton(
                  onSend: () => widget.controller.sendMessage(),
                  icon: widget.inputOptions.sendIcon,
                );
        } else {
          return const SizedBox();
        }
      },
    );

    final Widget field = Directionality(
      textDirection: widget.inputOptions.inputTextDirection,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            final bool isAltPressed = HardwareKeyboard.instance.isAltPressed;

            if (isAltPressed && event is KeyDownEvent) {
              final String text = widget.controller.inputController.text;
              final TextSelection selection =
                  widget.controller.inputController.selection;
              widget.controller.inputController.text =
                  text.replaceRange(selection.start, selection.end, '\n');
              widget.controller.inputController.selection = selection.copyWith(
                baseOffset: selection.start + 1,
                extentOffset: selection.start + 1,
              );
            } else if (event is KeyDownEvent && !isAltPressed) {
              widget.controller.sendMessage();
            }
          }
        },
        child: TextField(
          focusNode: widget.controller.inputFocusNode,
          controller: widget.controller.inputController,
          enabled: !widget.inputOptions.inputDisabled,
          textCapitalization: widget.inputOptions.inputCapitalization,
          textInputAction: TextInputAction.none,
          // keyboardType: TextInputType.multiline,
          decoration:
              widget.inputOptions.inputDecoration ?? defaultInputDecoration(),
          maxLength: widget.inputOptions.maxInputLength,
          minLines: 1,
          maxLines: widget.inputOptions.inputMaxLines,
          cursorColor: widget.inputOptions.cursorStyle.color,
          cursorWidth: widget.inputOptions.cursorStyle.width,
          showCursor: !widget.inputOptions.cursorStyle.hide,
          style: widget.inputOptions.inputTextStyle,
          autocorrect: widget.inputOptions.autocorrect,
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Container(
        padding: widget.inputOptions.inputToolbarPadding,
        margin: widget.inputOptions.inputToolbarMargin,
        decoration: widget.inputOptions.inputToolbarStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.inputOptions.leading != null)
              ...widget.inputOptions.leading!,
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: widget.controller.notifierShowInputOverlay,
                  builder: (BuildContext context, bool visible, Widget? child) {
                    return PortalTarget(
                      visible: visible &&
                          widget.inputOptions.mentionTileBuilder != null,
                      portalFollower: _portalFollower(context),
                      anchor: const Aligned(
                        follower: Alignment.bottomLeft,
                        target: Alignment.topLeft,
                        widthFactor: 1,
                        backup: Aligned(
                          follower: Alignment.bottomLeft,
                          target: Alignment.topLeft,
                          widthFactor: 1,
                        ),
                      ),
                      child: field,
                    );
                  }),
            ),
            if (widget.inputOptions.showTrailingBeforeSend) trailing,
            sendButton,
            if (!widget.inputOptions.showTrailingBeforeSend) trailing,
          ],
        ),
      ),
    );
  }

  Widget _portalFollower(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return ValueListenableBuilder(
        valueListenable: widget.controller.notifierMentionTriggerValue,
        builder: (BuildContext context, (String, String) triggerValue,
            Widget? child) {
          return StreamBuilder<List<Object>>(
              stream: widget.controller.handler.streamOnMentionTrigger
                      ?.call(triggerValue.$1, triggerValue.$2) ??
                  const Stream.empty(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
                final List<Object> list = snapshot.data ?? <Object>[];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    // elevation: style.inputFieldPortalCardElevation,
                    // color: style.inputFieldPortalBackgroundColor,
                    // shadowColor: style.inputFieldPortalShadowColor,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final Object tile = list[index];

                            return widget.inputOptions.mentionTileBuilder!.call(
                              tile,
                              widget.controller.onMentionClick,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
