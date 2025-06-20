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

func (s *AuthService) generateTokens(user types.Authable) (accessToken string, refreshToken string, err error) {
	jwtExpiry, err := time.ParseDuration(config.Envs.JWTExpiry)
	if err != nil {
		return "", "", fmt.Errorf("invalid jwt expiry duration: %w", err)
	}
	refreshExpiry, err := time.ParseDuration(config.Envs.JWTRefreshExpiry)
	if err != nil {
		return "", "", fmt.Errorf("invalid jwt refresh expiry duration: %w", err)
	}

	// Create access token
	accessClaims := jwt.MapClaims{
		"id":    user.GetID(),
		"email": user.GetEmail(),
		"role":  user.GetRole(),
		"exp":   time.Now().Add(jwtExpiry).Unix(),
	}
	accessToken, err = jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims).SignedString([]byte(config.Envs.JWTSecret))
	if err != nil {
		return "", "", err
	}

	// Create refresh token
	refreshClaims := jwt.MapClaims{
		"id":    user.GetID(),
		"email": user.GetEmail(),
		"role":  user.GetRole(),
		"exp":   time.Now().Add(refreshExpiry).Unix(),
	}
	refreshToken, err = jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims).SignedString([]byte(config.Envs.JWTSecret))
	if err != nil {
		return "", "", err
	}

	return accessToken, refreshToken, nil
}

func (s *AuthService) CreateToken(user types.Authable, deviceInfo types.DeviceInfo) (accessToken string, refreshToken string, err error) {
	accessToken, refreshToken, err = s.generateTokens(user)
	if err != nil {
		return "", "", err
	}

	refreshExpiry, err := time.ParseDuration(config.Envs.JWTRefreshExpiry)
	if err != nil {
		return "", "", fmt.Errorf("invalid jwt refresh expiry duration: %w", err)
	}

	// Store refresh token
	token := &types.Token{
		UserID:       user.GetID(),
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		ExpiresAt:    time.Now().Add(refreshExpiry),
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

func (s *AuthService) RefreshToken(refreshTokenString string, deviceInfo types.DeviceInfo) (string, string, int, error) {
	// 1. Verify the refresh token
	token, err := s.VerifyToken(refreshTokenString)
	if err != nil {
		return "", "", 0, fmt.Errorf("invalid refresh token: %w", err)
	}

	if !token.Valid {
		return "", "", 0, fmt.Errorf("invalid refresh token")
	}

	// 2. Get token from DB
	storedToken, err := s.tokenStore.GetTokenByRefreshToken(refreshTokenString)
	if err != nil {
		return "", "", 0, fmt.Errorf("failed to get token from store: %w", err)
	}
	if storedToken == nil {
		return "", "", 0, fmt.Errorf("token not found")
	}

	// 3. Check if revoked
	if storedToken.Revoked {
		return "", "", 0, fmt.Errorf("refresh token has been revoked")
	}

	// 4. Check device ID
	if storedToken.DeviceInfo.DeviceID != deviceInfo.DeviceID {
		return "", "", 0, fmt.Errorf("device ID mismatch")
	}

	// 5. Check expiry from claims
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return "", "", 0, fmt.Errorf("invalid token claims")
	}
	exp := int64(claims["exp"].(float64))
	if time.Unix(exp, 0).Before(time.Now()) {
		return "", "", 0, fmt.Errorf("refresh token has expired")
	}

	// 6. Get user details from claims
	userID := int(claims["id"].(float64))
	userEmail := claims["email"].(string)
	userRole := claims["role"].(string)

	user := &types.User{
		ID:    userID,
		Email: userEmail,
		Role:  userRole,
	}

	// 7. Generate new tokens
	newAccessToken, newRefreshToken, err := s.generateTokens(user)
	if err != nil {
		return "", "", 0, fmt.Errorf("failed to generate new tokens: %w", err)
	}

	refreshExpiry, err := time.ParseDuration(config.Envs.JWTRefreshExpiry)
	if err != nil {
		return "", "", 0, fmt.Errorf("invalid jwt refresh expiry duration: %w", err)
	}

	// 8. Update the token in the database
	storedToken.AccessToken = newAccessToken
	storedToken.RefreshToken = newRefreshToken
	storedToken.ExpiresAt = time.Now().Add(refreshExpiry)
	storedToken.UpdatedAt = time.Now()

	err = s.tokenStore.UpdateToken(storedToken)
	if err != nil {
		return "", "", 0, fmt.Errorf("failed to update token: %w", err)
	}

	return newAccessToken, newRefreshToken, user.ID, nil
}

func (s *AuthService) Login(user *types.User, deviceInfo types.DeviceInfo) (accessToken string, refreshToken string, err error) {
	// Check if a session already exists for this device
	existingToken, err := s.tokenStore.GetTokenByUserIDAndDeviceID(user.ID, deviceInfo.DeviceID)
	if err != nil {
		return "", "", fmt.Errorf("failed to check for existing token: %w", err)
	}

	accessToken, refreshToken, err = s.generateTokens(user)
	if err != nil {
		return "", "", fmt.Errorf("failed to generate tokens: %w", err)
	}

	refreshExpiry, err := time.ParseDuration(config.Envs.JWTRefreshExpiry)
	if err != nil {
		return "", "", fmt.Errorf("invalid jwt refresh expiry duration: %w", err)
	}

	if existingToken != nil {
		// Update the existing token
		existingToken.AccessToken = accessToken
		existingToken.RefreshToken = refreshToken
		existingToken.ExpiresAt = time.Now().Add(refreshExpiry)
		existingToken.UpdatedAt = time.Now()
		existingToken.Revoked = false // Ensure the token is not revoked

		err = s.tokenStore.UpdateToken(existingToken)
		if err != nil {
			return "", "", fmt.Errorf("failed to update token: %w", err)
		}
	} else {
		// Create a new token for the new device
		token := &types.Token{
			UserID:       user.ID,
			AccessToken:  accessToken,
			RefreshToken: refreshToken,
			ExpiresAt:    time.Now().Add(refreshExpiry),
			DeviceInfo:   deviceInfo,
		}
		err = s.tokenStore.CreateToken(token)
		if err != nil {
			return "", "", fmt.Errorf("failed to create token: %w", err)
		}
	}

	return accessToken, refreshToken, nil
}
