/// 消息类型枚举
enum MessageType {
  text,
  image,
  voice,
  video,
  location,
  gift,
}

/// 消息状态枚举
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// 聊天消息模型 - 增强版
class ChatMessage {
  final String id;
  final String senderId;
  final String? text;
  final DateTime time;
  final bool isMe;
  final MessageType type;
  final MessageStatus status;
  final String? mediaUrl;
  final int? voiceDuration; // 语音时长（秒）
  final Map<String, List<String>>? reactions; // 表情反应 {emoji: [userId1, userId2]}
  final String? replyToId; // 回复的消息ID
  final String? locationName; // 位置名称

  ChatMessage({
    required this.id,
    required this.senderId,
    this.text,
    required this.time,
    required this.isMe,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.mediaUrl,
    this.voiceDuration,
    this.reactions,
    this.replyToId,
    this.locationName,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? time,
    bool? isMe,
    MessageType? type,
    MessageStatus? status,
    String? mediaUrl,
    int? voiceDuration,
    Map<String, List<String>>? reactions,
    String? replyToId,
    String? locationName,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      status: status ?? this.status,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      reactions: reactions ?? this.reactions,
      replyToId: replyToId ?? this.replyToId,
      locationName: locationName ?? this.locationName,
    );
  }
}

/// 消息反应表情列表
final List<String> messageReactions = ['❤️', '😂', '👍', '😮', '😢', '🎉'];
