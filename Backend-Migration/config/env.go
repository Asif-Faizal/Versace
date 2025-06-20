package config

import (
	"fmt"
	"os"
)

type Config struct {
	ServerHost         string
	ServerPort         string
	DBUser             string
	DBPassword         string
	DBName             string
	DBAddress          string
	AdminCreationToken string
	JWTSecret          string
	EmailHost          string
	EmailPort          string
	EmailSecure        string
	EmailUser          string
	EmailPassword      string
	EmailFrom          string
}

var Envs *Config

func InitConfig() (*Config, error) {
	cfg := &Config{
		ServerHost:         os.Getenv("SERVER_HOST"),
		ServerPort:         os.Getenv("SERVER_PORT"),
		DBUser:             os.Getenv("DB_USER"),
		DBPassword:         os.Getenv("DB_PASSWORD"),
		DBName:             os.Getenv("DB_NAME"),
		DBAddress:          os.Getenv("DB_ADDRESS"),
		AdminCreationToken: os.Getenv("ADMIN_CREATION_TOKEN"),
		JWTSecret:          os.Getenv("JWT_SECRET"),
		EmailHost:          os.Getenv("EMAIL_HOST"),
		EmailPort:          os.Getenv("EMAIL_PORT"),
		EmailSecure:        os.Getenv("EMAIL_SECURE"),
		EmailUser:          os.Getenv("EMAIL_USER"),
		EmailPassword:      os.Getenv("EMAIL_PASSWORD"),
		EmailFrom:          os.Getenv("EMAIL_FROM"),
	}

	// Validate required environment variables
	if cfg.ServerHost == "" || cfg.ServerPort == "" || cfg.DBUser == "" ||
		cfg.DBPassword == "" || cfg.DBName == "" || cfg.DBAddress == "" || cfg.AdminCreationToken == "" || cfg.JWTSecret == "" {
		return nil, fmt.Errorf("all environment variables must be set")
	}

	if cfg.EmailHost == "" || cfg.EmailPort == "" || cfg.EmailUser == "" || cfg.EmailPassword == "" || cfg.EmailFrom == "" {
		return nil, fmt.Errorf("all email environment variables must be set")
	}

	Envs = cfg
	return cfg, nil
}

func (c *Config) GetServerAddress() string {
	return fmt.Sprintf("%s:%s", c.ServerHost, c.ServerPort)
}
