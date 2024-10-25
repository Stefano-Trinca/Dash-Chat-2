import '../../dash_chat_2.dart';

class ChatHandler {
  const ChatHandler({
    this.onSend,
    this.getChatUser,
    this.streamOnMentionTrigger,
  });

  final void Function(ChatMessage message)? onSend;
  final Future<ChatUser> Function(String uid)? getChatUser;
  final Stream<List<Object>> Function(String trigger, String value)?
      streamOnMentionTrigger;
}
