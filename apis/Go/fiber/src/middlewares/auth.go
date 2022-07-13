package middlewares

import (
	"fmt"
	fiber "github.com/gofiber/fiber/v2"
	jwtware "github.com/gofiber/jwt/v3"
	"github.com/golang-jwt/jwt/v4"
	"os"
	"reflect"
)

type RealmAccess struct {
	roles []string
}

func IsValidaToken() fiber.Handler {
	return jwtware.New(jwtware.Config{
		KeySetURL:    os.Getenv("KC_JWKS_URL"),
		ErrorHandler: jwtError,
	})
}

func jwtError(c *fiber.Ctx, err error) error {
	if err.Error() == "Missing or malformed JWT" {
		return c.Status(fiber.StatusBadRequest).
			JSON(fiber.Map{"status": "error", "message": "Missing or malformed JWT", "data": nil})
	}
	return c.Status(fiber.StatusUnauthorized).
		JSON(fiber.Map{"status": "error", "message": "Invalid or expired JWT", "data": nil})
}
func IsRolePresent(role string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		user := c.Locals("user").(*jwt.Token)
		claims := user.Claims.(jwt.MapClaims)
		realmAccess := claims["realm_access"].(map[string]interface{})
		var isRoleValid = false
		for k, v := range realmAccess {
			if k == "roles" {
				s := reflect.ValueOf(v)
				for i := 0; i < s.Len(); i++ {
					curRole := fmt.Sprintf("%v", s.Index(i))
					if curRole == role {
						isRoleValid = true
					}
				}
			}
		}
		if !isRoleValid {
			return c.Status(fiber.StatusForbidden).
				JSON(fiber.Map{"status": "Forbidden", "message": "Invalid or Missing Role.", "data": nil})
		}
		return nil
	}

}
