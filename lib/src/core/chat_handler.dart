import '../../dash_chat_2.dart';

class ChatHandler {
  const ChatHandler({
    this.onSend,
    this.getChatUser,
  });

  final void Function(ChatMessage message)? onSend;
  final Future<ChatUser> Function(String uid)? getChatUser;
}
