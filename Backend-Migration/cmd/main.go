package main

import (
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

	server := api.NewAPIServer(cfg.GetServerAddress(), db)
	if err := server.Run(); err != nil {
		log.Fatal(err)
	}
}
