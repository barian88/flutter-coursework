package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Question struct {
	ID                 primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	QuestionText       string             `json:"question_text" bson:"question_text"`
	Options            []string           `json:"options" bson:"options"`
	CorrectAnswerIndex []int              `json:"correct_answer_index" bson:"correct_answer_index"`
	Type               string             `json:"type" bson:"type"`             // "singleChoice" | "multipleChoice" | "trueFalse"
	Category           string             `json:"category" bson:"category"`     // "truthTable" | "equivalence" | "inference"
	Difficulty         string             `json:"difficulty" bson:"difficulty"` // "easy" | "medium" | "hard"
	IsActive           bool               `json:"is_active" bson:"is_active"`
}

// 这个模型有必要吗
type CreateQuestionRequest struct {
	QuestionText       string   `json:"question_text" binding:"required"`
	Options            []string `json:"options" binding:"required"`
	CorrectAnswerIndex []int    `json:"correct_answer_index" binding:"required"`
	Type               string   `json:"type" binding:"required,oneof=singleChoice multipleChoice trueFalse"`
	Category           string   `json:"category" binding:"required,oneof=truthTable equivalence inference"`
	Difficulty         string   `json:"difficulty" binding:"required,oneof=easy medium hard"`
}
