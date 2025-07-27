package user

import (
	"context"
	"net/http"
	"strings"

	types "github.com/Asif-Faizal/Versace/types/user"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/golang-jwt/jwt"
)

func AuthMiddleware(authService *AuthService) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				utils.WriteError(w, http.StatusUnauthorized, "Missing authorization header", "")
				return
			}

			parts := strings.Split(authHeader, " ")
			if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
				utils.WriteError(w, http.StatusUnauthorized, "Invalid authorization header format", "")
				return
			}
			tokenString := parts[1]

			deviceID := r.Header.Get("X-Device-ID")
			if deviceID == "" {
				utils.WriteError(w, http.StatusUnauthorized, "Missing Device-ID header", "")
				return
			}

			token, err := authService.VerifyTokenAndDevice(tokenString, deviceID)
			if err != nil {
				utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", err.Error())
				return
			}

			claims, ok := token.Claims.(jwt.MapClaims)
			if !ok {
				utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
				return
			}

			user := types.AuthenticatedUser{
				ID:    int(claims["id"].(float64)),
				Email: claims["email"].(string),
				Role:  claims["role"].(string),
			}

			ctx := context.WithValue(r.Context(), types.UserKey, user)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func AdminAuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		user, ok := r.Context().Value(types.UserKey).(types.AuthenticatedUser)
		if !ok || strings.ToUpper(user.Role) != "ADMIN" {
			utils.WriteError(w, http.StatusForbidden, "Admin access required", "")
			return
		}
		next.ServeHTTP(w, r)
	})
}
