package middleware

import (
	"context"
	"log"
	"mime"
	"net/http"
	"path/filepath"

	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/services/supabase"
	storage_go "github.com/supabase-community/storage-go"
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

			contentType := fileHeader.Header.Get("Content-Type")
			if contentType == "" {
				contentType = mime.TypeByExtension(filepath.Ext(fileHeader.Filename))
			}

			fileOptions := storage_go.FileOptions{
				ContentType: &contentType,
			}

			url, err := sm.supabaseService.UploadFile("images", fileHeader.Filename, file, fileOptions)
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
