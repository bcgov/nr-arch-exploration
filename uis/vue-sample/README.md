# Vue 3 + Typescript + Vite

This template should help get you started developing with Vue 3 and Typescript in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

## Recommended IDE Setup

- [VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=johnsoncodehk.volar)

## Type Support For `.vue` Imports in TS

Since TypeScript cannot handle type information for `.vue` imports, they are shimmed to be a generic Vue component type by default. In most cases this is fine if you don't really care about component prop types outside of templates. However, if you wish to get actual prop types in `.vue` imports (for example to get props validation when using manual `h(...)` calls), you can enable Volar's `.vue` type support plugin by running `Volar: Switch TS Plugin on/off` from VSCode command palette.

## Deployment to openshift
1. follow this link for artifactory knowledge https://developer.gov.bc.ca/Artifact-Repositories-(Artifactory),  it helps in understanding build and push of image to openshift.
2. Create secrets in GitHub
    1. This example repo has 3 secrets which are available for all deployments and then environment specific secrets are for each deployment.
        - `DOCKER_HUB_ACCESS_TOKEN`
        - `DOCKER_HUB_USERNAME`
        - `OPENSHIFT_SERVER`
    2. The vue-dev environment has secrets specific to this deployment.
        - `OPENSHIFT_TOKEN` The token to access openshift namespace where this will be deployed ex: `aaaaaa-dev`
        - `NAMESPACE_NO_ENV` The namespace of the deployment ex: `aaaaaa`
3. Please refer to this file for sample openshift deployment. `.github/workflows/openshift-node-vue.yaml`
