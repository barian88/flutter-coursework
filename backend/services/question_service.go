package services

import (
	"backend/models"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type QuestionService struct {
	// TODO: 添加数据库连接
}

func NewQuestionService() *QuestionService {
	return &QuestionService{}
}

func (s *QuestionService) CreateQuestion(req *models.CreateQuestionRequest) (*models.QuestionResponse, error) {
	// TODO: 实现题目创建逻辑
	return nil, nil
}

func (s *QuestionService) GetQuestionByID(questionID primitive.ObjectID) (*models.QuestionResponse, error) {
	// TODO: 根据ID获取题目
	return nil, nil
}

func (s *QuestionService) GetQuestionsByCategory(category string) ([]models.QuestionResponse, error) {
	// TODO: 根据分类获取题目列表
	return nil, nil
}

func (s *QuestionService) GetQuestionsByDifficulty(difficulty string) ([]models.QuestionResponse, error) {
	// TODO: 根据难度获取题目列表
	return nil, nil
}

func (s *QuestionService) GetRandomQuestions(count int) ([]models.QuestionResponse, error) {
	// TODO: 随机获取指定数量的题目
	return nil, nil
}

func (s *QuestionService) UpdateQuestion(questionID primitive.ObjectID, req *models.CreateQuestionRequest) (*models.QuestionResponse, error) {
	// TODO: 更新题目
	return nil, nil
}

func (s *QuestionService) DeleteQuestion(questionID primitive.ObjectID) error {
	// TODO: 删除题目（软删除，设置is_active为false）
	return nil
}