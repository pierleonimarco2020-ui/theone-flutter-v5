import 'package:uuid/uuid.dart';

enum MessageStatus { pending, sent, delivered, read }

enum MediaType { image, video, audio }

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;
  final String? mediaUrl;
  final MediaType? mediaType;

  Message({
    String? id,
    required this.senderId,
    required this.senderName,
    required this.content,
    DateTime? timestamp,
    this.status = MessageStatus.pending,
    this.mediaUrl,
    this.mediaType,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  // Copy with
  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
    String? mediaUrl,
    MediaType? mediaType,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType?.name,
    };
  }

  // From JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.byName(json['status'] as String),
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] != null
          ? MediaType.values.byName(json['mediaType'] as String)
          : null,
    );
  }

  @override
  String toString() =>
      'Message(id: $id, senderId: $senderId, content: $content, status: $status)';
}
