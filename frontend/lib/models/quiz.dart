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
  final int totalQuestionsNum = 10;
  final int correctQuestionsNum;
  final int completionTime;


  Quiz({
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

}