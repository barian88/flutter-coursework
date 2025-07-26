package services

import (
	"backend/database"
	"backend/models"
	"context"
	"errors"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// UserStatsService 用户统计服务结构体 - 处理用户统计相关的业务逻辑
type UserStatsService struct {
	collection *mongo.Collection // MongoDB集合引用
}

// NewUserStatsService 创建新的用户统计服务实例
func NewUserStatsService() *UserStatsService {
	return &UserStatsService{
		collection: database.GetCollection(database.UserStatsCollection),
	}
}

// GetUserStatsByUserID 根据用户ID查询用户统计记录
func (s *UserStatsService) GetUserStatsByUserID(userID primitive.ObjectID) (*models.UserStats, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	var userStats models.UserStats
	// 使用userID作为_id进行查询
	err := s.collection.FindOne(ctx, bson.M{"_id": userID}).Decode(&userStats)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, errors.New("User statistics not found")
		}
		return nil, errors.New("Database query error")
	}

	return &userStats, nil
}
