import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/widgets/widgets.dart';

class AuthenticationScaffold extends StatelessWidget {
  const AuthenticationScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {

    final location = GoRouterState.of(context).uri.toString();
    final Widget? title;

    if (location == '/login') {
      title = const Logo();
    } else {
      title = null;
    }


    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: child,
    );
  }
}
