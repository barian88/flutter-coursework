import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../screens/screens.dart';

part 'route_pod.g.dart';


@riverpod
class RouteNotifier extends _$RouteNotifier {

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
  GlobalKey<NavigatorState>();

  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return TabScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => NoTransitionPage(child: const Home()),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: '/quiz',
                  builder: (context, state) {
                    return const Quiz();
                  },
                ),
              ]
            ),
            GoRoute(
              path: '/history',
              pageBuilder: (context, state) => NoTransitionPage(child: const History()),
            ),
            GoRoute(
              path: '/guide',
              pageBuilder: (context, state) => NoTransitionPage(child: const Guide()),
            ),
            GoRoute(
              path: '/user',
              pageBuilder: (context, state) => NoTransitionPage(child: const User()),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return AuthenticationScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/login',
              builder: (context, state) => const Login(),
            ),
            GoRoute(
              path: '/register',
              builder: (context, state) => const Text('Register'),
            ),
            GoRoute(
              path: '/verification',
              builder: (context, state) => const Text('Verification'),
            ),
          ],
        ),
      ],
    );
  }

  CustomTransitionPage _buildSlidePage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}