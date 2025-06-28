package user

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"log"

	types "github.com/Asif-Faizal/Versace/types/user"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/golang-jwt/jwt"
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

// checkTokenRevocation is a helper function to verify if a token is revoked
func (h *Handler) checkTokenRevocation(userID int, deviceID string) error {
	revoked, err := h.tokenStore.IsTokenRevoked(userID, deviceID)
	if err != nil {
		return err
	}
	if revoked {
		return fmt.Errorf("token has been revoked")
	}
	return nil
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/users", h.GetUsers).Methods("GET")                                   // admin only      //? completed
	router.HandleFunc("/users/check", h.CheckEmail).Methods("POST")                          // all users       //? completed
	router.HandleFunc("/users", h.Register).Methods("POST")                                  // all users       //? completed
	router.HandleFunc("/users/send-otp", h.SendOTP).Methods("POST")                          // all users       //? completed
	router.HandleFunc("/users/verify-otp", h.VerifyOTP).Methods("POST")                      // all users       //? completed
	router.HandleFunc("/users/device-sessions", h.GetDeviceSessions).Methods("GET")          // all users       //? completed
	router.HandleFunc("/users/{id}", h.GetUserByIDAdmin).Methods("GET")                      // admin only      //? completed
	router.HandleFunc("/details", h.GetUserByID).Methods("GET")                              // all users       //? completed
	router.HandleFunc("/users", h.UpdateUser).Methods("PUT")                                 // all users       //? completed
	router.HandleFunc("/users/update-email", h.UpdateEmail).Methods("PUT")                   // all users       //? completed
	router.HandleFunc("/users/change-password", h.ChangePassword).Methods("PUT")             // all users       //? completed
	router.HandleFunc("/users/delete-account", h.DeleteAccount).Methods("DELETE")            // all users       //? completed
	router.HandleFunc("/users/admin-delete-account", h.AdminDeleteAccount).Methods("DELETE") // admin only      //? completed
	router.HandleFunc("/users/login", h.Login).Methods("POST")                               // all users       //? completed
	router.HandleFunc("/users/logout", h.Logout).Methods("POST")                             // all users       //? completed
	router.HandleFunc("/users/refresh", h.Refresh).Methods("POST")                           // all users       //? completed
	router.HandleFunc("/users/reset-password", h.ResetPassword).Methods("PUT")               // all users       //? completed
}

// GetUsers handles the GET request to retrieve all users
func (h *Handler) GetUsers(w http.ResponseWriter, r *http.Request) {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Check if user is admin
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userRole, ok := claims["role"].(string)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user role in token", "")
		return
	}
	if userRole != "admin" {
		utils.WriteError(w, http.StatusForbidden, "Access denied", "Only admin users can view all users")
		return
	}

	// Get device ID from header
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Extract user ID from token for device verification
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Verify device session exists for this admin
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this admin")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	users, err := h.store.GetUsers()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get users", err.Error())
		return
	}

	response := types.UsersResponse{
		Users: users,
	}

	utils.WriteSuccess(w, http.StatusOK, "Users fetched successfully", response)
}

// GetUserByIDAdmin handles the GET request to retrieve a user by ID
func (h *Handler) GetUserByIDAdmin(w http.ResponseWriter, r *http.Request) {
	// Extract user ID from URL path parameter
	vars := mux.Vars(r)
	userIDStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "User ID is required", "")
		return
	}

	// Parse user ID from string to int
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid user ID format", "")
		return
	}

	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Check if user is admin
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userRole, ok := claims["role"].(string)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user role in token", "")
		return
	}
	if userRole != "admin" {
		utils.WriteError(w, http.StatusForbidden, "Access denied", "Only admin users can view user details")
		return
	}

	// Get device ID from header
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Extract admin user ID from token for device verification
	adminUserIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	adminUserID := int(adminUserIDFloat)

	// Verify device session exists for this admin
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(adminUserID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this admin")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(adminUserID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Get the requested user by ID
	user, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if user == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	response := types.UserResponse{
		User: *user,
	}

	utils.WriteSuccess(w, http.StatusOK, "User fetched successfully", response)
}

