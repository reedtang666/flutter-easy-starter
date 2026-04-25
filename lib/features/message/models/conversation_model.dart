import 'package:flutter/material.dart';

/// 会话类型枚举
enum ConversationType {
  single, // 单聊
  group, // 群聊
  system, // 系统通知
}

/// 聊天会话模型 - 增强版
class ChatConversation {
  final String id;
  final String name;
  final String? avatar;
  final String? lastMessage;
  final DateTime? lastTime;
  final int unreadCount;
  final bool isOnline;
  final bool hasStory; // 是否有故事/状态
  final ConversationType type;
  final bool isTyping; // 是否正在输入
  final List<String>? members; // 群聊成员头像列表
  final String? lastMessageSender; // 最后消息发送者（群聊用）

  ChatConversation({
    required this.id,
    required this.name,
    this.avatar,
    this.lastMessage,
    this.lastTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.hasStory = false,
    this.type = ConversationType.single,
    this.isTyping = false,
    this.members,
    this.lastMessageSender,
  });

  ChatConversation copyWith({
    String? id,
    String? name,
    String? avatar,
    String? lastMessage,
    DateTime? lastTime,
    int? unreadCount,
    bool? isOnline,
    bool? hasStory,
    ConversationType? type,
    bool? isTyping,
    List<String>? members,
    String? lastMessageSender,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      hasStory: hasStory ?? this.hasStory,
      type: type ?? this.type,
      isTyping: isTyping ?? this.isTyping,
      members: members ?? this.members,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
    );
  }
}

/// 示例数据 - 增强版
final List<ChatConversation> mockConversations = [
  ChatConversation(
    id: '1',
    name: '小雨',
    avatar: 'assets/images/profiles/profile_0.png',
    lastMessage: '周末有空一起去喝咖啡吗？',
    lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
    isOnline: true,
    hasStory: true,
  ),
  ChatConversation(
    id: '2',
    name: 'Alex',
    avatar: 'assets/images/profiles/profile_1.png',
    lastMessage: '我也很喜欢健身，什么时候一起训练？',
    lastTime: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
    isOnline: true,
    hasStory: true,
  ),
  ChatConversation(
    id: '3',
    name: '梦琪',
    avatar: 'assets/images/profiles/profile_2.png',
    lastMessage: '谢谢你的喜欢 💕',
    lastTime: DateTime.now().subtract(const Duration(hours: 3)),
    unreadCount: 1,
    isOnline: false,
    hasStory: false,
    isTyping: true,
  ),
  ChatConversation(
    id: '4',
    name: '旅行爱好者群',
    lastMessage: '下次一起去西藏吧！',
    lastTime: DateTime.now().subtract(const Duration(hours: 5)),
    unreadCount: 5,
    isOnline: false,
    hasStory: false,
    type: ConversationType.group,
    members: ['assets/images/profiles/profile_3.png', 'assets/images/profiles/profile_4.png', 'assets/images/profiles/profile_5.png', 'assets/images/profiles/profile_6.png'],
    lastMessageSender: '小明',
  ),
  ChatConversation(
    id: '5',
    name: '系统通知',
    lastMessage: '你的实名认证已通过审核',
    lastTime: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 0,
    isOnline: false,
    hasStory: false,
    type: ConversationType.system,
  ),
  ChatConversation(
    id: '6',
    name: 'Lisa',
    avatar: 'assets/images/profiles/profile_7.png',
    lastMessage: '哈哈，好的',
    lastTime: DateTime.now().subtract(const Duration(days: 2)),
    unreadCount: 0,
    isOnline: true,
    hasStory: false,
  ),
  ChatConversation(
    id: '7',
    name: '摄影师联盟',
    lastMessage: '这周末有外拍活动',
    lastTime: DateTime.now().subtract(const Duration(days: 3)),
    unreadCount: 12,
    isOnline: false,
    hasStory: false,
    type: ConversationType.group,
    members: ['assets/images/profiles/profile_8.png', 'assets/images/profiles/profile_9.png', 'assets/images/profiles/profile_10.png'],
    lastMessageSender: '摄影师老王',
  ),
];

/// 消息提供者状态
class MessageState {
  final List<ChatConversation> conversations;
  final String searchQuery;
  final bool isLoading;

  MessageState({
    this.conversations = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  MessageState copyWith({
    List<ChatConversation>? conversations,
    String? searchQuery,
    bool? isLoading,
  }) {
    return MessageState(
      conversations: conversations ?? this.conversations,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// 过滤后的会话列表
  List<ChatConversation> get filteredConversations {
    if (searchQuery.isEmpty) return conversations;
    return conversations
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
