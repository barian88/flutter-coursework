import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import 'widgets/widgets.dart';
import 'models/models.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = [
      HistoryItem(type: "Random Tasks", correct: 8, time: "4m12s"),
      HistoryItem(type: "Topic Practice", correct: 8, time: "4m12s"),
      HistoryItem(type: "By Difficulty", correct: 8, time: "4m12s"),
      HistoryItem(type: "Custom Quiz", correct: 8, time: "4m12s"),
      HistoryItem(type: "Custom Quiz", correct: 8, time: "4m12s"),
      HistoryItem(type: "Random Tasks", correct: 8, time: "4m12s"),
      HistoryItem(type: "Topic Practice", correct: 8, time: "4m12s"),
      HistoryItem(type: "By Difficulty", correct: 8, time: "4m12s"),

    ];
    final cardList = List.generate(historyList.length, (index) {
      final item = historyList[index];
      return Column(children: [HistoryCard(historyItem: item, index: index,), Gap(30)]);
    });

    return BaseContainer(child: Column(children: cardList));
  }
}
