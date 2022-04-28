package ca.bc.gov.nrs.api.v1.endpoint;

import ca.bc.gov.nrs.api.v1.helpers.TestHelper;
import io.quarkus.test.common.QuarkusTestResource;
import io.quarkus.test.h2.H2DatabaseTestResource;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.security.TestSecurity;
import io.restassured.RestAssured;
import io.restassured.filter.log.LogDetail;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.inject.Inject;
import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.equalTo;

@QuarkusTest
@QuarkusTestResource(H2DatabaseTestResource.class)
@TestSecurity(authorizationEnabled = false)
class EmployeeEndpointTest {
  @Inject
  TestHelper testHelper;

  @BeforeAll
  static void beforeAll() {
    RestAssured.filters(new RequestLoggingFilter(), new ResponseLoggingFilter());
  }

  @BeforeEach
  void beforeEach() {
    testHelper.clearDatabase();
  }

  @Test
  void getEmployeeByID_whenInvalidIDGiven_shouldRespond404() {
    given().header("Content-type", "application/json").when().get("/api/v1/employee/9648afca-b7fe-4181-90f3-f06f293e211d").then().statusCode(404);
  }


  @Test
  void getEmployeeByID_whenIDExistInDB_shouldRespond200() {
    var employee = testHelper.createEmployee();
    given().header("Content-type", "application/json").when().get("/api/v1/employee/{employeeId}", employee.getEmployeeId()).then().log().ifValidationFails(LogDetail.BODY).statusCode(200);
  }

  @Test
  void createEmployee_whenGivenNoPayload_shouldRespond400() {
    given().header("Content-type", "application/json").and().body(new byte[0]).when().post("/api/v1/employee").then().log().ifValidationFails(LogDetail.BODY).statusCode(400);
  }

  @Test
  void createEmployee_whenGivenPayloadWithID_shouldRespond400() {
    var employee = testHelper.createMockEmployee();
    employee.setEmployeeId(UUID.randomUUID());
    given().header("Content-type", "application/json").and().body(employee).when().post("/api/v1/employee").then().log().ifValidationFails(LogDetail.BODY).statusCode(400);
  }

  @Test
  void createEmployee_whenGivenValidPayload_shouldRespond201() {
    var employee = testHelper.createMockEmployee();
    given().header("Content-type", "application/json").and().body(employee).when().post("/api/v1/employee").then().log().ifValidationFails(LogDetail.BODY).statusCode(201);
  }

  @Test
  void updateEmployee_whenGivenValidPayload_shouldRespond200() {
    var empInDB = testHelper.createEmployee(); // first create the employee
    var employee = testHelper.createMockEmployee();
    employee.setEmployeeId(empInDB.getEmployeeId());
    employee.setFirstName("Updated");
    given().header("Content-type", "application/json").and().body(employee).when().put("/api/v1/employee/{employeeId}", empInDB.getEmployeeId()).then().log().ifValidationFails(LogDetail.BODY).statusCode(200).and().body("firstName", equalTo("Updated"));
  }

  @Test
  void deleteEmployee_whenGivenValidPayload_shouldRespond200() {
    var empInDB = testHelper.createEmployee(); // first create the employee
    given().header("Content-type", "application/json").when().delete("/api/v1/employee/{employeeId}", empInDB.getEmployeeId()).then().log().ifValidationFails(LogDetail.BODY).statusCode(204);
  }
}
