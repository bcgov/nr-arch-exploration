package routes

import (
	"github.com/gofiber/fiber/v2"
	"github.com/iit-arch/fiber-crud/v1/services"
)

func EmployeeRoutes(app fiber.Router) {
	r := app.Group("/api/v1")
	r.Get("/employees", services.GetEmployees)
}
