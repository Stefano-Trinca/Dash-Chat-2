part of '../../../dash_chat_2.dart';

// /// {@category Default widgets}
// Widget Function(Function send) defaultSendButton({
//   required Color color,
//   IconData icon = Icons.send,
//   EdgeInsets? padding,
//   bool disabled = false,
// }) =>
//     (Function fct) => InkWell(
//           onTap: disabled ? null : () => fct(),
//           child: Padding(
//             padding: padding ??
//                 const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//             child: Icon(
//               icon,
//               color: color,
//             ),
//           ),
//         );

class DefaultSendButton extends StatelessWidget {
  const DefaultSendButton(
      {super.key, required this.onSend, this.icon = Icons.send, this.style});

  final VoidCallback onSend;
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
