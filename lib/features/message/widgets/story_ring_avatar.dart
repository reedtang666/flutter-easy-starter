import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 带故事环的头像组件
class StoryRingAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool hasStory;
  final bool isOnline;
  final VoidCallback? onTap;
  final Widget? placeholder;

  const StoryRingAvatar({
    super.key,
    this.imageUrl,
    this.size = 56,
    this.hasStory = false,
    this.isOnline = false,
    this.onTap,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 故事环
          if (hasStory)
            Container(
              width: size + 6,
              height: size + 6,
              decoration: BoxDecoration(
                gradient: const SweepGradient(
                  colors: [
                    Color(0xFFFF2D55),
                    Color(0xFFFF9500),
                    Color(0xFFFFCC00),
                    Color(0xFFAF52DE),
                    Color(0xFF007AFF),
                    Color(0xFFFF2D55),
                  ],
                ),
                borderRadius: BorderRadius.circular((size + 6) / 2),
              ),
            ),

          // 头像容器
          Container(
            width: size + (hasStory ? 6 : 0),
            height: size + (hasStory ? 6 : 0),
            padding: hasStory ? EdgeInsets.all(3.w) : EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(size / 2),
                border: hasStory
                    ? Border.all(color: AppColors.background, width: 2)
                    : null,
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? (imageUrl!.startsWith('assets/')
                        ? Image.asset(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          )
                        : Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          ))
                    : placeholder ?? _buildPlaceholder(),
              ),
            ),
          ),

          // 在线状态指示器
          if (isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(size * 0.125),
                  border: Border.all(
                    color: AppColors.background,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.tertiaryGrey,
      child: Center(
        child: Icon(
          Icons.person,
          color: AppColors.lightGrey,
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// 群聊头像（多成员叠加）
class GroupAvatar extends StatelessWidget {
  final List<String?> members;
  final double size;
  final VoidCallback? onTap;

  const GroupAvatar({
    super.key,
    required this.members,
    this.size = 56,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayMembers = members.take(4).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.2),
          child: displayMembers.length <= 2
              ? _buildTwoAvatars(displayMembers)
              : _buildFourAvatars(displayMembers),
        ),
      ),
    );
  }

  Widget _buildTwoAvatars(List<String?> members) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallAvatar(members.isNotEmpty ? members[0] : null),
        ),
        if (members.length > 1)
          Expanded(
            child: _buildSmallAvatar(members[1]),
          ),
      ],
    );
  }

  Widget _buildFourAvatars(List<String?> members) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildSmallAvatar(members.isNotEmpty ? members[0] : null),
              ),
              if (members.length > 1)
                Expanded(
                  child: _buildSmallAvatar(members[1]),
                ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              if (members.length > 2)
                Expanded(
                  child: _buildSmallAvatar(members[2]),
                ),
              if (members.length > 3)
                Expanded(
                  child: _buildSmallAvatar(members[3]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallAvatar(String? imageUrl) {
    return Container(
      margin: EdgeInsets.all(1.w),
      color: AppColors.tertiaryGrey,
      child: imageUrl != null
          ? (imageUrl.startsWith('assets/')
              ? Image.asset(imageUrl, fit: BoxFit.cover)
              : Image.network(imageUrl, fit: BoxFit.cover))
          : Icon(
              Icons.person,
              color: AppColors.lightGrey,
              size: size * 0.25,
            ),
    );
  }
}
