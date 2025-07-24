import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../widgets/widgets.dart';
import '../../../pods/history/history_pod.dart';
import 'widgets/widgets.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(historyNotifierProvider.notifier).loadAllHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyNotifierProvider);

    return BaseContainer(
      child: historyState.when(
        data: (quizzes) {
          if (quizzes.isEmpty) {
            return const Center(
              child: Text('No quiz history available'),
            );
          }
          
          final cardList = List.generate(quizzes.length, (index) {
            final quiz = quizzes[index];
            return Column(
              children: [
                HistoryCard(quizItem: quiz, index: index),
                const Gap(30),
              ],
            );
          });

          return Column(children: cardList);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
