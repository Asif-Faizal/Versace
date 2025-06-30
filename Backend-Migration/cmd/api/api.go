package api

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/services/category"
	"github.com/Asif-Faizal/Versace/services/subcategory"
	"github.com/Asif-Faizal/Versace/services/supabase"
	"github.com/Asif-Faizal/Versace/services/user"
	"github.com/Asif-Faizal/Versace/utils/middleware"
	"github.com/gorilla/mux"
)

// APIServer represents our main server structure
// It holds the server configuration and database connection
type APIServer struct {
	listenAddress string         // The address where the server will listen (e.g., ":3000")
	db            *sql.DB        // Database connection pointer
	config        *config.Config // Server configuration
}

// NewAPIServer creates a new instance of APIServer
// It's a constructor function that initializes the server with given parameters
func NewAPIServer(listenAddress string, db *sql.DB, cfg *config.Config) *APIServer {
	return &APIServer{
		listenAddress: listenAddress,
		db:            db,
		config:        cfg,
	}
}

func (s *APIServer) Run() error {
	// Create a new router instance
	router := mux.NewRouter()

	// Use the logging middleware
	router.Use(middleware.LoggingMiddleware)

	// Initialize Storage middleware
	storageMiddleware := middleware.NewStorageMiddleware(s.config)

	// Create a subrouter for API versioning
	// All routes will be prefixed with /api/v1
	subrouter := router.PathPrefix("/api/v1").Subrouter()

	// Initialize user store
	userStore := user.NewStore(s.db)

	// Initialize auth service
	authService := user.NewAuthService(userStore)

	// Initialize email service
	emailService := user.NewEmailService(s.config)

	// Initialize supabase service
	supabaseService := supabase.NewSupabaseService(s.config)

	// Initialize user handler and register its routes
	userHandler := user.NewHandler(userStore, userStore, authService, s.config.AdminCreationToken, emailService, supabaseService)
	userHandler.RegisterRoutes(subrouter)

	// Initialize category store
	categoryStore := category.NewStore(s.db)

	// Initialize supabase service
	supabaseService = supabase.NewSupabaseService(s.config)

	// Initialize category handler and register its routes
	categoryHandler := category.NewHandler(categoryStore, supabaseService)
	categoryHandler.RegisterRoutes(subrouter, authService, storageMiddleware)

	// Initialize subcategory store
	subcategoryStore := subcategory.NewStore(s.db)

	// Initialize subcategory handler and register its routes
	subcategoryHandler := subcategory.NewHandler(subcategoryStore, categoryStore, supabaseService)
	subcategoryHandler.RegisterRoutes(subrouter, authService, storageMiddleware)

	// Example of how to use the storage middleware for a route
	// subrouter.Handle("/products", storageMiddleware.Upload(http.HandlerFunc(CreateProductHandler))).Methods("POST")

	log.Println("Starting server on", s.listenAddress)

	// Start the HTTP server and listen for incoming requests
	return http.ListenAndServe(s.listenAddress, router)
}
