## To Run this in on local,
1. Please  run `docker-compose up` command.
2. login to KC admin console http://localhost:8191/auth/
3. click on admin console
4. sign-in with admin/admin
5. go to clients menu in left side-bar
6. click on create new client and then import, select the kc-local-client.json file present in this folder.
7. run the nest application by `npm run start:dev:windows`
8. It will run typeorm migrations and then start the application on port 8000.
9. you can now access the swagger ui at http://localhost:8000/

## Deployment to openshift
1. follow this link for artifactory knowledge https://developer.gov.bc.ca/Artifact-Repositories-(Artifactory),  it helps in understanding build and push of image to openshift.
2. Create secrets in GitHub
    1. This example repo has 3 secrets which are available for all deployments and then environment specific secrets are for each deployment.
        - `DOCKER_HUB_ACCESS_TOKEN`
        - `DOCKER_HUB_USERNAME`
        - `OPENSHIFT_SERVER`
    2. The nest-dev environment has secrets specific to this deployment.
        - `OPENSHIFT_TOKEN` The token to access openshift namespace where this will be deployed ex: `aaaaaa-dev`
        - `NAMESPACE_NO_ENV` The namespace of the deployment ex: `aaaaaa`
3. Please refer to this file for sample openshift deployment. `.github/workflows/openshift-node-nest.yaml`
4. The image size produced is around 102 MB.
5. The application starts up within 4 seconds, with 50-150mc cpu and consumes around 55 Megs of memory.
6. The app consumes around 25-25 mc cpu during idle time.
