i do like a good beer.

# version-aggregator

Goal of this project is to aggregate responses from different services while not using any dependencies to ease maintenance.

## configuration

configuration happens using env vars prefixed with `version.`.

## usage

curl http://localhost:8080/version

### example

```
docker run --rm \
-p8080:8080 \
-eversion.client.url='http://esel:3100/version' \
-eversion.nuxt-client.url='http://esel:4000/nuxtversion' \
-eversion.server.url='http://esel:3030/serverversion' \
version-aggregator
```
