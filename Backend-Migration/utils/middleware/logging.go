package middleware

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
)

type responseWriter struct {
	http.ResponseWriter
	statusCode int
	body       *bytes.Buffer
}

func newResponseWriter(w http.ResponseWriter) *responseWriter {
	return &responseWriter{
		ResponseWriter: w,
		statusCode:     http.StatusOK,
		body:           new(bytes.Buffer),
	}
}

func (rw *responseWriter) WriteHeader(statusCode int) {
	rw.statusCode = statusCode
	rw.ResponseWriter.WriteHeader(statusCode)
}

func (rw *responseWriter) Write(p []byte) (int, error) {
	rw.body.Write(p)
	return rw.ResponseWriter.Write(p)
}

func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var requestBody bytes.Buffer
		if r.Body != nil {
			// Read the body
			_, err := io.Copy(&requestBody, r.Body)
			if err != nil {
				log.Printf("Error reading request body: %v", err)
				http.Error(w, "could not read request body", http.StatusInternalServerError)
				return
			}
			// Restore the body so it can be read again
			r.Body = io.NopCloser(bytes.NewReader(requestBody.Bytes()))
		}

		logRequest(r, requestBody.Bytes())

		rw := newResponseWriter(w)
		next.ServeHTTP(rw, r)

		logResponse(rw)
	})
}

func logRequest(r *http.Request, body []byte) {
	var prettyBody bytes.Buffer
	if len(body) > 0 {
		if err := json.Indent(&prettyBody, body, "", "  "); err != nil {
			prettyBody.Write(body) // Not JSON, write as is
		}
	}

	fmt.Println(strings.Repeat("-", 80))
	log.Printf("--> %s %s", r.Method, r.URL.Path)
	log.Printf("    Host: %s", r.Host)
	log.Printf("    From: %s", r.RemoteAddr)
	for name, headers := range r.Header {
		for _, h := range headers {
			log.Printf("    %s: %s", name, h)
		}
	}
	if prettyBody.Len() > 0 {
		log.Printf("Body:\n%s", prettyBody.String())
	}
	fmt.Println(strings.Repeat("-", 80))
}

func logResponse(rw *responseWriter) {
	var prettyBody bytes.Buffer
	if rw.body.Len() > 0 {
		if err := json.Indent(&prettyBody, rw.body.Bytes(), "", "  "); err != nil {
			prettyBody.Write(rw.body.Bytes()) // Not JSON, write as is
		}
	}

	fmt.Println(strings.Repeat("-", 80))
	log.Printf("<-- %d %s", rw.statusCode, http.StatusText(rw.statusCode))
	for name, headers := range rw.Header() {
		for _, h := range headers {
			log.Printf("    %s: %s", name, h)
		}
	}
	if prettyBody.Len() > 0 {
		log.Printf("Body:\n%s", prettyBody.String())
	}
	fmt.Println(strings.Repeat("-", 80))
}
