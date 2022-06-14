package ca.bc.gov.nrs.api.v1.endpoint;

import ca.bc.gov.nrs.api.v1.model.EmployeeEntity;
import org.eclipse.microprofile.graphql.*;

import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;
import javax.ws.rs.PathParam;
import java.util.Optional;
import java.util.UUID;

@GraphQLApi
@ApplicationScoped
@RolesAllowed("**")
public class EmployeeGraphQLEndpoint {

  @Query("Get_Employee_By_ID")
  @Description("Get Employee By ID.")
  @Transactional
  @RolesAllowed("**")
  public EmployeeEntity getEmployeeByID(@Name("id") UUID id) {
    return EmployeeEntity.findById(id);
  }

  @Mutation
  @Transactional
  public EmployeeEntity createEmployee(EmployeeEntity employeeEntity) throws GraphQLException {
    if (employeeEntity == null) {
      throw new GraphQLException("{\"message\":\" employee cannot be null in Create.\"}");
    }
    if (employeeEntity.getEmployeeId() != null) {
      throw new GraphQLException("{\"message\":\" employee Id is not allowed in Create.\"}");
    }
    employeeEntity.persist();
    return employeeEntity;
  }

  @Mutation
  @Transactional
  public EmployeeEntity updateEmployee(@Name("id") UUID id, EmployeeEntity employeeEntity) throws GraphQLException {
    if (id == null || employeeEntity.getEmployeeId() == null || !id.equals(employeeEntity.getEmployeeId())) {
      throw new GraphQLException("{\"message\":\" employee Id can not be null in Update.\"}");
    }
    Optional<EmployeeEntity> entityOptional = EmployeeEntity.findByIdOptional(id);
    if (entityOptional.isEmpty()) {
      throw new GraphQLException("""
        {"message":" employee can not be found with ID %s."}
        """.formatted(id));
    }
    EmployeeEntity entity = entityOptional.get();
    entity.setFirstName(employeeEntity.getFirstName());
    entity.setLastName(employeeEntity.getLastName());
    entity.setEmail(employeeEntity.getEmail());
    entity.setPhone(employeeEntity.getPhone());
    entity.setHireDate(employeeEntity.getHireDate());
    entity.setSalary(employeeEntity.getSalary());
    EmployeeEntity.persist(entity);
    return entity;
  }

  @Mutation
  @Transactional
  public EmployeeEntity deleteEmployee(@PathParam("id") UUID id) throws GraphQLException {
    if (id == null) {
      throw new GraphQLException("{\"message\":\" employee Id can not be null in Delete.\"}");
    }
    Optional<EmployeeEntity> entityOptional = EmployeeEntity.findByIdOptional(id);
    if (entityOptional.isEmpty()) {
      throw new GraphQLException("""
        {"message":" employee can not be found with ID %s."}
        """.formatted(id));
    }
    EmployeeEntity.deleteById(entityOptional.get().getEmployeeId());
    return entityOptional.get();
  }
}
