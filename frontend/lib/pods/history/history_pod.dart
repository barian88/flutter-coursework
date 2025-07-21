import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/repositories/repositories.dart';

part 'history_pod.g.dart';

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  AsyncValue<List<Quiz>> build() {
    return const AsyncValue.data([]);
  }

  // 获取所有测验历史记录
  Future<void> loadAllHistory() async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(quizRepositoryProvider);
      
      try {
        final historyList = await repository.getAllQuizHistory();
        state = AsyncValue.data(historyList);
      } catch (e) {
        // 如果API失败，使用本地模拟数据
        final mockHistory = [
          repository.getMockReviewQuiz(),
          repository.getMockReviewQuiz().copyWith(
            id: 'mock_2',
            correctQuestionsNum: 1,
            completionTime: 800,
          ),
          repository.getMockReviewQuiz().copyWith(
            id: 'mock_3',
            correctQuestionsNum: 3,
            completionTime: 1500,
          ),
        ];
        state = AsyncValue.data(mockHistory);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 刷新历史记录
  Future<void> refreshHistory() async {
    await loadAllHistory();
  }
}