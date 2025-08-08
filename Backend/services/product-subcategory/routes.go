package product_subcategory

import (
	"github.com/Asif-Faizal/Versace/services/supabase"
	product_types "github.com/Asif-Faizal/Versace/types/product"
	product_subcategory_types "github.com/Asif-Faizal/Versace/types/product-subcategory"
	subcategory_types "github.com/Asif-Faizal/Versace/types/subcategory"
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
