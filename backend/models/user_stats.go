package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type UserStats struct {
	ID                primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`           // 与UserID一致
	Performance       Performance        `json:"performance" bson:"performance"`               // 用户表现
	AccuracyRate      AccuracyRate       `json:"accuracy_rate" bson:"accuracy_rate"`           // 准确率
	ErrorDistribution ErrorDistribution  `json:"error_distribution" bson:"error_distribution"` // 错误分布
}

type Performance struct {
	TaskNum int     `json:"task_num" bson:"task_num"` // (正确)任务数量
	Score   int     `json:"score" bson:"score"`       // 总分
	AvgTime float64 `json:"avg_time" bson:"avg_time"` // 平均每题完成时间
}

type AccuracyRate struct {
	Data []AccuracyRateItem `json:"data" bson:"data"` // 准确率数据点 包含7个
}

type AccuracyRateItem struct {
	Date  time.Time `json:"date" bson:"date"`   // 日期
	Value float64   `json:"value" bson:"value"` // 准确率值
}

type ErrorDistribution struct {
	DataByCategory   []ErrorDistributionItem `json:"data_by_category" bson:"data_by_category"`     // 按类别分布
	DataByDifficulty []ErrorDistributionItem `json:"data_by_difficulty" bson:"data_by_difficulty"` // 按难度分布
}
type ErrorDistributionItem struct {
	Type  string  `json:"type" bson:"type"`   // 类别
	Value float64 `json:"value" bson:"value"` // 比例值
}
