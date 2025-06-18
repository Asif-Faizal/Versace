build:
	@go build -o bin/gommerce cmd/main.go

test:
	@go test -v ./...

run:
	@if [ -f .env ]; then \
		export $$(cat .env | grep -v '^#' | xargs) && go run cmd/main.go; \
	else \
		echo "Error: .env file not found"; \
		exit 1; \
	fi

# Migration commands
migration-create:
	@migrate create -ext sql -dir cmd/migrate/migrations -seq $(filter-out $@,$(MAKECMDGOALS))

migrate-up:
	@go run cmd/migrate/main.go up

migrate-down:
	@go run cmd/migrate/main.go down

# Allow passing arguments to migration-create
%:
	@: