/// 用户数据模型
class UserModel {
  final String id;
  final String username;
  final String? nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final int? gender; // 0: 未知, 1: 男, 2: 女
  final String? birthday;
  final String? bio;
  final bool isVip;
  final DateTime? vipExpireTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.gender,
    this.birthday,
    this.bio,
    this.isVip = false,
    this.vipExpireTime,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['userId'] ?? '',
      username: json['username'] ?? json['userName'] ?? '',
      nickname: json['nickname'] ?? json['nickName'],
      avatar: json['avatar'] ?? json['avatarUrl'],
      phone: json['phone'] ?? json['mobile'],
      email: json['email'],
      gender: json['gender'] ?? json['sex'],
      birthday: json['birthday'],
      bio: json['bio'] ?? json['signature'],
      isVip: json['isVip'] == true || json['vip'] == true,
      vipExpireTime: json['vipExpireTime'] != null
          ? DateTime.parse(json['vipExpireTime'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'bio': bio,
      'isVip': isVip,
      'vipExpireTime': vipExpireTime?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 获取显示名称（优先使用昵称）
  String get displayName => nickname?.isNotEmpty == true ? nickname! : username;

  /// 获取头像（使用默认头像占位）
  String get avatarUrl => avatar ?? '';

  UserModel copyWith({
    String? id,
    String? username,
    String? nickname,
    String? avatar,
    String? phone,
    String? email,
    int? gender,
    String? birthday,
    String? bio,
    bool? isVip,
    DateTime? vipExpireTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      bio: bio ?? this.bio,
      isVip: isVip ?? this.isVip,
      vipExpireTime: vipExpireTime ?? this.vipExpireTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
