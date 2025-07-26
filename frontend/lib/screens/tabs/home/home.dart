import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';
import 'package:frontend/pods/pods.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final userNotifier = ref.read(userNotifierProvider.notifier);
    
    try {
      // 先加载用户数据
      await userNotifier.loadUserFromStorage();
      
      // 检查用户是否已登录
      final userState = ref.read(userNotifierProvider);
      if (userState.value != null && !userState.value!.isLoggedIn) {
        // 用户未登录，跳转到登录页面
        if (mounted) {
          context.go('/login');
          return;
        }
      }
      
      // 用户已登录，加载统计数据
      await userNotifier.loadUserStats();
    } catch (error) {
      // 错误处理已经在 Provider 中完成
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    
    return BaseContainer(
      child: userState.when(
        data: (userData) => Column(
          children: [
            WelcomeCard(),
            Gap(26),
            QuizButtons(),
            Gap(26),
            Performance(),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              Gap(16),
              Text(
                'Failed to load user data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Gap(8),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              Gap(16),
              ElevatedButton(
                onPressed: () {
                  _initializeUserData();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




