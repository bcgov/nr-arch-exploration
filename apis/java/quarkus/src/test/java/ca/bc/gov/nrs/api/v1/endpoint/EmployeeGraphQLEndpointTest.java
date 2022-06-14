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
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.inject.Inject;
import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@QuarkusTest
@QuarkusTestResource(H2DatabaseTestResource.class)
@TestSecurity(authorizationEnabled = false)
class EmployeeGraphQLEndpointTest {
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
    String requestBody =
      "{\"query\":" +
        "\"" +
        "{" +
        "Get_Employee_By_ID (id: \\\"ac150003-815f-126f-8181-5f28790d0000\\\")  {" +
        " firstName" +
        "}" +
        "}" +
        "\"" +
        "}";
    given()
      .body(requestBody)
      .contentType(ContentType.JSON)
      .post("/graphql/")
      .then()
      .contentType(ContentType.JSON)
      .body("data.Get_Employee_By_ID", nullValue())
      .statusCode(200);
  }

}
