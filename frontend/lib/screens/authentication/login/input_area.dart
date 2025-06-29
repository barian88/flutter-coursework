import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pods/pods.dart';

class InputArea extends ConsumerWidget {
  const InputArea({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginState = ref.watch(loginNotifierProvider);
    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    final _passwordVisible = loginState.isPasswordVisible;

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            loginNotifier.update(email: value);
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
          'Password',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged:  (value){
            loginNotifier.update(password:  value);
          } ,
          obscureText: !_passwordVisible,
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
              _passwordVisible ? Icons.visibility : Icons.visibility_off, size: 18,
    ),
              onPressed: () {
                loginNotifier.update(isPasswordVisible: !_passwordVisible);
              }
            ),
          ),
        ),
      ],
    );
  }
}
