import 'question.dart';

enum QuizType{
  randomTasks,
  topicPractice,
  byDifficulty,
  customQuiz,
}

class Quiz{

  final List<Question> questions;
  final QuizType type;
  final int totalQuestionsNum = 10;
  final int correctQuestionsNum;
  final int completionTime;


  Quiz({
    required this.questions,
    required this.type,
    this.correctQuestionsNum = 0,
    this.completionTime = 0,
  });

  Quiz copyWith({
    List<Question>? questions,
    QuizType? type,
    int? correctQuestionsNum,
    int? completionTime,
  }) {
    return Quiz(
      questions: questions ?? this.questions,
      type: type ?? this.type,
      correctQuestionsNum: correctQuestionsNum ?? this.correctQuestionsNum,
      completionTime: completionTime ?? this.completionTime,
    );
  }

}