import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';

class InputArea extends ConsumerWidget {
  const InputArea({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changePasswordState = ref.watch(changePasswordNotifierProvider);
    final changePasswordNotifier = ref.read(changePasswordNotifierProvider.notifier);

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Set Password',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            changePasswordNotifier.update(password: value);
          } ,
          obscureText: !changePasswordState.isPasswordVisible,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your password',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.colorScheme.primary),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                changePasswordState.isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18,
              ),
              onPressed: () {
                changePasswordNotifier.update(isPasswordVisible: !changePasswordState.isPasswordVisible);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
            'Confirm Password',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            changePasswordNotifier.update(confirmPassword: value);
          } ,
          obscureText: !changePasswordState.isConfirmPasswordVisible,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'your password',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.colorScheme.primary),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                changePasswordState.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18,
              ),
              onPressed: () {
                changePasswordNotifier.update(isConfirmPasswordVisible: !changePasswordState.isConfirmPasswordVisible);
              },
            ),
          ),
        ),
      ],
    );
  }
}
