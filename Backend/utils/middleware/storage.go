package middleware

import (
	"context"
	"log"
	"net/http"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/services/supabase"
)

type StorageMiddleware struct {
	supabaseService *supabase.SupabaseService
}

func NewStorageMiddleware(cfg *config.Config) *StorageMiddleware {
	return &StorageMiddleware{
		supabaseService: supabase.NewSupabaseService(cfg),
	}
}

func (sm *StorageMiddleware) Upload(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		err := r.ParseMultipartForm(10 << 20) // 10 MB
		if err != nil {
			http.Error(w, "Unable to parse form", http.StatusBadRequest)
			return
		}

		formdata := r.MultipartForm
		files := formdata.File["images"] // "images" is the key for the files

		var urls []string
		for _, fileHeader := range files {
			file, err := fileHeader.Open()
			if err != nil {
				http.Error(w, "Unable to open file", http.StatusInternalServerError)
				return
			}
			defer file.Close()

			url, err := sm.supabaseService.UploadFile(fileHeader, "images")
			if err != nil {
				log.Printf("Error uploading file to storage: %v", err)
				http.Error(w, "Unable to upload file to storage", http.StatusInternalServerError)
				return
			}
			urls = append(urls, url)
		}

		ctx := context.WithValue(r.Context(), "imageUrls", urls)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
