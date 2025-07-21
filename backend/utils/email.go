package utils

import (
	"fmt"
	"net/smtp"
)

// SendEmailViaGmail 通过Gmail SMTP发送邮件
func SendEmailViaGmail(toEmail, code string) error {
	// Gmail SMTP 配置
	from := "gujianyang0808@gmail.com" // 你的 Gmail
	password := "hwzq itxj bszq ormd"  // 应用专用密码
	smtpHost := "smtp.gmail.com"
	smtpPort := "587"

	// 邮件内容
	subject := "LogiQ 验证码"
	body := fmt.Sprintf("您的验证码是：%s，请在5分钟内使用。", code)
	msg := []byte("To: " + toEmail + "\r\n" +
		"Subject: " + subject + "\r\n" +
		"Content-Type: text/plain; charset=UTF-8\r\n" +
		"\r\n" + body + "\r\n")

	// 认证
	auth := smtp.PlainAuth("", from, password, smtpHost)

	// 发送邮件
	return smtp.SendMail(smtpHost+":"+smtpPort, auth, from, []string{toEmail}, msg)
}