package middleware

import (
	"context"
	"net/http"
	"strings"

	"github.com/Asif-Faizal/Versace/services/user"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/golang-jwt/jwt"
)

type key int

const (
	UserKey key = iota
)

type AuthenticatedUser struct {
	ID    int
	Email string
	Role  string
}

func AuthMiddleware(authService *user.AuthService) func(http.Handler) http.Handler {
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

			token, err := authService.VerifyToken(tokenString)
			if err != nil || !token.Valid {
				utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", err.Error())
				return
			}

			claims, ok := token.Claims.(jwt.MapClaims)
			if !ok {
				utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
				return
			}

			user := AuthenticatedUser{
				ID:    int(claims["id"].(float64)),
				Email: claims["email"].(string),
				Role:  claims["role"].(string),
			}

			ctx := context.WithValue(r.Context(), UserKey, user)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func AdminAuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		user, ok := r.Context().Value(UserKey).(AuthenticatedUser)
		if !ok || strings.ToUpper(user.Role) != "ADMIN" {
			utils.WriteError(w, http.StatusForbidden, "Admin access required", "")
			return
		}
		next.ServeHTTP(w, r)
	})
}
