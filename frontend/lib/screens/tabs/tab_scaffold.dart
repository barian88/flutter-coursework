import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';

class TabScaffold extends StatelessWidget {
  final Widget child;
  const TabScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final title;
    final location = GoRouterState.of(context).uri.toString();
    if(location == '/user'){
      title = Text('data');
    } else {
      title = const Logo();
  }

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [ThemeModeSwitch(), const Gap(16)],
      ),
      bottomNavigationBar: BottomNavBar(),
      body: child,
    );
  }
}
