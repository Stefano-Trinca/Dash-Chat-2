part of '../../../dash_chat_2.dart';

class DefaultMessageTypingUser extends StatelessWidget {
  const DefaultMessageTypingUser({
    super.key,
    required this.message,
    required this.messageOptions,
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
    final Color textColor = messageOptions.getTextColor(context, false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message.text,
        style: TextStyle(
          color: textColor.withOpacity(0.4),
        ),
      ).animate(onPlay: (AnimationController ctrl) => ctrl.repeat()).shimmer(
          duration: 1200.ms,
          color: messageOptions
              .getContainerColor(context, false)
              .withOpacity(0.8)),
    );
  }
}
