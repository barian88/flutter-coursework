import 'question.dart';

enum QuizType{
  randomTasks,
  topicPractice,
  byDifficulty,
  customQuiz,
}

extension QuizTypeExtension on QuizType {
  String get displayName {
    switch (this) {
      case QuizType.randomTasks:
        return 'Random Tasks';
      case QuizType.topicPractice:
        return 'Topic Practice';
      case QuizType.byDifficulty:
        return 'By Difficulty';
      case QuizType.customQuiz:
        return 'Custom Quiz';
    }
  }
}

class Quiz{

  final String id;
  final List<Question> questions;
  final QuizType type;
  final int correctQuestionsNum;
  final int completionTime;


  const Quiz({
    required this.id,
    required this.questions,
    required this.type,
    this.correctQuestionsNum = 0,
    this.completionTime = 0,
  });

  Quiz copyWith({
    String? id,
    List<Question>? questions,
    QuizType? type,
    int? correctQuestionsNum,
    int? completionTime,
  }) {
    return Quiz(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      type: type ?? this.type,
      correctQuestionsNum: correctQuestionsNum ?? this.correctQuestionsNum,
      completionTime: completionTime ?? this.completionTime,
    );
  }

  // 便利方法
  int get totalQuestionsNum => questions.length;
  
  // JSON 序列化支持
  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'] ?? '',
    questions: (json['questions'] as List<dynamic>?)
        ?.map((item) => Question.fromJson(item))
        .toList() ?? [],
    type: QuizType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => QuizType.randomTasks,
    ),
    correctQuestionsNum: json['correctQuestionsNum'] ?? 0,
    completionTime: json['completionTime'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'questions': questions.map((q) => q.toJson()).toList(),
    'type': type.name,
    'correctQuestionsNum': correctQuestionsNum,
    'completionTime': completionTime,
  };

}