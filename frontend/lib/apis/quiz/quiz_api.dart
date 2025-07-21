import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../api_service.dart';

part 'quiz_api.g.dart';

@riverpod
QuizApi quizApi(Ref ref) {
  return QuizApi(ref.read(apiServiceProvider));
}

class QuizApi {
  final ApiService _apiService;

  QuizApi(this._apiService);

  // 获取单个测验（用于回顾）
  Future<Quiz> getQuiz(String id) async {
    final response = await _apiService.get('/quizzes/$id');
    return Quiz.fromJson(response['data']);
  }

  // 创建新的测验（用于开始新测验）
  Future<Quiz> createNewQuiz({
    String? category,
    String? difficulty,
    int? questionCount,
  }) async {
    final body = <String, dynamic>{};
    
    if (category != null) body['category'] = category;
    if (difficulty != null) body['difficulty'] = difficulty;
    if (questionCount != null) body['questionCount'] = questionCount;
    
    final response = await _apiService.post('/quizzes/new', body: body);
    return Quiz.fromJson(response['data']);
  }

  // 提交测验
  Future<QuizResult> submitQuiz(String quizId, SubmitQuizRequest request) async {
    final response = await _apiService.post('/quizzes/$quizId/submit', body: request.toJson());
    return QuizResult.fromJson(response['data']);
  }

  // 获取所有测验历史记录（用于history页面）
  Future<List<Quiz>> getAllQuizHistory() async {
    final response = await _apiService.get('/quizzes/history/all');
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => Quiz.fromJson(json)).toList();
  }
}

// 请求和响应模型
class SubmitQuizRequest {
  final List<QuestionAnswer> answers;
  final int completionTime;

  SubmitQuizRequest({
    required this.answers,
    required this.completionTime,
  });

  Map<String, dynamic> toJson() => {
    'answers': answers.map((a) => a.toJson()).toList(),
    'completionTime': completionTime,
  };
}

class QuestionAnswer {
  final String questionId;
  final List<int> selectedAnswers;

  QuestionAnswer({
    required this.questionId,
    required this.selectedAnswers,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'selectedAnswers': selectedAnswers,
  };
}

class QuizResult {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int completionTime;
  final DateTime completedAt;
  final List<QuestionResult> questionResults;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completionTime,
    required this.completedAt,
    required this.questionResults,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    id: json['id'],
    quizId: json['quizId'],
    userId: json['userId'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    correctAnswers: json['correctAnswers'],
    completionTime: json['completionTime'],
    completedAt: DateTime.parse(json['completedAt']),
    questionResults: (json['questionResults'] as List)
        .map((item) => QuestionResult.fromJson(item))
        .toList(),
  );
}

class QuestionResult {
  final String questionId;
  final List<int> selectedAnswers;
  final List<int> correctAnswers;
  final bool isCorrect;

  QuestionResult({
    required this.questionId,
    required this.selectedAnswers,
    required this.correctAnswers,
    required this.isCorrect,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) => QuestionResult(
    questionId: json['questionId'],
    selectedAnswers: List<int>.from(json['selectedAnswers']),
    correctAnswers: List<int>.from(json['correctAnswers']),
    isCorrect: json['isCorrect'],
  );
}