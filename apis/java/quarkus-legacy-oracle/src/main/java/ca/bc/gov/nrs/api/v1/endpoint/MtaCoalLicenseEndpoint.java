package ca.bc.gov.nrs.api.v1.endpoint;

import ca.bc.gov.nrs.api.v1.model.MTACoalLicense;
import io.quarkus.panache.common.Page;
import org.eclipse.microprofile.jwt.JsonWebToken;

import javax.annotation.security.RolesAllowed;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/api/v1/mta-coal-licenses")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@RolesAllowed("**")
public class MtaCoalLicenseEndpoint {
  @Inject
  JsonWebToken accessToken;

  @GET
  @Transactional
  @Path("/{id}")
  @RolesAllowed("**")
  public Response getMTACoalLicenseByID(@PathParam("id") Integer id) {
    MTACoalLicense entity = MTACoalLicense.findById(id);
    if (entity == null) {
      return Response.status(Response.Status.NOT_FOUND).build();
    } else {
      return Response.ok(entity).build();
    }
  }

  @GET
  @Transactional
  @RolesAllowed("**")
  public Response getMTACoalLicenses(@QueryParam("page") Integer page, @QueryParam("size") Integer size) {
    List<MTACoalLicense> entities = MTACoalLicense.findAll().page(Page.of(page, size)).list();
    return Response.ok(entities).build();
  }
}