func (h *Handler) GetUserByID(w http.ResponseWriter, r *http.Request) {

	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Check if user is admin
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}

	// Get device ID from header
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Extract admin user ID from token for device verification
	UserIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(UserIDFloat)

	// Verify device session exists for this admin
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this admin")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Get the requested user by ID
	user, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if user == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	response := types.UserResponse{
		User: *user,
	}

	utils.WriteSuccess(w, http.StatusOK, "User fetched successfully", response)
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

	otpExpiry, err := time.ParseDuration(h.emailService.config.OTPExpiry)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Invalid OTP expiry duration", err.Error())
		return
	}

	otpModel := &types.OTP{
		Email:     req.Email,
		Code:      otp,
		ExpiresAt: time.Now().Add(otpExpiry),
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

func (h *Handler) GetDeviceSessions(w http.ResponseWriter, r *http.Request) {
	// 1. Parse Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]

	// 2. Verify and parse token
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// 3. Get device_id from header
	deviceID := r.Header.Get("X-Device-ID")

	// 4. Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// 5. Fetch devices for this user
	devices, err := h.tokenStore.GetDevicesByUserID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get device sessions", err.Error())
		return
	}

	found := false
	for i := range devices {
		if deviceID != "" && devices[i].DeviceID == deviceID {
			devices[i].IsCurrent = true
			found = true
		}
	}

	if !found {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	response := types.DeviceSessionsResponse{
		Devices: devices,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// UpdateUser handles the PUT request to update an existing user
func (h *Handler) UpdateUser(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.UpdateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate input
	if !utils.IsValidName(req.FirstName) {
		utils.WriteError(w, http.StatusBadRequest, "First name must be more than 3 characters", "")
		return
	}
	if !utils.IsValidOptionalName(req.LastName) {
		utils.WriteError(w, http.StatusBadRequest, "Last name must be empty or more than 3 characters", "")
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Update user fields
	existingUser.FirstName = req.FirstName
	existingUser.LastName = req.LastName
	existingUser.UpdatedAt = time.Now()

	// Update user in database
	err = h.store.UpdateUser(existingUser)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update user", err.Error())
		return
	}

	response := types.UserResponse{
		User: *existingUser,
	}

	utils.WriteSuccess(w, http.StatusOK, "User updated successfully", response)
}

// DeleteUser handles the DELETE request to delete an existing user
func (h *Handler) DeleteUser(w http.ResponseWriter, r *http.Request) {
	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Delete user from database
	err = h.store.DeleteUser(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete user", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "User deleted successfully", nil)
}

// Login handles the POST request to login a user
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var req types.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// 1. Validate user exists
	user, err := h.store.GetUserByEmail(req.Email)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Error fetching user", err.Error())
		return
	}
	if user == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid email or password", "")
		return
	}

	// 2. Compare password
	if err := h.authService.ComparePasswords(user.Password, req.Password); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid email or password", "")
		return
	}

	// 3. Get device info
	deviceInfo := types.DeviceInfo{
		DeviceID:    r.Header.Get("X-Device-ID"),
		DeviceName:  r.Header.Get("X-Device-Name"),
		DeviceType:  r.Header.Get("X-Device-Type"),
		DeviceOS:    r.Header.Get("X-Device-OS"),
		DeviceModel: r.Header.Get("X-Device-Model"),
		DeviceIP:    r.RemoteAddr,
	}

	if deviceInfo.DeviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// 4. Handle token creation/update
	accessToken, refreshToken, err := h.authService.Login(user, deviceInfo)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to login", err.Error())
		return
	}

	// 5. Send response
	response := types.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		User:         *user,
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// Logout handles the POST request to logout a user
func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Revoke the token
	err = h.store.RevokeToken(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to revoke token", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Logged out successfully", nil)
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

// ResetPassword handles the PUT request to reset a user's password
func (h *Handler) ResetPassword(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.ResetPasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate new password
	if !utils.IsValidPassword(req.NewPassword) {
		utils.WriteError(w, http.StatusBadRequest, "New password must be more than 6 characters", "")
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Hash new password
	hashedPassword, err := h.authService.HashPassword(req.NewPassword)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to hash password", err.Error())
		return
	}

	// Update password in database with hashed password
	err = h.store.ChangePassword(userID, hashedPassword)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to reset password", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Password reset successfully", nil)
}

