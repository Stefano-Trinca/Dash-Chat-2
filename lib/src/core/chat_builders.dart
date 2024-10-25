import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatBuilders {
  const ChatBuilders({
    this.emptyBuilder,
    this.dateSeparatorBuilder,
    this.showDateSeparator = true,
    this.separatorFrequency = SeparatorFrequency.days,
  });

  /// If you want to create you own separator widget
  /// You can use DefaultDateSeparator to only override some variables
  final Widget Function(DateTime date)? dateSeparatorBuilder;

  final bool showDateSeparator;

  final SeparatorFrequency separatorFrequency;

  /// If no message in the list source
  final Widget Function(BuildContext context)? emptyBuilder;
}
