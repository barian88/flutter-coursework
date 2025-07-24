import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../apis/apis.dart';

part 'quiz_repository.g.dart';

@riverpod
QuizRepository quizRepository(Ref ref) {
  return QuizRepositoryImpl(ref.read(quizApiProvider));
}

abstract class QuizRepository {
  
  // 创建新的测验（用于开始新测验）
  Future<Quiz> createNewQuiz({
    required String type,
    String? category,
    String? difficulty,
  });

  // 提交测验
  Future<Quiz> submitQuiz(SubmitQuizRequest request);

  // 获取所有测验历史记录（用于history页面）
  Future<List<Quiz>> getAllQuizHistory();

  // 获取单个测验（用于回顾）
  Future<Quiz> getQuiz(String id);

  // 本地数据方法（用于无网络）
  Quiz getLocalQuiz();
  Quiz getMockReviewQuiz();
}

class QuizRepositoryImpl implements QuizRepository {
  final QuizApi _quizApi;

  QuizRepositoryImpl(this._quizApi);


  
  @override
  Future<Quiz> createNewQuiz({
    required String type,
    String? category,
    String? difficulty,
  }) async {
    try {
      final quiz = await _quizApi.createNewQuiz(
        type: type,
        category: category,
        difficulty: difficulty,
      );
      return quiz;
    }catch(e){
      final quiz = getLocalQuiz();
      return quiz;
    }
  }

  @override
  Future<Quiz> submitQuiz(SubmitQuizRequest request) async {
    return _quizApi.submitQuiz(request);
  }

  @override
  Future<List<Quiz>> getAllQuizHistory() async {
    return _quizApi.getAllQuizHistory();
  }

  @override
  Future<Quiz> getQuiz(String id) async {
    return _quizApi.getQuiz(id);
  }


  // 本地模拟数据方法
  @override
  Quiz getLocalQuiz() {
    return Quiz(
      id: 'mock_quiz_1',
      type: QuizType.randomTasks,
      questions: [
        QuizQuestion(
          question: Question(
            id: 'q1',
            questionText: "Which of the following formulas is logically equivalent to ¬(p ∨ q)?",
            options: ["¬p ∧ ¬q", "¬p ∨ ¬q", "p ∧ q", "p ∨ q"],
            correctAnswerIndex: [0],
            type: QuestionType.singleChoice,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.easy,
          ),
          userAnswerIndex: [],
        ),
        QuizQuestion(
          question: Question(
            id: 'q2',
            questionText: "What is the contrapositive of the implication p → q?",
            options: ["¬q → ¬p", "¬p → ¬q", "p ∨ q", "¬p ∨ q"],
            correctAnswerIndex: [0],
            type: QuestionType.multipleChoice,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.medium,
          ),
          userAnswerIndex: [],
        ),
        QuizQuestion(
          question: Question(
            id: 'q3',
            questionText: "Is the statement 'p → q' equivalent to '¬p ∨ q'?",
            options: ["True", "False"],
            correctAnswerIndex: [0],
            type: QuestionType.trueFalse,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.medium,
          ),
          userAnswerIndex: [],
        ),
      ],
    );
  }

  @override
  Quiz getMockReviewQuiz() {
    return Quiz(
      id: 'mock_review_quiz_1',
      type: QuizType.randomTasks,
      correctQuestionsNum: 2,
      completionTime: 1200,
      questions: [
        QuizQuestion(
          question: Question(
            id: 'q1',
            questionText: "Which of the following formulas is logically equivalent to ¬(p ∨ q)?",
            options: ["¬p ∧ ¬q", "¬p ∨ ¬q", "p ∧ q", "p ∨ q"],
            correctAnswerIndex: [0],
            type: QuestionType.singleChoice,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.easy,
          ),
          userAnswerIndex: [0],
        ),
        QuizQuestion(
          question: Question(
            id: 'q2',
            questionText: "What is the contrapositive of the implication p → q?",
            options: ["¬q → ¬p", "¬p → ¬q", "p ∨ q", "¬p ∨ q"],
            correctAnswerIndex: [0],
            type: QuestionType.multipleChoice,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.medium,
          ),
          userAnswerIndex: [0, 1, 2],
        ),
        QuizQuestion(
          question: Question(
            id: 'q3',
            questionText: "Is the statement 'p → q' equivalent to '¬p ∨ q'?",
            options: ["True", "False"],
            correctAnswerIndex: [0],
            type: QuestionType.trueFalse,
            category: QuestionCategory.equivalence,
            difficulty: QuestionDifficulty.medium,
          ),
          userAnswerIndex: [1],
        ),
      ],
    );
  }
}