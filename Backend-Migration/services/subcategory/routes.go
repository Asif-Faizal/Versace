package subcategory

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/user"
	categoryTypes "github.com/Asif-Faizal/Versace/types/category"
	subcategoryTypes "github.com/Asif-Faizal/Versace/types/subcategory"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/gorilla/mux"
)

type Handler struct {
	store         subcategoryTypes.SubcategoryStore
	categoryStore categoryTypes.CategoryStore
}

func NewHandler(store subcategoryTypes.SubcategoryStore, categoryStore categoryTypes.CategoryStore) *Handler {
	return &Handler{store: store, categoryStore: categoryStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService) {
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/subcategory", h.GetSubcategories).Methods("GET")
	authRouter.HandleFunc("/subcategory/{id}", h.GetSubcategoryByID).Methods("GET")
	authRouter.HandleFunc("/subcategory/category/{categoryId}", h.GetSubcategoriesByCategoryID).Methods("GET")

	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.HandleFunc("/subcategory", h.CreateSubcategory).Methods("POST")
	adminRouter.HandleFunc("/subcategory/{id}", h.UpdateSubcategory).Methods("PUT")
	adminRouter.HandleFunc("/subcategory/{id}", h.DeleteSubcategory).Methods("DELETE")
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
	var request subcategoryTypes.SubcategoryCreateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request body", err.Error())
		return
	}

	category, err := h.categoryStore.GetCategoryByID(request.CategoryID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get category", err.Error())
		return
	}

	if category == nil {
		utils.WriteError(w, http.StatusNotFound, "Category not found", "")
		return
	}

	subcategory, err := h.store.CreateSubcategory(&subcategoryTypes.Subcategory{
		Name:        request.Name,
		Description: request.Description,
		CategoryID:  request.CategoryID,
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
