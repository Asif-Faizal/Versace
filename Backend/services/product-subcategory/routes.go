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
		http.Error(w, "Failed to get product subcategories", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoriesResponse{
		ProductSubcategories: productSubcategories,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) GetProductSubcategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	productSubcategory, err := h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Product subcategory not found", http.StatusNotFound)
			return
		}
		http.Error(w, "Failed to get product subcategory", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryByIDResponse{
		ProductSubcategory: *productSubcategory,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) GetProductSubcategoriesByProductID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	productIDStr := vars["productId"]
	productID, err := strconv.Atoi(productIDStr)
	if err != nil {
		http.Error(w, "Invalid product ID", http.StatusBadRequest)
		return
	}

	productSubcategories, err := h.store.GetProductSubcategoriesByProductID(productID)
	if err != nil {
		http.Error(w, "Failed to get product subcategories", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryByProductIDResponse{
		ProductSubcategories: productSubcategories,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) GetProductSubcategoriesBySubcategoryID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	subcategoryIDStr := vars["subcategoryId"]
	subcategoryID, err := strconv.Atoi(subcategoryIDStr)
	if err != nil {
		http.Error(w, "Invalid subcategory ID", http.StatusBadRequest)
		return
	}

	productSubcategories, err := h.store.GetProductSubcategoriesBySubcategoryID(subcategoryID)
	if err != nil {
		http.Error(w, "Failed to get product subcategories", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryBySubcategoryIDResponse{
		ProductSubcategories: productSubcategories,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) CreateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	var request product_subcategory_types.ProductSubcategoryCreateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Validate that product exists
	_, err := h.productStore.GetProductByID(request.ProductID)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Product not found", http.StatusBadRequest)
			return
		}
		http.Error(w, "Failed to validate product", http.StatusInternalServerError)
		return
	}

	// Validate that subcategory exists
	_, err = h.subcategoryStore.GetSubcategoryByID(request.SubcategoryID)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Subcategory not found", http.StatusBadRequest)
			return
		}
		http.Error(w, "Failed to validate subcategory", http.StatusInternalServerError)
		return
	}

	// Check if product-subcategory relationship already exists
	existingProductSubcategories, err := h.store.GetProductSubcategoriesByProductID(request.ProductID)
	if err != nil {
		http.Error(w, "Failed to check existing product subcategories", http.StatusInternalServerError)
		return
	}
	for _, existing := range existingProductSubcategories {
		if existing.SubcategoryID == request.SubcategoryID {
			http.Error(w, "Product subcategory relationship already exists", http.StatusConflict)
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
			http.Error(w, "Product subcategory already exists", http.StatusConflict)
			return
		}
		http.Error(w, "Failed to create product subcategory", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryCreateResponse{
		ProductSubcategory: *createdProductSubcategory,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) BulkCreateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	var request struct {
		ProductSubcategories []product_subcategory_types.ProductSubcategoryCreateRequest `json:"product_subcategories"`
	}
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if len(request.ProductSubcategories) == 0 {
		http.Error(w, "No product subcategories provided", http.StatusBadRequest)
		return
	}

	productSubcategories := make([]*product_subcategory_types.ProductSubcategory, len(request.ProductSubcategories))
	productSubcategoryMap := make(map[string]bool) // Track unique combinations

	for i, req := range request.ProductSubcategories {
		// Validate that product exists
		_, err := h.productStore.GetProductByID(req.ProductID)
		if err != nil {
			if err == sql.ErrNoRows {
				http.Error(w, fmt.Sprintf("Product with ID %d not found", req.ProductID), http.StatusBadRequest)
				return
			}
			http.Error(w, "Failed to validate product", http.StatusInternalServerError)
			return
		}

		// Validate that subcategory exists
		_, err = h.subcategoryStore.GetSubcategoryByID(req.SubcategoryID)
		if err != nil {
			if err == sql.ErrNoRows {
				http.Error(w, fmt.Sprintf("Subcategory with ID %d not found", req.SubcategoryID), http.StatusBadRequest)
				return
			}
			http.Error(w, "Failed to validate subcategory", http.StatusInternalServerError)
			return
		}

		// Check for duplicate combinations within the request
		key := fmt.Sprintf("%d-%d", req.ProductID, req.SubcategoryID)
		if productSubcategoryMap[key] {
			http.Error(w, fmt.Sprintf("Duplicate product-subcategory combination: product_id=%d, subcategory_id=%d", req.ProductID, req.SubcategoryID), http.StatusBadRequest)
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
			http.Error(w, err.Error(), http.StatusConflict)
			return
		}
		http.Error(w, "Failed to create product subcategories", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoriesResponse{
		ProductSubcategories: make([]product_subcategory_types.ProductSubcategory, len(productSubcategories)),
	}
	for i, ps := range productSubcategories {
		response.ProductSubcategories[i] = *ps
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) UpdateProductSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	var request product_subcategory_types.ProductSubcategoryUpdateRequest
	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Check if product subcategory exists
	existingProductSubcategory, err := h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Product subcategory not found", http.StatusNotFound)
			return
		}
		http.Error(w, "Failed to get product subcategory", http.StatusInternalServerError)
		return
	}

	// Validate that product exists
	_, err = h.productStore.GetProductByID(request.ProductID)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Product not found", http.StatusBadRequest)
			return
		}
		http.Error(w, "Failed to validate product", http.StatusInternalServerError)
		return
	}

	// Validate that subcategory exists
	_, err = h.subcategoryStore.GetSubcategoryByID(request.SubcategoryID)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Subcategory not found", http.StatusBadRequest)
			return
		}
		http.Error(w, "Failed to validate subcategory", http.StatusInternalServerError)
		return
	}

	existingProductSubcategory.ProductID = request.ProductID
	existingProductSubcategory.SubcategoryID = request.SubcategoryID

	err = h.store.UpdateProductSubcategory(existingProductSubcategory)
	if err != nil {
		http.Error(w, "Failed to update product subcategory", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryUpdateResponse{
		ProductSubcategory: *existingProductSubcategory,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (h *Handler) DeleteProductSubcategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid ID", http.StatusBadRequest)
		return
	}

	// Check if product subcategory exists
	_, err = h.store.GetProductSubcategoryByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "Product subcategory not found", http.StatusNotFound)
			return
		}
		http.Error(w, "Failed to get product subcategory", http.StatusInternalServerError)
		return
	}

	err = h.store.DeleteProductSubcategory(id)
	if err != nil {
		http.Error(w, "Failed to delete product subcategory", http.StatusInternalServerError)
		return
	}

	response := product_subcategory_types.ProductSubcategoryDeleteResponse{
		Message: "Product subcategory deleted successfully",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}
