package main

import (
	"database/sql"
	"log"

	"github.com/Asif-Faizal/Versace/cmd/api"
	"github.com/Asif-Faizal/Versace/config"
	"github.com/Asif-Faizal/Versace/db"
	"github.com/go-sql-driver/mysql"
)

func main() {
	cfg, err := config.InitConfig()
	if err != nil {
		log.Fatal(err)
	}

	db, err := db.NewDB(mysql.Config{
		User:                 cfg.DBUser,
		Passwd:               cfg.DBPassword,
		Net:                  "tcp",
		Addr:                 cfg.DBAddress,
		DBName:               cfg.DBName,
		AllowNativePasswords: true,
		ParseTime:            true,
	})
	if err != nil {
		log.Fatal(err)
	}
	InitializeDB(db)
	server := api.NewAPIServer(cfg.GetServerAddress(), db, cfg)
	if err := server.Run(); err != nil {
		log.Fatal(err)
	}
}

func InitializeDB(db *sql.DB) {
	err := db.Ping()
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Database connected successfully")
}
