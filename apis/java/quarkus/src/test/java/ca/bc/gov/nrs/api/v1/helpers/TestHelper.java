package ca.bc.gov.nrs.api.v1.helpers;

import ca.bc.gov.nrs.api.v1.model.EmployeeEntity;
import io.quarkus.test.common.QuarkusTestResource;
import io.quarkus.test.h2.H2DatabaseTestResource;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;

import javax.transaction.Transactional;
import java.time.LocalDate;

/**
 * This class contains helper methods for testing.
 */
@QuarkusTest
@QuarkusTestResource(H2DatabaseTestResource.class)
@TestSecurity(authorizationEnabled = false)
public class TestHelper {

  @Transactional(Transactional.TxType.REQUIRES_NEW)
  public void clearDatabase() {
    EmployeeEntity.deleteAll();
  }

  @Transactional(Transactional.TxType.REQUIRES_NEW)
  public EmployeeEntity createEmployee() {
    var employee = createMockEmployee();
    employee.persist();
    return employee;
  }

  public EmployeeEntity createMockEmployee() {
    var employee = new EmployeeEntity();
    employee.setFirstName("John");
    employee.setLastName("Doe");
    employee.setEmail("test@gmail.com");
    employee.setPhone("1234567890");
    employee.setHireDate(LocalDate.now());
    employee.setSalary(1000D);
    return employee;
  }
}
