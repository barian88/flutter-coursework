import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../screens/screens.dart';
import '../user/user_pod.dart';

part 'route_pod.g.dart';

@riverpod
class RouteNotifier extends _$RouteNotifier {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  GoRouter build() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return TabScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder:
                  (context, state) => NoTransitionPage(child: const Home()),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: '/new-quiz',
                  builder: (context, state) {
                    return const NewQuiz();
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/history',
              pageBuilder:
                  (context, state) => NoTransitionPage(child: const History()),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: '/quiz-review/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return QuizReview(quizId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/guide',
              pageBuilder:
                  (context, state) => NoTransitionPage(child: const Guide()),
            ),
            GoRoute(
              path: '/user',
              pageBuilder:
                  (context, state) => NoTransitionPage(child: const User()),
            ),
          ],
        ),

        // Authentication Routes
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => MaterialPage(child: const Login()),
        ),
        GoRoute(
          path: '/register',
          pageBuilder:
              (context, state) => MaterialPage(child: const Register()),
        ),
        GoRoute(
          path: '/verification/:parentPage/:email',
          pageBuilder:
              (context, state) {
                final parentPage = state.pathParameters['parentPage'] ?? '';
                final email = state.pathParameters['email'] ?? '';
                return MaterialPage(child: Verification(email: email, parentPage: parentPage));
              },
        ),
        GoRoute(
          path: '/change-password/:temporaryToken',
          pageBuilder:
              (context, state) {
                final temporaryToken = state.pathParameters['temporaryToken'] ?? '';
                return MaterialPage(child: ChangePassword(temporaryToken: temporaryToken));
              },
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
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
