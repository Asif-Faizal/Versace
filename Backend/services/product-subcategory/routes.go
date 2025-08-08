package product_subcategory

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/supabase"
	"github.com/Asif-Faizal/Versace/services/user"
	product_types "github.com/Asif-Faizal/Versace/types/product"
	product_subcategory_types "github.com/Asif-Faizal/Versace/types/product-subcategory"
	subcategory_types "github.com/Asif-Faizal/Versace/types/subcategory"
	utils "github.com/Asif-Faizal/Versace/utils"
	"github.com/Asif-Faizal/Versace/utils/middleware"
	"github.com/gorilla/mux"
)

type Handler struct {
	store            product_subcategory_types.ProductSubcategoryStore
	productStore     product_types.ProductStore
	subcategoryStore subcategory_types.SubcategoryStore
	supabaseService  *supabase.SupabaseService
}

func NewHandler(store product_subcategory_types.ProductSubcategoryStore, productStore product_types.ProductStore, subcategoryStore subcategory_types.SubcategoryStore, supabaseService *supabase.SupabaseService) *Handler {
	return &Handler{store: store, productStore: productStore, subcategoryStore: subcategoryStore, supabaseService: supabaseService}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService, storageMiddleware *middleware.StorageMiddleware) {
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/product-subcategories", h.GetProductSubcategories).Methods("GET")
	authRouter.HandleFunc("/product-subcategories/{id}", h.GetProductSubcategoryByID).Methods("GET")
	authRouter.HandleFunc("/product-subcategories/product/{productId}", h.GetProductSubcategoriesByProductID).Methods("GET")
	authRouter.HandleFunc("/product-subcategories/subcategory/{subcategoryId}", h.GetProductSubcategoriesBySubcategoryID).Methods("GET")

	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.HandleFunc("/product-subcategories", h.CreateProductSubcategory).Methods("POST")
	adminRouter.HandleFunc("/product-subcategories/bulk", h.BulkCreateProductSubcategory).Methods("POST")
	adminRouter.HandleFunc("/product-subcategories/{id}", h.UpdateProductSubcategory).Methods("PUT")
	adminRouter.HandleFunc("/product-subcategories/{id}", h.DeleteProductSubcategory).Methods("DELETE")
}

func (h *Handler) GetProductSubcategories(w http.ResponseWriter, r *http.Request) {
	productSubcategories, err := h.store.GetProductSubcategories()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategories")
		return
	}

	response := product_subcategory_types.ProductSubcategoriesResponse{
		ProductSubcategories: productSubcategories,
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategories retrieved successfully", response)
}

func (h *Handler) GetProductSubcategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid ID")
		return
	}

	productSubcategory, err := h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusNotFound, "Product subcategory not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategory")
		return
	}

	response := product_subcategory_types.ProductSubcategoryByIDResponse{
		ProductSubcategory: *productSubcategory,
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategory retrieved successfully", response)
}

func (h *Handler) GetProductSubcategoriesByProductID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	productIDStr := vars["productId"]
	productID, err := strconv.Atoi(productIDStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid product ID")
		return
	}

	productSubcategories, err := h.store.GetProductSubcategoriesByProductID(productID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategories")
		return
	}

	response := product_subcategory_types.ProductSubcategoryByProductIDResponse{
		ProductSubcategories: productSubcategories,
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategories retrieved successfully", response)
}

func (h *Handler) GetProductSubcategoriesBySubcategoryID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	subcategoryIDStr := vars["subcategoryId"]
	subcategoryID, err := strconv.Atoi(subcategoryIDStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid subcategory ID")
		return
	}

	productSubcategories, err := h.store.GetProductSubcategoriesBySubcategoryID(subcategoryID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategories")
		return
	}

	response := product_subcategory_types.ProductSubcategoryBySubcategoryIDResponse{
		ProductSubcategories: productSubcategories,
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategories retrieved successfully", response)
}

func (h *Handler) CreateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	var request product_subcategory_types.ProductSubcategoryCreateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	// Validate that product exists
	_, err := h.productStore.GetProductByID(request.ProductID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusBadRequest, "Product not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to validate product")
		return
	}

	// Validate that subcategory exists
	_, err = h.subcategoryStore.GetSubcategoryByID(request.SubcategoryID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusBadRequest, "Subcategory not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to validate subcategory")
		return
	}

	// Check if product-subcategory relationship already exists
	existingProductSubcategories, err := h.store.GetProductSubcategoriesByProductID(request.ProductID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to check existing product subcategories")
		return
	}
	for _, existing := range existingProductSubcategories {
		if existing.SubcategoryID == request.SubcategoryID {
			utils.WriteError(w, http.StatusConflict, "Product subcategory relationship already exists")
			return
		}
	}

	productSubcategory := &product_subcategory_types.ProductSubcategory{
		ProductID:     request.ProductID,
		SubcategoryID: request.SubcategoryID,
	}

	createdProductSubcategory, err := h.store.CreateProductSubcategory(productSubcategory)
	if err != nil {
		if err.Error() == "product subcategory already exists" {
			utils.WriteError(w, http.StatusConflict, "Product subcategory already exists")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create product subcategory")
		return
	}

	response := product_subcategory_types.ProductSubcategoryCreateResponse{
		ProductSubcategory: *createdProductSubcategory,
	}

	utils.WriteSuccess(w, http.StatusCreated, "Product subcategory created successfully", response)
}

