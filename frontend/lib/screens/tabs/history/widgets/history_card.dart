import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../themes/themes.dart';
import '../models/models.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.historyItem,
    required this.index,
  });

  final HistoryItem historyItem;
  final int index;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final purpleGradient = AppGradients.historyCardPurpleGradient(theme);
    final yellowGradient = AppGradients.historyCardYellowGradient(theme);

    final cardBorderColor =
        index % 2 == 0
            ? theme.colorScheme.primary.withAlpha(128)
            : theme.colorScheme.secondary.withAlpha(128);
    final iconColor =
        index % 2 == 0
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSecondary;
    final backgroundGradient = index % 2 == 0 ? purpleGradient : yellowGradient;

    final FaIcon icon =
        (() {
          switch (historyItem.type) {
            case "Random Tasks":
              return FaIcon(
                FontAwesomeIcons.diceThree,
                size: 80,
                color: iconColor,
              );
            case "Topic Practice":
              return FaIcon(
                FontAwesomeIcons.bullseye,
                size: 78,
                color: iconColor,
              );
            case "By Difficulty":
              return FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 65,
                color: iconColor,
              );
            case "Custom Quiz":
              return FaIcon(
                FontAwesomeIcons.pencil,
                size: 68,
                color: iconColor,
              );
            default:
              return FaIcon(
                FontAwesomeIcons.diceThree,
                size: 80,
                color: iconColor,
              );
          }
        })();

    return GestureDetector(
      onTap: () {
        context.go('/history/quiz-review/${historyItem.id}');
      },
      child: Container(
        width: double.infinity,
        height: 120,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: cardBorderColor),
          borderRadius: AppRadii.medium,
        ),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                gradient: backgroundGradient,
                borderRadius: AppRadii.medium,
              ),
              child: Center(child: icon),
            ),
            Gap(35),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    historyItem.type,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${historyItem.correct}/10 Correct',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Gap(5),
                      Text('·'),
                      Gap(5),
                      Text(
                        historyItem.time,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
