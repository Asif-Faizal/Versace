package category

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/supabase"
	"github.com/Asif-Faizal/Versace/services/user"
	types "github.com/Asif-Faizal/Versace/types/category"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/Asif-Faizal/Versace/utils/middleware"
	"github.com/gorilla/mux"
)

type Handler struct {
	store           types.CategoryStore
	supabaseService *supabase.SupabaseService
}

func NewHandler(store types.CategoryStore, supabaseService *supabase.SupabaseService) *Handler {
	return &Handler{store: store, supabaseService: supabaseService}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService, storageMiddleware *middleware.StorageMiddleware) {
	// Authenticated routes
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/categories", h.GetCategories).Methods("GET")
	authRouter.HandleFunc("/categories/{id}", h.GetCategoryByID).Methods("GET")

	// Admin routes
	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.Handle("/categories", storageMiddleware.Upload(http.HandlerFunc(h.CreateCategory))).Methods("POST")
	adminRouter.HandleFunc("/categories/bulk", h.handleBulkCreateCategory).Methods("POST")
	adminRouter.HandleFunc("/categories/{id}", h.UpdateCategory).Methods("PUT")
	adminRouter.HandleFunc("/categories/{id}", h.DeleteCategory).Methods("DELETE")
	adminRouter.Handle("/categories/{id}/image", storageMiddleware.Upload(http.HandlerFunc(h.UpdateCategoryImage))).Methods("POST")
}

func (h *Handler) GetCategories(w http.ResponseWriter, r *http.Request) {
	categories, err := h.store.GetCategories()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve categories")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Categories retrieved successfully", categories)
}

func (h *Handler) GetCategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID")
		return
	}

	category, err := h.store.GetCategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Category not found")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category retrieved successfully", category)
}

func (h *Handler) CreateCategory(w http.ResponseWriter, r *http.Request) {
	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found")
		return
	}

	name := r.FormValue("name")
	description := r.FormValue("description")

	// Simple validation
	if name == "" {
		utils.WriteError(w, http.StatusBadRequest, "Category name is required")
		return
	}

	category := &types.Category{
		Name:        name,
		Description: description,
		ImageURL:    imageUrls[0], // Using the first image URL
	}

	createdCategory, err := h.store.CreateCategory(category)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create category")
		return
	}

	utils.WriteSuccess(w, http.StatusCreated, "Category created successfully", createdCategory)
}

func (h *Handler) UpdateCategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID")
		return
	}

	var payload types.CategoryUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}

	// Simple validation
	if payload.Name == "" {
		utils.WriteError(w, http.StatusBadRequest, "Category name is required")
		return
	}

	category := &types.Category{
		ID:          id,
		Name:        payload.Name,
		Description: payload.Description,
	}

	if err := h.store.UpdateCategory(category); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update category")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category updated successfully", category)
}

func (h *Handler) UpdateCategoryImage(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID")
		return
	}

	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found")
		return
	}

	category, err := h.store.GetCategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Category not found")
		return
	}

	if category.ImageURL != "" {
		fileName, err := supabase.GetFileNameFromURL(category.ImageURL)
		if err != nil {
			utils.WriteError(w, http.StatusInternalServerError, "Failed to parse old image URL")
			return
		}

		if err := h.supabaseService.DeleteFile("images", fileName); err != nil {
			log.Printf("Failed to delete old image from storage: %v", err)
		}
	}

	newImageURL := imageUrls[0]
	if err := h.store.UpdateCategoryImageURL(id, newImageURL); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update category image URL")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category image updated successfully", map[string]string{"imageUrl": newImageURL})
}

func (h *Handler) DeleteCategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID")
		return
	}

	if err := h.store.DeleteCategory(id); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete category")
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Category deleted successfully", nil)
}