func (h *Handler) BulkCreateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	var request struct {
		ProductSubcategories []product_subcategory_types.ProductSubcategoryCreateRequest `json:"product_subcategories"`
	}
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if len(request.ProductSubcategories) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "No product subcategories provided")
		return
	}

	productSubcategories := make([]*product_subcategory_types.ProductSubcategory, len(request.ProductSubcategories))
	productSubcategoryMap := make(map[string]bool) // Track unique combinations

	for i, req := range request.ProductSubcategories {
		// Validate that product exists
		_, err := h.productStore.GetProductByID(req.ProductID)
		if err != nil {
			if err == sql.ErrNoRows {
				utils.WriteError(w, http.StatusBadRequest, fmt.Sprintf("Product with ID %d not found", req.ProductID))
				return
			}
			utils.WriteError(w, http.StatusInternalServerError, "Failed to validate product")
			return
		}

		// Validate that subcategory exists
		_, err = h.subcategoryStore.GetSubcategoryByID(req.SubcategoryID)
		if err != nil {
			if err == sql.ErrNoRows {
				utils.WriteError(w, http.StatusBadRequest, fmt.Sprintf("Subcategory with ID %d not found", req.SubcategoryID))
				return
			}
			utils.WriteError(w, http.StatusInternalServerError, "Failed to validate subcategory")
			return
		}

		// Check for duplicate combinations within the request
		key := fmt.Sprintf("%d-%d", req.ProductID, req.SubcategoryID)
		if productSubcategoryMap[key] {
			utils.WriteError(w, http.StatusBadRequest, fmt.Sprintf("Duplicate product-subcategory combination: product_id=%d, subcategory_id=%d", req.ProductID, req.SubcategoryID))
			return
		}
		productSubcategoryMap[key] = true

		productSubcategories[i] = &product_subcategory_types.ProductSubcategory{
			ProductID:     req.ProductID,
			SubcategoryID: req.SubcategoryID,
		}
	}

	err := h.store.BulkCreateProductSubcategory(productSubcategories)
	if err != nil {
		if err.Error() == "product subcategory already exists" {
			utils.WriteError(w, http.StatusConflict, err.Error())
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create product subcategories")
		return
	}

	response := product_subcategory_types.ProductSubcategoriesResponse{
		ProductSubcategories: make([]product_subcategory_types.ProductSubcategory, len(productSubcategories)),
	}
	for i, ps := range productSubcategories {
		response.ProductSubcategories[i] = *ps
	}

	utils.WriteSuccess(w, http.StatusCreated, "Product subcategories created successfully", response)
}

func (h *Handler) UpdateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid ID")
		return
	}

	var request product_subcategory_types.ProductSubcategoryUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	// Check if product subcategory exists
	existingProductSubcategory, err := h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusNotFound, "Product subcategory not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategory")
		return
	}

	// Validate that product exists
	_, err = h.productStore.GetProductByID(request.ProductID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusBadRequest, "Product not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to validate product")
		return
	}

	// Validate that subcategory exists
	_, err = h.subcategoryStore.GetSubcategoryByID(request.SubcategoryID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusBadRequest, "Subcategory not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to validate subcategory")
		return
	}

	existingProductSubcategory.ProductID = request.ProductID
	existingProductSubcategory.SubcategoryID = request.SubcategoryID

	err = h.store.UpdateProductSubcategory(existingProductSubcategory)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update product subcategory")
		return
	}

	response := product_subcategory_types.ProductSubcategoryUpdateResponse{
		ProductSubcategory: *existingProductSubcategory,
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategory updated successfully", response)
}

func (h *Handler) DeleteProductSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid ID")
		return
	}

	// Check if product subcategory exists
	_, err = h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusNotFound, "Product subcategory not found")
			return
		}
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get product subcategory")
		return
	}

	err = h.store.DeleteProductSubcategory(id)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete product subcategory")
		return
	}

	response := product_subcategory_types.ProductSubcategoryDeleteResponse{
		Message: "Product subcategory deleted successfully",
	}

	utils.WriteSuccess(w, http.StatusOK, "Product subcategory deleted successfully", response)
}
