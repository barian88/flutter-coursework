import 'package:flutter/material.dart';
import '../../../../themes/themes.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final purpleGradient = AppGradients.cardPurpleGradient(theme);

    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: purpleGradient,
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
