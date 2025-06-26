import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/themes/themes.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: () {},
      icon: Icon(
        Icons.logout,
        color: theme.colorScheme.red,
      ),
      label: Text(
        'Logout',
        style: TextStyle(
          color: theme.colorScheme.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
