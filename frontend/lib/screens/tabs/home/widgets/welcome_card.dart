import 'package:flutter/material.dart';
import '../../../../themes/themes.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center, // 从中心扩散
          radius: 1, // 渐变半径（0~1）
          colors: [
            Theme.of(context).colorScheme.primary,
            // 起始颜色
            // Theme.of(context).colorScheme.inversePrimary,               // 渐变目标颜色
            AppColors.lightPurple,
          ],
          stops: [0, 1], // 对应 Figma 中的 0% 和 37%
        ),
        borderRadius: AppRadii.medium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Ben 👋",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Time to unlock some logic!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/images/ava.jpg')),
        ],
      ),
    );
  }
}
