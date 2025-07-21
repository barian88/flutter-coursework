package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

// User 用户数据模型 - 对应MongoDB中的users集合
type User struct {
	ID                primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`         // MongoDB自动生成的唯一ID
	Username          string             `json:"username" bson:"username"`                   // 用户名
	Email             string             `json:"email" bson:"email"`                         // 用户邮箱，用于登录
	Password          string             `json:"-" bson:"password"`                          // 密码（json:"-"表示不在JSON响应中返回）
	ProfilePictureUrl string             `json:"profilePictureUrl" bson:"profilePictureUrl"` // 用户头像URL
	Role              string             `json:"role" bson:"role"`                           // 用户角色：user或admin
	CreatedAt         time.Time          `json:"created_at" bson:"created_at"`               // 账户创建时间
	UpdatedAt         time.Time          `json:"updated_at" bson:"updated_at"`               // 最后更新时间
}


// UserResponse 用户响应结构体 - 返回给前端的用户信息（不包含敏感信息如密码）
type UserResponse struct {
	ID                primitive.ObjectID `json:"_id"`               // 用户唯一ID
	Username          string             `json:"username"`          // 用户名
	Email             string             `json:"email"`             // 用户邮箱
	ProfilePictureUrl string             `json:"profilePictureUrl"` // 用户头像URL
	Role              string             `json:"role"`              // 用户角色
	CreatedAt         time.Time          `json:"created_at"`        // 账户创建时间
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// SendVerificationCodeRequest 发送验证码请求
type SendVerificationCodeRequest struct {
	Email string `json:"email" binding:"required,email"`
}

// VerifyCodeRequest 验证验证码请求
type VerifyCodeRequest struct {
	Email            string `json:"email" binding:"required,email"`
	VerificationCode string `json:"verificationCode" binding:"required"`
	Purpose          string `json:"purpose" binding:"required"` // "registration" 或 "password_reset"
}

// CompleteRegistrationRequest 完成注册请求
type CompleteRegistrationRequest struct {
	TemporaryToken string `json:"temporaryToken" binding:"required"`
}

// UpdatePasswordRequest 更新密码请求
type UpdatePasswordRequest struct {
	TemporaryToken string `json:"temporaryToken" binding:"required"`
	NewPassword    string `json:"newPassword" binding:"required,min=6"`
}
