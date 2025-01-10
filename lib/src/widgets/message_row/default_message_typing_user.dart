part of '../../../dash_chat_2.dart';

class DefaultMessageTypingUser extends StatelessWidget {
  const DefaultMessageTypingUser({
    required this.message,
    required this.messageOptions,
    super.key,
  });

  final ChatMessage message;
  final MessageOptions messageOptions;

  @override
  Widget build(BuildContext context) {
    if (message.text.isEmpty) {
      return LoadingAnimationWidget.waveDots(
        color: messageOptions.getTextColor(context, false),
        size: 32,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message.text,
        style: TextStyle(
          color: messageOptions.getTypingTextColor(context),
        ),
      ).animate(onPlay: (AnimationController ctrl) => ctrl.repeat()).shimmer(
            duration: 1200.ms,
            color: messageOptions.getTypingTextColorShimmer(context),
          ),
    );
  }
}
