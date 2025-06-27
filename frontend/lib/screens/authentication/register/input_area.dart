import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';

class InputArea extends ConsumerWidget {
  const InputArea({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerNotifierProvider);
    final registerNotifier = ref.read(registerNotifierProvider.notifier);

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Username',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            registerNotifier.update(username: value);
          } ,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.colorScheme.primary),
            ),
            hintText: 'your username',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
            'Email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            registerNotifier.update(email: value);
          } ,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: theme.colorScheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: theme.colorScheme.primary),
            ),
            hintText: 'your email',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
            'Set Password',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            registerNotifier.update(password: value);
          } ,
          obscureText: !registerState.isPasswordVisible,
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
                registerState.isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18,
              ),
              onPressed: () {
                registerNotifier.update(isPasswordVisible: !registerState.isPasswordVisible);
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
            registerNotifier.update(confirmPassword: value);
          } ,
          obscureText: !registerState.isConfirmPasswordVisible,
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
                registerState.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 18,
              ),
              onPressed: () {
                registerNotifier.update(isConfirmPasswordVisible: !registerState.isConfirmPasswordVisible);
                  },
            ),
          ),
        ),
      ],
    );
  }
}
