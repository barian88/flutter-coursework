package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type QuizQuestion struct {
	Question        *Question `json:"question" bson:"question"`
	UserAnswerIndex []int     `json:"user_answer_index" bson:"user_answer_index"`
}

type Quiz struct {
	ID                  primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	UserID              primitive.ObjectID `json:"user_id" bson:"user_id"`
	QuizType            string             `json:"quiz_type" bson:"quiz_type"` // "randomTasks" | "topicPractice" | "byDifficulty" | "customQuiz"
	Questions           []QuizQuestion     `json:"questions" bson:"questions"`
	CorrectQuestionsNum int                `json:"correct_questions_num" bson:"correct_questions_num"`
	CompletionTime      int                `json:"completion_time" bson:"completion_time"` // 秒
	CompletedAt         time.Time          `json:"completed_at" bson:"completed_at"`
}

type CreateQuizRequest struct {
	QuizType   string `json:"quiz_type" binding:"required,oneof=randomTasks topicPractice byDifficulty customQuiz"`
	Category   string `json:"category,omitempty"`   // for topicPractice
	Difficulty string `json:"difficulty,omitempty"` // for byDifficulty
}

type SubmitQuizRequest struct {
	QuizID         primitive.ObjectID `json:"quiz_id" binding:"required"`
	Questions      []QuizQuestion     `json:"questions" binding:"required,len=10"`
	CompletionTime int                `json:"completion_time" binding:"required"`
}

type PendingQuiz struct {
	ID         primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	UserID     primitive.ObjectID `json:"user_id" bson:"user_id"`
	QuizType   string             `json:"quiz_type" bson:"quiz_type"`
	Questions  []QuizQuestion     `json:"questions" bson:"questions"`
	PassedTime int                `json:"passed_time" bson:"passed_time"` // 秒, 上一次已经答题的时间
}
