import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../pods/pods.dart';
import '../../../../themes/themes.dart';

class QuizButtonContainer extends ConsumerWidget {
  final String title;
  final String emoji;
  final int index;

  const QuizButtonContainer({
    super.key,
    required this.title,
    required this.emoji,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final gradient =
        index % 2 == 0
            ? AppGradients.buttonPurpleGradient(theme)
            : AppGradients.buttonYellowGradient(theme);

    return Material(
      elevation: 1,
      surfaceTintColor:
          theme.brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surfaceTint
              : Theme.of(context).colorScheme.surface,
      borderRadius: AppRadii.medium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          switch (index) {
            case 0:
              context.push('/home/quiz');
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
        child: Column(
          children: [
            Ink(
              height: 100,
              width: 140,
              decoration: BoxDecoration(gradient: gradient),
              child: Center(child: Text(emoji, style: TextStyle(fontSize: 46))),
            ),
            SizedBox(height: 40, child: Center(child: Text(title))),
          ],
        ),
      ),
    );
  }
}
