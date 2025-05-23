part of '../../dash_chat_2.dart';

/// {@category Models}
class ChatMessage {
  ChatMessage({
    this.id = '',
    required this.user,
    required this.createdAt,
    this.type = MessageType.user,
    this.isMarkdown = false,
    this.text = '',
    this.medias,
    this.quickReplies,
    this.customProperties,
    this.mentions,
    this.status = MessageStatus.none,
    this.replyTo,
  });

  /// Create a ChatMessage instance from json data
  factory ChatMessage.fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage(
      id: jsonData['id']?.toString() ?? '',
      user: jsonData['user']?.toString() ?? '',
      createdAt: DateTime.parse(jsonData['createdAt'].toString()).toLocal(),
      text: jsonData['text']?.toString() ?? '',
      type: MessageType.parse(jsonData['type']?.toString() ?? 'user'),
      isMarkdown: jsonData['isMarkdown']?.toString() == 'true',
      medias: jsonData['medias'] != null
          ? (jsonData['medias'] as List<dynamic>)
              .map((dynamic media) =>
                  ChatMedia.fromJson(media as Map<String, dynamic>))
              .toList()
          : <ChatMedia>[],
      quickReplies: jsonData['quickReplies'] != null
          ? (jsonData['quickReplies'] as List<dynamic>)
              .map((dynamic quickReply) =>
                  QuickReply.fromJson(quickReply as Map<String, dynamic>))
              .toList()
          : <QuickReply>[],
      customProperties: jsonData['customProperties'] as Map<String, dynamic>?,
      mentions: jsonData['mentions'] != null
          ? (jsonData['mentions'] as List<dynamic>)
              .map((dynamic mention) =>
                  Mention.fromJson(mention as Map<String, dynamic>))
              .toList()
          : <Mention>[],
      status: MessageStatus.parse(jsonData['status'].toString()),
      replyTo: jsonData['replyTo'] != null
          ? ChatMessage.fromJson(jsonData['replyTo'] as Map<String, dynamic>)
          : null,
    );
  }

  /// the id of the message
  String id;

  /// Determinate the type of the message, if is a user message or a systema message, default is user
  MessageType type;

  /// If the message is Markdown formatted then it will be converted to Markdown (by default it will be false)
  bool isMarkdown;

  /// Text of the message (optional because you can also just send a media)
  String text;

  /// Author of the message
  String user;

  /// List of medias of the message
  List<ChatMedia>? medias;

  /// A list of quick replies that users can use to reply to this message
  List<QuickReply>? quickReplies;

  /// A list of custom properties to extend the existing ones
  /// in case you need to store more things.
  /// Can be useful to extend existing features
  Map<String, dynamic>? customProperties;

  /// Date of the message
  DateTime createdAt;

  /// Mentioned elements in the message
  List<Mention>? mentions;

  /// Status of the message TODO:
  MessageStatus? status;

  /// If the message is a reply of another one TODO:
  ChatMessage? replyTo;

  /// Convert a ChatMessage into a json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'text': text,
      'medias': medias?.map((ChatMedia media) => media.toJson()).toList(),
      'quickReplies': quickReplies
          ?.map((QuickReply quickReply) => quickReply.toJson())
          .toList(),
      'customProperties': customProperties,
      'mentions': mentions,
      'status': status.toString(),
      'replyTo': replyTo?.toJson(),
      'isMarkdown': isMarkdown,
      'type': type.toString(),
    };
  }
}

class MessageStatus {
  const MessageStatus._internal(this._value);
  final String _value;

  @override
  String toString() => _value;

  static MessageStatus parse(String value) {
    switch (value) {
      case 'none':
        return MessageStatus.none;
      case 'failed':
        return MessageStatus.failed;
      case 'sent':
        return MessageStatus.sent;
      case 'read':
        return MessageStatus.read;
      case 'received':
        return MessageStatus.received;
      case 'pending':
        return MessageStatus.pending;
      case 'streaming':
        return MessageStatus.streaming;
      default:
        return MessageStatus.none;
    }
  }

  static const MessageStatus none = MessageStatus._internal('none');
  static const MessageStatus failed = MessageStatus._internal('failed');
  static const MessageStatus sent = MessageStatus._internal('sent');
  static const MessageStatus read = MessageStatus._internal('read');
  static const MessageStatus received = MessageStatus._internal('received');
  static const MessageStatus pending = MessageStatus._internal('pending');
  static const MessageStatus streaming = MessageStatus._internal('streaming');

  bool get isNone => this == MessageStatus.none;
  bool get isFailed => this == MessageStatus.failed;
  bool get isSent => this == MessageStatus.sent;
  bool get isRead => this == MessageStatus.read;
  bool get isReceived => this == MessageStatus.received;
  bool get isPending => this == MessageStatus.pending;
  bool get isStreaming => this == MessageStatus.streaming;
}

enum MessageType {
  user,
  typing,
  system;

  @override
  String toString() => switch (this) {
        MessageType.user => 'user',
        MessageType.typing => 'typing',
        MessageType.system => 'system',
      };

  static MessageType parse(String value) => switch (value) {
        'user' => MessageType.user,
        'typing' => MessageType.typing,
        'system' => MessageType.system,
        _ => MessageType.user,
      };
}