// UpdateEmail handles the PUT request to update user's email
func (h *Handler) UpdateEmail(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.UpdateEmailRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate email format
	if !utils.IsValidEmail(req.Email) {
		utils.WriteError(w, http.StatusBadRequest, "Invalid email format", "")
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Check if email is already taken by another user
	if req.Email != existingUser.Email {
		emailUser, err := h.store.GetUserByEmail(req.Email)
		if err != nil {
			utils.WriteError(w, http.StatusInternalServerError, "Failed to check email availability", err.Error())
			return
		}
		if emailUser != nil {
			utils.WriteError(w, http.StatusConflict, "Email already exists", "")
			return
		}
	}

	// Update email
	existingUser.Email = req.Email
	existingUser.UpdatedAt = time.Now()

	// Update user in database
	err = h.store.UpdateEmail(userID, req.Email)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update email", err.Error())
		return
	}

	response := types.UserResponse{
		User: *existingUser,
	}

	utils.WriteSuccess(w, http.StatusOK, "Email updated successfully", response)
}

// ChangePassword handles the PUT request to change user's password
func (h *Handler) ChangePassword(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.ChangePasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Validate new password
	if !utils.IsValidPassword(req.NewPassword) {
		utils.WriteError(w, http.StatusBadRequest, "New password must be more than 6 characters", "")
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Verify current password
	if err := h.authService.ComparePasswords(existingUser.Password, req.CurrentPassword); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Current password is incorrect", "")
		return
	}

	// Hash new password
	hashedPassword, err := h.authService.HashPassword(req.NewPassword)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to hash password", err.Error())
		return
	}

	// Debug: Log the hashed password to verify it's being generated
	log.Printf("Hashed password for user %d: %s", userID, hashedPassword)

	// Update password in database with hashed password
	err = h.store.ChangePassword(userID, hashedPassword)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update password", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Password changed successfully", nil)
}

// DeleteAccount handles the DELETE request for users to delete their own account
func (h *Handler) DeleteAccount(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.DeleteAccountRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this user
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this user")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Check if user exists
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Verify password
	if err := h.authService.ComparePasswords(existingUser.Password, req.Password); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Password is incorrect", "")
		return
	}

	// Delete user from database
	err = h.store.DeleteUser(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete user", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Account deleted successfully", nil)
}

// AdminDeleteAccount handles the DELETE request for admin to delete their own account
func (h *Handler) AdminDeleteAccount(w http.ResponseWriter, r *http.Request) {
	// Parse request body
	var req types.AdminDeleteAccountRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Authentication
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || len(authHeader) < 8 || authHeader[:7] != "Bearer " {
		utils.WriteError(w, http.StatusUnauthorized, "Missing or invalid Authorization header", "")
		return
	}
	tokenString := authHeader[7:]
	token, err := h.authService.VerifyToken(tokenString)
	if err != nil || !token.Valid {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid or expired token", "")
		return
	}

	// Extract user info from token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid token claims", "")
		return
	}
	userIDFloat, ok := claims["id"].(float64)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user ID in token", "")
		return
	}
	userID := int(userIDFloat)
	userRole, ok := claims["role"].(string)
	if !ok {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid user role in token", "")
		return
	}

	// Check if user is admin
	if userRole != "admin" {
		utils.WriteError(w, http.StatusForbidden, "Access denied", "Only admin users can use this endpoint")
		return
	}

	// Verify admin creation token
	if req.AdminCreationToken != h.adminCreationToken {
		utils.WriteError(w, http.StatusUnauthorized, "Invalid admin creation token", "")
		return
	}

	// Device verification
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		utils.WriteError(w, http.StatusBadRequest, "Device ID is required", "")
		return
	}

	// Verify device session exists for this admin
	existingToken, err := h.tokenStore.GetTokenByUserIDAndDeviceID(userID, deviceID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to verify device session", err.Error())
		return
	}
	if existingToken == nil {
		utils.WriteError(w, http.StatusUnauthorized, "Device mismatch", "Device ID is not registered for this admin")
		return
	}

	// Verify that the token in the header matches the device session
	if existingToken.AccessToken != tokenString {
		utils.WriteError(w, http.StatusUnauthorized, "Token mismatch", "Token is not associated with this device")
		return
	}

	// Check if token is revoked
	if err := h.checkTokenRevocation(userID, deviceID); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Token has been revoked", "")
		return
	}

	// Get the requested user by ID
	existingUser, err := h.store.GetUserByID(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get user", err.Error())
		return
	}
	if existingUser == nil {
		utils.WriteError(w, http.StatusNotFound, "User not found", "")
		return
	}

	// Verify password
	if err := h.authService.ComparePasswords(existingUser.Password, req.Password); err != nil {
		utils.WriteError(w, http.StatusUnauthorized, "Password is incorrect", "")
		return
	}

	// Delete admin from database
	err = h.store.DeleteUser(userID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete admin", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Admin account deleted successfully", nil)
}
