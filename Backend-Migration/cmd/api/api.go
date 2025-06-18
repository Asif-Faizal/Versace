package api

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/services/user"
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

	// Create a subrouter for API versioning
	// All routes will be prefixed with /api/v1
	subrouter := router.PathPrefix("/api/v1").Subrouter()

	// Initialize user handler and register its routes
	userHandler := user.NewHandler(nil, s.config.AdminCreationToken)
	userHandler.RegisterRoutes(subrouter)

	log.Println("Starting server on", s.listenAddress)

	// Start the HTTP server and listen for incoming requests
	return http.ListenAndServe(s.listenAddress, router)
}
