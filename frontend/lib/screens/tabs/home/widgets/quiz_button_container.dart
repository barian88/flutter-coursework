import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../pods/pods.dart';
import '../../../../themes/themes.dart';

class QuizButtonContainer extends ConsumerWidget {
  final String? title;
  final String? emoji;
  final int? index;

  const QuizButtonContainer({
    super.key,
    required this.title,
    required this.emoji,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    final purpleGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.6,
      colors: [Theme.of(context).colorScheme.primary, AppColors.lightPurple],
    );

    final yellowGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.5,
      colors: [Theme.of(context).colorScheme.secondary, AppColors.lightYellow],
    );

    return Material(
      elevation: 1,
      surfaceTintColor:
          themeMode == ThemeMode.dark
              ? Theme.of(context).colorScheme.surfaceTint
              : Theme.of(context).colorScheme.surface,
      borderRadius: AppRadii.medium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: (){},
        child: Column(
          children: [
            Ink(
              height: 100,
              width: 140,
              decoration: BoxDecoration(
                gradient: index! % 2 == 0 ? purpleGradient : yellowGradient,
              ),
              child: Center(
                child: Text(emoji ?? '', style: TextStyle(fontSize: 46)),
              ),
            ),
            SizedBox(height: 40, child: Center(child: Text(title ?? ''))),
          ],
        ),
      ),
    );
  }
}
