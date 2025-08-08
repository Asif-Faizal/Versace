package category

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strconv"
	"strings"

	"github.com/Asif-Faizal/Versace/types/category"
	"github.com/Asif-Faizal/Versace/utils"
)

// handleBulkCreateCategory expects multipart/form-data with repeated, indexed fields:
// name[0], description[0], image[0]; name[1], description[1], image[1]; ...
// Also supports name_0 / description_0 / image_0
func (h *Handler) handleBulkCreateCategory(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseMultipartForm(100 << 20); err != nil { // 100MB
		utils.WriteError(w, http.StatusBadRequest, "failed to parse multipart form")
		return
	}

	// Find all indexes present in form values
	indexSet := map[int]struct{}{}
	reBracket := regexp.MustCompile(`^(name|description|image)\[(\d+)\]$`)
	reUnderscore := regexp.MustCompile(`^(name|description|image)_(\d+)$`)
	for key := range r.MultipartForm.Value {
		if m := reBracket.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
			continue
		}
		if m := reUnderscore.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
		}
	}
	for key := range r.MultipartForm.File {
		if m := reBracket.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
			continue
		}
		if m := reUnderscore.FindStringSubmatch(key); len(m) == 3 {
			if idx, err := strconv.Atoi(m[2]); err == nil {
				indexSet[idx] = struct{}{}
			}
		}
	}

	var toCreate []*category.Category
	// Helper to fetch a single value for key or fallback
	getVal := func(bracketKey, underscoreKey string) string {
		if v, ok := r.MultipartForm.Value[bracketKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		if v, ok := r.MultipartForm.Value[underscoreKey]; ok && len(v) > 0 {
			return strings.TrimSpace(v[0])
		}
		return ""
	}

	for idx := range indexSet {
		name := getVal(fmt.Sprintf("name[%d]", idx), fmt.Sprintf("name_%d", idx))
		desc := getVal(fmt.Sprintf("description[%d]", idx), fmt.Sprintf("description_%d", idx))
		if name == "" {
			continue
		}

		// Get file header for this index
		var fhKey string
		if _, ok := r.MultipartForm.File[fmt.Sprintf("image[%d]", idx)]; ok {
			fhKey = fmt.Sprintf("image[%d]", idx)
		} else if _, ok := r.MultipartForm.File[fmt.Sprintf("image_%d", idx)]; ok {
			fhKey = fmt.Sprintf("image_%d", idx)
		} else {
			// also allow "images" array aligned by order if provided
			fhKey = ""
		}

		var imageURL string
		if fhKey != "" {
			fhs := r.MultipartForm.File[fhKey]
			if len(fhs) > 0 {
				// Use original upload API to preserve bytes & content-type
				url, err := h.supabaseService.UploadFile(fhs[0], "images")
				if err != nil {
					log.Printf("bulk category: upload failed for index %d key %s: %v", idx, fhKey, err)
					continue
				}
				imageURL = url
			}
		}

		// If not found by indexed key, try consuming from generic "images" in order
		if imageURL == "" {
			if arr, ok := r.MultipartForm.File["images"]; ok && len(arr) > 0 {
				// Map by same index position if available
				if idx >= 0 && idx < len(arr) {
					url, err := h.supabaseService.UploadFile(arr[idx], "images")
					if err == nil {
						imageURL = url
					} else {
						log.Printf("bulk category: upload failed from images[] for index %d: %v", idx, err)
					}
				}
			}
		}

		if imageURL == "" {
			log.Printf("bulk category: missing image for index %d (no image[i] or images[] match)", idx)
			continue
		}

		toCreate = append(toCreate, &category.Category{
			Name:        name,
			Description: desc,
			ImageURL:    imageURL,
		})
	}

	if len(toCreate) == 0 {
		utils.WriteError(w, http.StatusBadRequest, "no categories to create")
		return
	}

	if err := h.store.BulkCreateCategory(toCreate); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, "failed to create categories")
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]int{"created": len(toCreate)})
}
