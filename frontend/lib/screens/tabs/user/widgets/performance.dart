import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:frontend/pods/pods.dart';

class Performance extends ConsumerWidget {
  const Performance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userState = ref.watch(userNotifierProvider);
    final performance = userState.value?.userStats?.performance;
    if (performance == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    final divider = Container(
      width: 1,
      height: 35,
      color: theme.colorScheme.primary.withAlpha(128),
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );

    final performanceItems = [
      Column(
        children: [
          Text(
            '${performance.taskNum}',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text('Tasks'),
        ],
      ),
      divider,
      Column(
        children: [
          Text(
            '${performance.score}',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text('Score'),
        ],
      ),
      divider,
      Column(
        children: [
          Text(
            '${performance.avgTime.toStringAsFixed(1)}s',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text('Avg. Time'),
        ],
      ),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(15),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: performanceItems,
              ),
            );
          },
        ),
      ],
    );
  }
}
