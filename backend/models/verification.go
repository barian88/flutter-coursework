package models

import (
	"time"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// VerificationCode 验证码数据模型
type VerificationCode struct {
	ID        primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	Email     string             `json:"email" bson:"email"`
	Code      string             `json:"code" bson:"code"`
	ExpiresAt time.Time          `json:"expires_at" bson:"expires_at"`
	Used      bool               `json:"used" bson:"used"`
	CreatedAt time.Time          `json:"created_at" bson:"created_at"`
}