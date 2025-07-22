package services

import (
	"backend/database"
	"backend/models"
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"time"
)

type QuestionService struct {
	collection *mongo.Collection
}

func NewQuestionService() *QuestionService {
	return &QuestionService{
		collection: database.GetCollection(database.QuestionsCollection),
	}
}

func (s *QuestionService) CreateQuestion(req *models.CreateQuestionRequest) (*models.Question, error) {
	// TODO: 实现题目创建逻辑
	return nil, nil
}

func (s *QuestionService) GetQuestionByID(questionID primitive.ObjectID) (*models.Question, error) {
	// TODO: 根据ID获取题目
	return nil, nil
}

// GetRandomQuestions 根据category difficulty获取10个题目，用来创建quiz
func (s *QuestionService) GetRandomQuestions(category string, difficulty string, count int) ([]models.Question, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 设置count默认值
	if count <= 0 {
		count = 10
	}

	// 构建筛选条件
	filter := bson.M{"is_active": true}

	if category != "" {
		filter["category"] = category
	}

	if difficulty != "" {
		filter["difficulty"] = difficulty
	}

	// 使用MongoDB的$sample进行随机抽样
	pipeline := []bson.M{
		{"$match": filter},
		{"$sample": bson.M{"size": count}},
	}

	cursor, err := s.collection.Aggregate(ctx, pipeline)
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var questions []models.Question
	if err = cursor.All(ctx, &questions); err != nil {
		return nil, err
	}

	return questions, nil
}

func (s *QuestionService) DeleteQuestion(questionID primitive.ObjectID) error {
	// TODO: 删除题目（软删除，设置is_active为false）
	return nil
}
