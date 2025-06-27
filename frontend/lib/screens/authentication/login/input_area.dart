import 'package:flutter/material.dart';

class InputArea extends StatefulWidget {
  const InputArea({super.key});

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {

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
          obscureText: _passwordVisible,
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
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });              },
            ),
          ),
        ),
      ],
    );
  }
}
