package user

import (
	"encoding/json"
	"net/http"
	"time"

	"log"

	"github.com/Asif-Faizal/Versace/types"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/gorilla/mux"
)

// Handler represents the user-related HTTP handlers
// It contains methods to handle different user-related endpoints
type Handler struct {
	store              types.UserStore // Interface for user data operations
	tokenStore         types.TokenStore
	authService        *AuthService
	emailService       *EmailService
	adminCreationToken string // Token required for admin creation
}

// NewHandler creates a new instance of the user Handler
// This is a constructor function for the Handler struct
func NewHandler(store types.UserStore, tokenStore types.TokenStore, authService *AuthService, adminCreationToken string, emailService *EmailService) *Handler {
	return &Handler{store: store, tokenStore: tokenStore, authService: authService, adminCreationToken: adminCreationToken, emailService: emailService}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/users", h.GetUsers).Methods("GET")
	router.HandleFunc("/users/check", h.CheckEmail).Methods("POST")
	router.HandleFunc("/users", h.Register).Methods("POST")
	router.HandleFunc("/users/send-otp", h.SendOTP).Methods("POST")
	router.HandleFunc("/users/verify-otp", h.VerifyOTP).Methods("POST")
	router.HandleFunc("/users/{id}", h.GetUserByID).Methods("GET")
	router.HandleFunc("/users/{id}", h.UpdateUser).Methods("PUT")
	router.HandleFunc("/users/{id}", h.DeleteUser).Methods("DELETE")
	router.HandleFunc("/users/login", h.Login).Methods("POST")
	router.HandleFunc("/users/logout", h.Logout).Methods("POST")
	router.HandleFunc("/users/refresh", h.Refresh).Methods("POST")
	router.HandleFunc("/users/reset-password", h.ResetPassword).Methods("POST")
}

// GetUsers handles the GET request to retrieve all users
func (h *Handler) GetUsers(w http.ResponseWriter, r *http.Request) {
}

// Register handles the POST request to create a new user
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	var userReq types.UserRegisterRequest
	if err := json.NewDecoder(r.Body).Decode(&userReq); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate the user input
	if !utils.IsValidEmail(userReq.Email) {
		utils.WriteError(w, http.StatusBadRequest, "Invalid email format", "")
		return
	}
	if !utils.IsValidPassword(userReq.Password) {
		utils.WriteError(w, http.StatusBadRequest, "Password must be more than 6 characters", "")
		return
	}
	if !utils.IsValidName(userReq.FirstName) {
		utils.WriteError(w, http.StatusBadRequest, "First name must be more than 3 characters", "")
		return
	}
	if !utils.IsValidOptionalName(userReq.LastName) {
		utils.WriteError(w, http.StatusBadRequest, "Last name must be empty or more than 3 characters", "")
		return
	}

	// Check if user already exists
	existingUser, err := h.store.GetUserByEmail(userReq.Email)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to check for existing user", err.Error())
		return
	}
	if existingUser != nil {
		utils.WriteError(w, http.StatusConflict, "User with this email already exists", "")
		return
	}

	if userReq.Role == "admin" {
		if userReq.AdminCreationToken == "" {
			utils.WriteError(w, http.StatusBadRequest, "adminCreationToken is required for admin registration", "")
			return
		}
		if userReq.AdminCreationToken != h.adminCreationToken {
			utils.WriteError(w, http.StatusUnauthorized, "invalid adminCreationToken", "")
			return
		}
	} else {
		userReq.Role = "user"
		userReq.AdminCreationToken = ""
	}

	hashedPassword, err := h.authService.HashPassword(userReq.Password)
	if err != nil {
		log.Printf("failed to hash password: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, "Failed to process password", err.Error())
		return
	}

	newUser := &types.User{
		FirstName: userReq.FirstName,
		LastName:  userReq.LastName,
		Email:     userReq.Email,
		Password:  hashedPassword,
		Role:      userReq.Role,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	createdUser, err := h.store.CreateUser(newUser)
	if err != nil {
		log.Printf("failed to create user: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create user", err.Error())
		return
	}

	deviceInfo := types.DeviceInfo{
		DeviceID:    r.Header.Get("X-Device-ID"),
		DeviceName:  r.Header.Get("X-Device-Name"),
		DeviceType:  r.Header.Get("X-Device-Type"),
		DeviceOS:    r.Header.Get("X-Device-OS"),
		DeviceModel: r.Header.Get("X-Device-Model"),
		DeviceIP:    r.RemoteAddr,
	}

	accessToken, refreshToken, err := h.authService.CreateToken(createdUser, deviceInfo)
	if err != nil {
		log.Printf("failed to create tokens: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create tokens", err.Error())
		return
	}

	response := types.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         *createdUser,
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) CheckEmail(w http.ResponseWriter, r *http.Request) {
	var userReq types.CheckEmailRequest
	if err := json.NewDecoder(r.Body).Decode(&userReq); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate the email format
	if !utils.IsValidEmail(userReq.Email) {
		utils.WriteError(w, http.StatusBadRequest, "Invalid email format", "")
		return
	}

	// Read device info from headers (for future use or logging)
	_ = types.DeviceInfo{
		DeviceID:    r.Header.Get("X-Device-ID"),
		DeviceName:  r.Header.Get("X-Device-Name"),
		DeviceType:  r.Header.Get("X-Device-Type"),
		DeviceOS:    r.Header.Get("X-Device-OS"),
		DeviceModel: r.Header.Get("X-Device-Model"),
		DeviceIP:    r.RemoteAddr,
	}

	existingUser, err := h.store.GetUserByEmail(userReq.Email)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to check for existing user", err.Error())
		return
	}
	if existingUser != nil {
		utils.WriteError(w, http.StatusConflict, "User with this email already exists", "")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Email is available", nil)
}

func (h *Handler) SendOTP(w http.ResponseWriter, r *http.Request) {
	var req types.SendOTPRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	if !utils.IsValidEmail(req.Email) {
		utils.WriteError(w, http.StatusBadRequest, "Invalid email format", "")
		return
	}

	otp, err := h.emailService.generateOTP()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to generate OTP", err.Error())
		return
	}

	err = h.emailService.SendOTP(req.Email, otp)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to send OTP", err.Error())
		return
	}

	otpModel := &types.OTP{
		Email:     req.Email,
		Code:      otp,
		ExpiresAt: time.Now().Add(5 * time.Minute),
	}
	if err := h.store.SaveOTP(otpModel); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to save OTP", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "OTP sent successfully", nil)
}

