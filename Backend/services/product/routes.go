package product

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/Asif-Faizal/Versace/services/supabase"
	"github.com/Asif-Faizal/Versace/services/user"
	"github.com/Asif-Faizal/Versace/types/product"
	"github.com/Asif-Faizal/Versace/utils"
	"github.com/Asif-Faizal/Versace/utils/middleware"
	"github.com/gorilla/mux"
)

type Handler struct {
	store           product.ProductStore
	supabaseService *supabase.SupabaseService
}

func NewHandler(store product.ProductStore, supabaseService *supabase.SupabaseService) *Handler {
	return &Handler{store: store, supabaseService: supabaseService}
}

func (h *Handler) RegisterRoutes(router *mux.Router, authService *user.AuthService, storageMiddleware *middleware.StorageMiddleware) {
	// auth routes
	authRouter := router.PathPrefix("").Subrouter()
	authRouter.Use(user.AuthMiddleware(authService))

	authRouter.HandleFunc("/product", h.GetProducts).Methods("GET")
	authRouter.HandleFunc("/product/{id}", h.GetProductByID).Methods("GET")

	// admin routes
	adminRouter := authRouter.PathPrefix("").Subrouter()
	adminRouter.Use(user.AdminAuthMiddleware)

	adminRouter.Handle("/product", storageMiddleware.Upload(http.HandlerFunc(h.CreateProduct))).Methods("POST")
	adminRouter.HandleFunc("/products/bulk", h.handleBulkCreateProduct).Methods("POST")
	adminRouter.Handle("/product/{id}", storageMiddleware.Upload(http.HandlerFunc(h.UpdateProduct))).Methods("PUT")
	adminRouter.Handle("/product/{id}", http.HandlerFunc(h.DeleteProduct)).Methods("DELETE")
	adminRouter.Handle("/product/{id}/image", storageMiddleware.Upload(http.HandlerFunc(h.UpdateProductImageURL))).Methods("PUT")
}

func (h *Handler) GetProducts(w http.ResponseWriter, r *http.Request) {
	products, err := h.store.GetProducts()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to get products", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Products fetched successfully", product.ProductsResponse{Products: products})
}

func (h *Handler) GetProductByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid product ID", err.Error())
		return
	}
	prod, err := h.store.GetProductByID(id)
	if err != nil {
		utils.WriteError(w, http.StatusNotFound, "Product not found", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Product fetched successfully", product.ProductByIDResponse{Product: *prod})
}

func (h *Handler) CreateProduct(w http.ResponseWriter, r *http.Request) {
	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found", "")
		return
	}

	name := r.FormValue("name")
	description := r.FormValue("description")
	basePriceStr := r.FormValue("basePrice")

	if name == "" || description == "" || basePriceStr == "" {
		utils.WriteError(w, http.StatusBadRequest, "Name, description, and basePrice are required", "")
		return
	}

	basePrice, err := strconv.ParseFloat(basePriceStr, 64)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid base price", err.Error())
		return
	}

	createdProduct, err := h.store.CreateProduct(&product.Product{
		Name:         name,
		Description:  description,
		BasePrice:    basePrice,
		MainImageURL: imageUrls[0],
	})

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to create product", err.Error())
		return
	}

	utils.WriteSuccess(w, http.StatusCreated, "Product created successfully", product.ProductCreateResponse{Product: *createdProduct})
}

func (h *Handler) UpdateProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid product ID", err.Error())
		return
	}

	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found", "")
		return
	}

	name := r.FormValue("name")
	description := r.FormValue("description")
	basePriceStr := r.FormValue("basePrice")

	if name == "" || description == "" || basePriceStr == "" {
		utils.WriteError(w, http.StatusBadRequest, "Name, description, and basePrice are required", "")
		return
	}

	basePrice, err := strconv.ParseFloat(basePriceStr, 64)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid base price", err.Error())
		return
	}

	updatedProduct, err := h.store.UpdateProduct(&product.Product{
		ID:           id,
		Name:         name,
		Description:  description,
		BasePrice:    basePrice,
		MainImageURL: imageUrls[0],
	})
	if err != nil {
		if err == sql.ErrNoRows {
			utils.WriteError(w, http.StatusNotFound, "Product not found", "Product with the specified ID does not exist")
		} else {
			utils.WriteError(w, http.StatusInternalServerError, "Failed to update product", err.Error())
		}
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Product updated successfully", product.ProductUpdateResponse{Product: *updatedProduct})
}

func (h *Handler) DeleteProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid product ID", err.Error())
		return
	}

	err = h.store.DeleteProduct(id)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to delete product", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Product deleted successfully", product.ProductDeleteResponse{Message: "Product deleted successfully"})
}

func (h *Handler) UpdateProductImageURL(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, "Invalid product ID", err.Error())
		return
	}

	imageUrls, ok := r.Context().Value("imageUrls").([]string)
	if !ok || len(imageUrls) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "Image URL not found", "")
		return
	}

	err = h.store.UpdateProductImageURL(id, imageUrls[0])
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "Failed to update product image URL", err.Error())
		return
	}
	utils.WriteSuccess(w, http.StatusOK, "Product image URL updated successfully", product.ProductUpdateImageURLResponse{Message: "Product image URL updated successfully"})
}
