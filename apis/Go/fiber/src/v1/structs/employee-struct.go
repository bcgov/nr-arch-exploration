package structs

import (
	"github.com/gofrs/uuid"
	"time"
)

type Employee struct {
	EmployeeID uuid.UUID `json:"employee_id"`
	FirstName  string    `json:"first_name"`
	LastName   string    `json:"last_name"`
	Email      string    `json:"email"`
	Phone      string    `json:"phone_number"`
	HireDate   time.Time `json:"hire_date"`
	Salary     float64   `json:"salary"`
}
type Tabler interface {
	TableName() string
}

// TableName overrides the table name used by User to `profiles`
func (EmployeeModel) TableName() string {
	return "employee"
}

type EmployeeModel struct {
	EmployeeID  uuid.UUID `json:"employee_id" gorm:"not null" gorm:"PrimaryKey"`
	FirstName   string    `json:"first_name" gorm:"not null"`
	LastName    string    `json:"last_name" gorm:"not null"`
	Email       string    `json:"email" gorm:"not null"`
	PhoneNumber string    `json:"phone_number" gorm:"not null"`
	HireDate    time.Time `json:"hire_date" gorm:"not null"`
	Salary      float64   `json:"salary" gorm:"null"`
}
