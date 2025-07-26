import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/themes/themes.dart';
import 'package:frontend/pods/pods.dart';
import 'package:gap/gap.dart';

class UserInfoCard extends ConsumerWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);
    final user = userState.value?.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final textColor = Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppGradients.cardPurpleGradient(theme),
            borderRadius: AppRadii.medium,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 35, 16, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Username', style: TextStyle(color: textColor)),
                    Spacer(),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Gap(5),
                    Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    Text('Email', style: TextStyle(color: textColor)),
                    Spacer(),
                    Text(user.email, style: TextStyle(color: textColor)),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    Text('Change Password', style: TextStyle(color: textColor)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: const Offset(0, -35),
            child: CircleAvatar(
              radius: 37,
              backgroundColor: AppColors.grey1,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(user.profilePictureUrl),
                onBackgroundImageError: (error, stackTrace) {
                  // 处理图片加载失败
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
