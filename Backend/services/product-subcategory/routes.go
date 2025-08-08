package product_subcategory

import (
	"net/http"

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

func (h *Handler) GetProductSubcategories(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) GetProductSubcategoryByID(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) GetProductSubcategoriesByProductID(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) GetProductSubcategoriesBySubcategoryID(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) CreateProductSubcategory(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) BulkCreateProductSubcategory(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) UpdateProductSubcategory(w http.ResponseWriter, r *http.Request) {}

func (h *Handler) DeleteProductSubcategory(w http.ResponseWriter, r *http.Request) {}
