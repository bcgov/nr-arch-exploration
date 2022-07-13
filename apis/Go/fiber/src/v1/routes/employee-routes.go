package routes

import (
	"github.com/gofiber/fiber/v2"
	"github.com/nr-arch-templates/fiber-crud/src/middlewares"
	"github.com/nr-arch-templates/fiber-crud/src/v1/services"
)

func EmployeeRoutes(app fiber.Router) {
	r := app.Group("/api/v1")

	r.Get("/employees", middlewares.IsValidaToken(), middlewares.IsRolePresent("offline_access"), services.GetEmployees)
}