func (h *Handler) VerifyOTP(w http.ResponseWriter, r *http.Request) {
	var req types.VerifyOTPRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	storedOTP, err := h.store.GetOTPByEmail(req.Email)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve OTP", err.Error())
		return
	}

	if storedOTP == nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid or expired OTP", "")
		return
	}

	if storedOTP.ExpiresAt.Before(time.Now()) {
		utils.WriteError(w, http.StatusBadRequest, "OTP has expired", "")
		return
	}

	if storedOTP.Code != req.OTP {
		utils.WriteError(w, http.StatusBadRequest, "Invalid OTP", "")
		return
	}

	// OTP is valid, delete it so it cannot be reused
	if err := h.store.DeleteOTP(req.Email); err != nil {
		// Log this error but don't fail the request, as the OTP was valid
		log.Printf("failed to delete used OTP for email %s: %v", req.Email, err)
	}

	utils.WriteSuccess(w, http.StatusOK, "OTP verified successfully", nil)
}

// GetUserByID handles the GET request to retrieve a user by ID
func (h *Handler) GetUserByID(w http.ResponseWriter, r *http.Request) {
}

// UpdateUser handles the PUT request to update an existing user
func (h *Handler) UpdateUser(w http.ResponseWriter, r *http.Request) {
}

// DeleteUser handles the DELETE request to delete an existing user
func (h *Handler) DeleteUser(w http.ResponseWriter, r *http.Request) {
}

// Login handles the POST request to login a user
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
}

// Logout handles the POST request to logout a user
func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
}

// Refresh handles the POST request to refresh a user's session
func (h *Handler) Refresh(w http.ResponseWriter, r *http.Request) {
	var req types.RefreshTokenRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	deviceInfo := types.DeviceInfo{
		DeviceID:    r.Header.Get("X-Device-ID"),
		DeviceName:  r.Header.Get("X-Device-Name"),
		DeviceType:  r.Header.Get("X-Device-Type"),
		DeviceOS:    r.Header.Get("X-Device-OS"),
		DeviceModel: r.Header.Get("X-Device-Model"),
		DeviceIP:    r.RemoteAddr,
	}

	newAccessToken, newRefreshToken, userID, err := h.authService.RefreshToken(req.RefreshToken, deviceInfo)
	if err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Failed to refresh token", err.Error())
		return
	}

	user, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user details", err.Error())
		return
	}
	if user == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	response := types.AuthResponse{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
		User:         *user,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// ResetPassword handles the POST request to reset a user's password
func (h *Handler) ResetPassword(w http.ResponseWriter, r *http.Request) {
}
