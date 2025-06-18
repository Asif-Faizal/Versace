package user

import (
	"fmt"
	"time"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/types"
	"github.com/golang-jwt/jwt"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	tokenStore types.TokenStore
}

func NewAuthService(tokenStore types.TokenStore) *AuthService {
	return &AuthService{tokenStore: tokenStore}
}

func (s *AuthService) HashPassword(password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hash), nil
}

func (s *AuthService) ComparePasswords(hashedPassword, password string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

func (s *AuthService) CreateToken(user types.Authable, deviceInfo types.DeviceInfo) (accessToken string, refreshToken string, err error) {
	// Create access token
	accessClaims := jwt.MapClaims{
		"id":    user.GetID(),
		"email": user.GetEmail(),
		"role":  user.GetRole(),
		"exp":   time.Now().Add(time.Hour * 1).Unix(), // 1 hour
	}
	accessToken, err = jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims).SignedString([]byte(config.Envs.JWTSecret))
	if err != nil {
		return "", "", err
	}

	// Create refresh token
	refreshClaims := jwt.MapClaims{
		"id":  user.GetID(),
		"exp": time.Now().Add(time.Hour * 24 * 7).Unix(), // 7 days
	}
	refreshToken, err = jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims).SignedString([]byte(config.Envs.JWTSecret))
	if err != nil {
		return "", "", err
	}

	// Store refresh token
	token := &types.Token{
		UserID:       user.GetID(),
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresAt:    time.Now().Add(time.Hour * 24 * 7),
		DeviceInfo:   deviceInfo,
	}
	err = s.tokenStore.CreateToken(token)
	if err != nil {
		return "", "", err
	}

	return accessToken, refreshToken, nil
}

func (s *AuthService) VerifyToken(tokenString string) (*jwt.Token, error) {
	return jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(config.Envs.JWTSecret), nil
	})
}
