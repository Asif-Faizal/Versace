package user

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"net/smtp"
	"strconv"

	"github.com/Asif-Faizal/Versace/config"
)

type EmailService struct {
	config *config.Config
}

func NewEmailService(cfg *config.Config) *EmailService {
	return &EmailService{config: cfg}
}

func (s *EmailService) generateOTP() (string, error) {
	otp := ""
	for i := 0; i < 6; i++ {
		n, err := rand.Int(rand.Reader, big.NewInt(10))
		if err != nil {
			return "", err
		}
		otp += n.String()
	}
	return otp, nil
}

func (s *EmailService) SendOTP(to, otp string) error {
	from := s.config.EmailFrom
	password := s.config.EmailPassword
	smtpHost := s.config.EmailHost
	smtpPort := s.config.EmailPort

	auth := smtp.PlainAuth("", from, password, smtpHost)

	subject := "Subject: Your OTP Code"
	body := fmt.Sprintf("Your OTP code is: %s\nIt will expire in 5 minutes.", otp)
	msg := []byte(subject + "\n" + body)

	addr := smtpHost + ":" + smtpPort
	var err error
	if s.config.EmailSecure == "true" {
		// Use SendMail which implicitly uses STARTTLS if the server supports it on port 587
		err = smtp.SendMail(addr, auth, from, []string{to}, msg)
	} else {
		// For non-secure or local testing, you might need a different setup
		// This path assumes a non-TLS connection, which is not common for production
		// You would typically connect and then issue commands.
		// For simplicity, we'll stick to the standard library's SendMail behavior.
		// If you have a specific non-secure setup, this might need adjustment.
		err = smtp.SendMail(addr, auth, from, []string{to}, msg)
	}

	return err
}

func (s *EmailService) SendVerificationEmail(to, otp string) error {
	from := s.config.EmailFrom
	password := s.config.EmailPassword
	smtpHost := s.config.EmailHost
	smtpPort, err := strconv.Atoi(s.config.EmailPort)
	if err != nil {
		return fmt.Errorf("invalid email port: %w", err)
	}

	auth := smtp.PlainAuth("", from, password, smtpHost)
	subject := "Subject: Verify Your Email"
	body := fmt.Sprintf("Your verification code is: %s", otp)
	msg := []byte(subject + "\n" + body)

	addr := fmt.Sprintf("%s:%d", smtpHost, smtpPort)
	return smtp.SendMail(addr, auth, from, []string{to}, msg)
}
