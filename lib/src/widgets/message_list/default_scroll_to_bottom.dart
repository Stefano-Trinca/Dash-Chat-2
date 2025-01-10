part of '../../../dash_chat_2.dart';

class DeafultScrollToBottom extends StatelessWidget {
  const DeafultScrollToBottom({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_downward,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.surface,
          foregroundColor:
              foregroundColor ?? Theme.of(context).colorScheme.onSurface,
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.onSurface.withAlpha(64)),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
