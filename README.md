# Version Aggregator

A lightweight, zero-dependency service that aggregates version information from multiple services into a single endpoint.

## Overview

Version Aggregator does one thing and does it well: it collects version information from configured services and returns them as a unified JSON response.

## Features

- **Zero Dependencies** - Uses only Python's standard library (`http.server`, `urllib.request`, `json`)
- **Single Purpose** - Aggregates version endpoints, nothing more
- **Lightweight** - Minimal footprint, perfect for microservice architectures
- **Static & Dynamic Versions** - Support for both hardcoded versions and fetched endpoints
- **Simple Configuration** - Environment variable based setup

## Usage

### Running Locally

```bash
# Set up version endpoints via environment variables
export version.myservice.url=http://myservice:8080/version
export version.api.static='{"version": "1.0.0"}'

# Run the service
python app.py
```

The service starts on port `8080` and exposes a single endpoint:

```
GET /version
```

### Running with Docker

```bash
docker build -t version-aggregator .

docker run -p 8080:8080 \
  -e "version.myservice.url=http://myservice:8080/version" \
  -e "version.api.static={\"version\": \"1.0.0\"}" \
  version-aggregator
```

## Configuration

Version Aggregator is configured entirely through environment variables. Each service to aggregate requires an environment variable following this naming convention:

```
version.<service-name>.<type>=<value>
```

### Configuration Options

| Component | Description |
|-----------|-------------|
| `version.` | Required prefix for all configuration |
| `<service-name>` | Identifier for the service (used as key in response) |
| `<type>` | Either `url` or `static` |
| `<value>` | URL to fetch or static JSON value |

### Types

#### URL Type (`url`)
Fetches version information from a remote endpoint. The endpoint must return valid JSON.

```bash
export version.api-server.url=http://api-server:3000/version
export version.frontend.url=http://frontend:8080/health
```

#### Static Type (`static`)
Returns a hardcoded value directly without making any HTTP request.

```bash
export version.database.static='{"version": "15.2", "type": "postgresql"}'
export version.config.static='v2.1.0'
```

### Example Configuration

```bash
# Dynamic endpoints
export version.client.url=http://client-svc:3100/version
export version.server.url=http://api-svc:3000/serverversion
export version.nuxt-client.url=http://nuxtclient-svc:4000/nuxtversion

# Static versions
export version.infrastructure.static='{"kubernetes": "1.28", "helm": "3.12"}'
```

### Example Response

```json
{
    "client": {
        "version": "27.5.0",
        "sha": "abc123"
    },
    "infrastructure": {
        "kubernetes": "1.28",
        "helm": "3.12"
    },
    "server": {
        "version": "28.1.0"
    },
    "services-unavailable": false
}
```

When a service is unreachable, its value will be `"unavailable"` and `services-unavailable` will be `true`.

## Requirements

- Python 3.14+

## License

See [LICENSE](LICENSE) file.

