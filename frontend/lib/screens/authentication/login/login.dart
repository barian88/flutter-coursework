import 'package:flutter/material.dart';
import 'package:frontend/widgets/widgets.dart';
import 'package:frontend/themes/themes.dart';
import 'package:gap/gap.dart';
import 'input_area.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseContainer(
      isScrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(50),
          Text(
            "Hello there 👋",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Gap(10),
          Text(
            "Enter your email and password to sign in ",
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          const Gap(50),
          InputArea(),
          const Gap(20),
          Row(
            children: [
              Spacer(),
              Text("Forgot Password ?", style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
          const Gap(40),
          FilledButton(
            onPressed: () {
              // Handle login action
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.medium,
              ),
            ),
            child: Text("SIGN IN", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
          ),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
              const Gap(5),
              InkWell(
                onTap: () {
                  // Handle navigation to sign up
                },
                child: Text(
                  "Sign Up",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
