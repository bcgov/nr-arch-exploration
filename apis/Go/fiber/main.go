package main

import (
	"bytes"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/csrf"
	"github.com/gofiber/fiber/v2/middleware/favicon"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/gofiber/helmet/v2"
	"github.com/iit-arch/fiber-crud/database"
	"github.com/joho/godotenv"
	"log"
)

var (
	buf    bytes.Buffer
	sysLog = log.New(&buf, "log: ", log.Lshortfile)
)

func main() {
	envErr := godotenv.Load("../../.env")
	if envErr != nil {
		sysLog.Fatalf("Error: %v", envErr)
	}
	dbErr := database.Connect()
	if dbErr != nil {
		err := fmt.Errorf("error: %v", dbErr)
		fmt.Println(err.Error())
		sysLog.Fatalf("Error: %v", dbErr)
	}
	app := fiber.New(fiber.Config{})
	app.Use(favicon.New())
	app.Use(recover.New())
	app.Use(cors.New())
	app.Use(csrf.New())
	app.Use(helmet.New())
	app.Use(logger.New(logger.Config{
		TimeFormat: "2006-01-02T15:04:05",
		TimeZone:   "America/Vancouver",
	}))
	app.Get("/health", HealthCheck)
	// 404 Handler, the last handler to be executed
	app.Use(func(c *fiber.Ctx) error {
		return c.SendStatus(404) // => 404 "Not Found"
	})
	err := app.Listen(":3000")
	if err != nil {
		sysLog.Fatalf("Error: %v", err)
		return
	}
}

func HealthCheck(c *fiber.Ctx) error {
	sqlDB, err := database.DBConn.DB()
	if err != nil {
		sysLog.Printf("Error: %v", err)
		return c.Status(500).SendString("Database connection error")
	}
	res := map[string]interface{}{
		"data": "Server is up and running",
		"db":   sqlDB.Ping(),
	}
	if err := c.JSON(res); err != nil {
		return err
	}
	return nil
}
