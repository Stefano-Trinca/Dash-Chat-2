part of '../../../dash_chat_2.dart';

class DefaultSendButton extends StatelessWidget {
  const DefaultSendButton(
      {super.key, this.onSend, this.icon = Icons.send, this.style});

  final VoidCallback? onSend;
  final IconData icon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: style,
      onPressed: onSend,
      icon: Icon(icon),
    );
  }
}
