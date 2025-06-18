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
	}

	// Validate required environment variables
	if cfg.ServerHost == "" || cfg.ServerPort == "" || cfg.DBUser == "" ||
		cfg.DBPassword == "" || cfg.DBName == "" || cfg.DBAddress == "" || cfg.AdminCreationToken == "" || cfg.JWTSecret == "" {
		return nil, fmt.Errorf("all environment variables must be set")
	}

	Envs = cfg
	return cfg, nil
}

func (c *Config) GetServerAddress() string {
	return fmt.Sprintf("%s:%s", c.ServerHost, c.ServerPort)
}
