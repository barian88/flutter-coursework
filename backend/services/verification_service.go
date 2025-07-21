package services

import (
	"backend/database"
	"backend/models"
	"backend/utils"
	"context"
	"crypto/rand"
	"errors"
	"log"
	"math/big"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

// VerificationService 验证码服务
type VerificationService struct {
	collection *mongo.Collection
}

// NewVerificationService 创建验证码服务实例
func NewVerificationService() *VerificationService {
	return &VerificationService{
		collection: database.GetCollection("verification_codes"),
	}
}

// SendVerificationCode 发送验证码
func (s *VerificationService) SendVerificationCode(email string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 生成6位验证码
	code, err := s.generateCode()
	if err != nil {
		return errors.New("Failed to generate verification code")
	}

	// 检查是否有未过期的验证码
	var existingCode models.VerificationCode
	err = s.collection.FindOne(ctx, bson.M{
		"email":      email,
		"used":       false,
		"expires_at": bson.M{"$gt": time.Now()},
	}).Decode(&existingCode)

	if err == nil {
		return errors.New("Verification code already sent, please try again later")
	}

	// 创建新的验证码记录
	verificationCode := models.VerificationCode{
		Email:     email,
		Code:      code,
		ExpiresAt: time.Now().Add(5 * time.Minute), // 5分钟过期
		Used:      false,
		CreatedAt: time.Now(),
	}

	// 保存到数据库
	_, err = s.collection.InsertOne(ctx, verificationCode)
	if err != nil {
		return errors.New("Failed to save verification code")
	}

	// 发送邮件
	err = utils.SendEmailViaGmail(email, code)
	if err != nil {
		log.Printf("Email sending failed: %v", err)
		return errors.New("Failed to send email")
	}

	return nil
}

// VerifyCode 验证验证码
func (s *VerificationService) VerifyCode(email, code string) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 查找有效的验证码
	var verificationCode models.VerificationCode
	err := s.collection.FindOne(ctx, bson.M{
		"email":      email,
		"code":       code,
		"used":       false,
		"expires_at": bson.M{"$gt": time.Now()},
	}).Decode(&verificationCode)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			return errors.New("Invalid or expired verification code")
		}
		return errors.New("Verification code validation failed")
	}

	// 标记验证码为已使用
	_, err = s.collection.UpdateOne(ctx, bson.M{"_id": verificationCode.ID}, bson.M{
		"$set": bson.M{"used": true},
	})

	if err != nil {
		return errors.New("Failed to update verification code status")
	}

	return nil
}

// generateCode 生成4位数字验证码
func (s *VerificationService) generateCode() (string, error) {
	const digits = "0123456789"
	result := make([]byte, 4)

	for i := range result {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(digits))))
		if err != nil {
			return "", err
		}
		result[i] = digits[num.Int64()]
	}

	return string(result), nil
}
