part of '../../../dash_chat_2.dart';

class DefaultListEmptyBuilder extends StatelessWidget {
  const DefaultListEmptyBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Messages',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
      ),
    );
  }
}
