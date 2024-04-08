# version-aggregator

Goal of this project is to aggregate responses from different services while not using any dependencies to ease maintenance.

## configuration

configuration happens using env vars prefixed with `version.`.
you may not use static and url together, static will take priority.

## usage

curl http://localhost:8080/version

### example

```
docker run --rm \
-p8080:8080 \
-eversion.client.url='http://esel:3100/version' \
-eversion.nuxt-client.url='http://esel:4000/nuxtversion' \
-eversion.server.url='http://esel:3030/serverversion' \
-eversion.dof_app_deploy.static='696'
version-aggregator
```