import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Performance extends StatelessWidget {
  const Performance({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, int> performanceData = {
      "Task": 185,
      "Score": 2310,
      "Avg.Time": 17,
    };

    final List<Widget> performanceItems = [];
    final divider = Container(
      width: 1,
      height: 35,
      color: theme.colorScheme.primary.withAlpha(128),
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
    for (int i = 0; i < performanceData.length; i++) {
      final key = performanceData.keys.elementAt(i);
      final value = performanceData[key];

      final content = Column(
        children: [
          Text(
            '$value',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text(key),
        ],
      );
      performanceItems.add(content);
      if (i != performanceData.length - 1) {
        performanceItems.add(divider);
      }
    }

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
