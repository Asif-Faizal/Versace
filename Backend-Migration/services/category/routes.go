package category

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/user"
	types "github.com/Asif-Faizal/Versace/types/category"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/gorilla/mux"
)

type Handler struct {
	store types.CategoryStore
}

func NewHandler(store types.CategoryStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService) {
	// Authenticated routes
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/categories", h.GetCategories).Methods("GET")
	authRouter.HandleFunc("/categories/{id}", h.GetCategoryByID).Methods("GET")

	// Admin routes
	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.HandleFunc("/categories", h.CreateCategory).Methods("POST")
	adminRouter.HandleFunc("/categories/{id}", h.UpdateCategory).Methods("PUT")
	adminRouter.HandleFunc("/categories/{id}", h.DeleteCategory).Methods("DELETE")
}

func (h *Handler) GetCategories(w http.ResponseWriter, r *http.Request) {
	categories, err := h.store.GetCategories()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve categories", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Categories retrieved successfully", categories)
}

func (h *Handler) GetCategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID", err.Error())
		return
	}

	category, err := h.store.GetCategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Category not found", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category retrieved successfully", category)
}

func (h *Handler) CreateCategory(w http.ResponseWriter, r *http.Request) {
	var payload types.CategoryCreateRequest
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Simple validation
	if payload.Name == "" {
		utils.WriteError(w, http.StatusBadRequest, "Category name is required", "")
		return
	}

	category := &types.Category{
		Name:        payload.Name,
		Description: payload.Description,
	}

	createdCategory, err := h.store.CreateCategory(category)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create category", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusCreated, "Category created successfully", createdCategory)
}

func (h *Handler) UpdateCategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID", err.Error())
		return
	}

	var payload types.CategoryUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload", err.Error())
		return
	}

	// Simple validation
	if payload.Name == "" {
		utils.WriteError(w, http.StatusBadRequest, "Category name is required", "")
		return
	}

	category := &types.Category{
		ID:          id,
		Name:        payload.Name,
		Description: payload.Description,
	}

	if err := h.store.UpdateCategory(category); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update category", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category updated successfully", category)
}

func (h *Handler) DeleteCategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID", err.Error())
		return
	}

	if err := h.store.DeleteCategory(id); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete category", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category deleted successfully", nil)
}
