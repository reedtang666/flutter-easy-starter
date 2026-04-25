import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/theme/app_colors.dart';

class ListingHeaderWidget extends StatelessWidget {
  const ListingHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55),
            ),
            child: const Icon(
              Icons.menu_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 30,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(55),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: Image.asset(
                'assets/images/travel/profile/profile_4.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
