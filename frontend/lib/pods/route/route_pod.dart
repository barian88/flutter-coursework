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
      initialLocation: '/home',
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return TabScaffold(child: child);
          },
          routes: [
            GoRoute(path: '/home', builder: (context, state) => Home()),
            GoRoute(
              path: '/history',
              builder: (context, state) => Center(child: Text("History"),),
            ),
            GoRoute(path: '/guide', builder: (context, state) => Center(child: Text("Guide"),)),
            GoRoute(path: '/user', builder: (context, state) => Center(child: Text("User"),)),

          ],
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/login',
          builder: (context, state) {
            //
            // final combination = state.pathParameters['combinationIndex'] ?? '';
            // final parts = combination.split(',').map(int.parse).toList();
            // return CombinationDetail(combinationIndex: parts);
            return Center(child: Text("Login"));
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/register',
          builder: (context, state) {
            return Center(child: Text("Register"));
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/verification',
          builder: (context, state) {
            return Center(child: Text("Verification"));
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/quiz',
          builder: (context, state) {
            return Center(child: Text("Quiz"));
          },
        ),
      ],
    );
  }

}