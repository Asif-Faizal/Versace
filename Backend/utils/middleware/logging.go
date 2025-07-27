package middleware

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

	"github.com/mattn/go-colorable"
)

var (
	colorableOutput = colorable.NewColorableStdout()
	logger          = log.New(colorableOutput, "", 0)

	reset  = "\033[0m"
	red    = "\033[31m"
	green  = "\033[32m"
	yellow = "\033[33m"
	purple = "\033[35m"
	cyan   = "\033[36m"
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

	divider := cyan + strings.Repeat("-", 80) + reset
	fmt.Fprintln(colorableOutput, divider)
	logger.Printf("%s--> %s %s%s", yellow, r.Method, r.URL.Path, reset)
	logger.Printf("%s    Host:%s %s", purple, reset, r.Host)
	logger.Printf("%s    From:%s %s", purple, reset, r.RemoteAddr)

	for name, headers := range r.Header {
		for _, h := range headers {
			logger.Printf("%s    %s:%s %s", purple, reset, name, h)
		}
	}

	if prettyBody.Len() > 0 {
		logger.Printf("%sBody:%s\n%s", purple, reset, prettyBody.String())
	}
	fmt.Fprintln(colorableOutput, divider)
}

func logResponse(rw *responseWriter) {
	var prettyBody bytes.Buffer
	if rw.body.Len() > 0 {
		if err := json.Indent(&prettyBody, rw.body.Bytes(), "", "  "); err != nil {
			prettyBody.Write(rw.body.Bytes()) // Not JSON, write as is
		}
	}

	divider := cyan + strings.Repeat("-", 80) + reset
	fmt.Fprintln(colorableOutput, divider)

	statusColor := green
	if rw.statusCode >= 400 && rw.statusCode < 500 {
		statusColor = yellow
	} else if rw.statusCode >= 500 {
		statusColor = red
	}

	logger.Printf("%s<-- %d %s%s", statusColor, rw.statusCode, http.StatusText(rw.statusCode), reset)

	for name, headers := range rw.Header() {
		for _, h := range headers {
			logger.Printf("%s    %s:%s %s", purple, reset, name, h)
		}
	}

	if prettyBody.Len() > 0 {
		logger.Printf("%sBody:%s\n%s", purple, reset, prettyBody.String())
	}
	fmt.Fprintln(colorableOutput, divider)
}
