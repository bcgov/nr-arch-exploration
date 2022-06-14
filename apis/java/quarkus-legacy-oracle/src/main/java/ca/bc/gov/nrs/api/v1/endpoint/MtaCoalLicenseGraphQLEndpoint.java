package ca.bc.gov.nrs.api.v1.endpoint;

import ca.bc.gov.nrs.api.v1.model.MTACoalLicense;
import io.quarkus.panache.common.Page;
import org.eclipse.microprofile.graphql.Description;
import org.eclipse.microprofile.graphql.GraphQLApi;
import org.eclipse.microprofile.graphql.Name;
import org.eclipse.microprofile.graphql.Query;

import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;
import javax.ws.rs.Path;
import java.util.List;

@GraphQLApi
@ApplicationScoped
@RolesAllowed("**")
public class MtaCoalLicenseGraphQLEndpoint {

  @Query("CoalLicense_ByID")
  @Description("Get MTA Coal License By ID.")
  @Transactional
  @Path("/{id}")
  @RolesAllowed("**")
  public MTACoalLicense getMTACoalLicenseByID(@Name("id") Integer id) {
    return MTACoalLicense.findById(id);
  }

  @Query("Paginated_CoalLicenses")
  @Description("Get MTA Coal Licenses By Page number and size.")
  @Transactional
  @RolesAllowed("**")
  public List<MTACoalLicense> getMTACoalLicenses(@Name("page") Integer page, @Name("size") Integer size) {
    return MTACoalLicense.findAll().page(Page.of(page, size)).list();
  }
}
