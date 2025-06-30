package subcategory

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/supabase"
	"github.com/Asif-Faizal/Versace/services/user"
	categoryTypes "github.com/Asif-Faizal/Versace/types/category"
	subcategoryTypes "github.com/Asif-Faizal/Versace/types/subcategory"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/Asif-Faizal/Versace/utils/middleware"
	"github.com/gorilla/mux"
)

type Handler struct {
	store           subcategoryTypes.SubcategoryStore
	categoryStore   categoryTypes.CategoryStore
	supabaseService *supabase.SupabaseService
}

func NewHandler(store subcategoryTypes.SubcategoryStore, categoryStore categoryTypes.CategoryStore, supabaseService *supabase.SupabaseService) *Handler {
	return &Handler{store: store, categoryStore: categoryStore, supabaseService: supabaseService}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService, storageMiddleware *middleware.StorageMiddleware) {
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/subcategory", h.GetSubcategories).Methods("GET")
	authRouter.HandleFunc("/subcategory/{id}", h.GetSubcategoryByID).Methods("GET")
	authRouter.HandleFunc("/subcategory/category/{categoryId}", h.GetSubcategoriesByCategoryID).Methods("GET")

	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.Handle("/subcategory", storageMiddleware.Upload(http.HandlerFunc(h.CreateSubcategory))).Methods("POST")
	adminRouter.HandleFunc("/subcategory/{id}", h.UpdateSubcategory).Methods("PUT")
	adminRouter.HandleFunc("/subcategory/{id}", h.DeleteSubcategory).Methods("DELETE")
	adminRouter.Handle("/subcategory/{id}/image", storageMiddleware.Upload(http.HandlerFunc(h.UpdateSubcategoryImage))).Methods("POST")
}

func (h *Handler) GetSubcategories(w http.ResponseWriter, r *http.Request) {
	subcategories, err := h.store.GetSubcategories()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve subcategories", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Subcategories retrieved successfully", subcategoryTypes.SubcategoriesResponse{Subcategories: subcategories})
}

func (h *Handler) GetSubcategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing subcategory ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid subcategory ID", err.Error())
		return
	}

	subcategory, err := h.store.GetSubcategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Subcategory not found", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Subcategory retrieved successfully", subcategoryTypes.SubcategoryByIDResponse{Subcategory: *subcategory})
}

func (h *Handler) GetSubcategoriesByCategoryID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	catIDStr, ok := vars["categoryId"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing category ID", "")
		return
	}

	catID, err := strconv.Atoi(catIDStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID", err.Error())
		return
	}

	subcategories, err := h.store.GetSubcategoriesByCategoryID(catID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve subcategories", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Subcategories retrieved successfully", subcategoryTypes.SubcategoryByCategoryIDResponse{Subcategories: subcategories})
}

func (h *Handler) CreateSubcategory(w http.ResponseWriter, r *http.Request) {
	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found", "")
		return
	}

	name := r.FormValue("name")
	description := r.FormValue("description")
	categoryIDStr := r.FormValue("categoryId")

	if name == "" || categoryIDStr == "" {
		utils.WriteError(w, http.StatusBadRequest, "Name and categoryId are required", "")
		return
	}

	categoryID, err := strconv.Atoi(categoryIDStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid category ID", err.Error())
		return
	}

	_, err = h.categoryStore.GetCategoryByID(categoryID)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Category not found", err.Error())
		return
	}

	subcategory, err := h.store.CreateSubcategory(&subcategoryTypes.Subcategory{
		Name:        name,
		Description: description,
		ImageURL:    imageUrls[0],
		CategoryID:  categoryID,
	})
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create subcategory", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusCreated, "Subcategory created successfully", subcategoryTypes.SubcategoryCreateResponse{Subcategory: *subcategory})
}

func (h *Handler) UpdateSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing subcategory ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid subcategory ID", err.Error())
		return
	}

	var request subcategoryTypes.SubcategoryUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	subcategory := &subcategoryTypes.Subcategory{
		ID:          id,
		Name:        request.Name,
		Description: request.Description,
		CategoryID:  request.CategoryID,
	}

	err = h.store.UpdateSubcategory(subcategory)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update subcategory", err.Error())
		return
	}

	updatedSubcategory, err := h.store.GetSubcategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to retrieve updated subcategory", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Subcategory updated successfully", subcategoryTypes.SubcategoryUpdateResponse{Subcategory: *updatedSubcategory})
}

func (h *Handler) UpdateSubcategoryImage(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing subcategory ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid subcategory ID", err.Error())
		return
	}

	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found", "")
		return
	}

	subcategory, err := h.store.GetSubcategoryByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Subcategory not found", err.Error())
		return
	}

	if subcategory.ImageURL != "" {
		fileName, err := supabase.GetFileNameFromURL(subcategory.ImageURL)
		if err != nil {
			utils.WriteError(w, http.StatusInternalServerError, "Failed to parse old image URL", err.Error())
			return
		}

		if err := h.supabaseService.DeleteFile("images", fileName); err != nil {
			log.Printf("Failed to delete old image from storage: %v", err)
		}
	}

	newImageURL := imageUrls[0]
	if err := h.store.UpdateSubcategoryImageURL(id, newImageURL); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update subcategory image URL", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Subcategory image updated successfully", map[string]string{"imageUrl": newImageURL})
}

func (h *Handler) DeleteSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr, ok := vars["id"]
	if !ok {
		utils.WriteError(w, http.StatusBadRequest, "Missing subcategory ID", "")
		return
	}

	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid subcategory ID", err.Error())
		return
	}

	err = h.store.DeleteSubcategory(id)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete subcategory", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusOK, "Subcategory deleted successfully", subcategoryTypes.SubcategoryDeleteResponse{Message: "Subcategory deleted successfully"})
}
