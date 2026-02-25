# NGINX Reverse Proxy with Environment-Aware Configuration (envsubst)

This repository demonstrates a production-inspired reverse proxy setup using NGINX and Docker.

The configuration supports multiple environments (local, stage, production) using environment variable templating via `envsubst`.

The goal of this project is to showcase how dynamic NGINX configurations can be generated per environment without maintaining separate static config files.

---

## Overview

This setup includes:

- NGINX reverse proxy running inside Docker
- Environment-based configuration using `envsubst`
- Separate local (HTTP) and production (HTTPS) configurations
- Let's Encrypt SSL integration
- Multi-subdomain routing
- Static frontend mounting
- Resource limits for container control

---

## Architecture

- `docker-compose.yml` → Local development (HTTP only)
- `docker-compose-prod.yml` → Production (HTTPS + SSL)
- Environment variables loaded from `env/`
- NGINX templates dynamically rendered at container startup
- SSL certificates mounted from host (`/etc/letsencrypt`)

NGINX templates are stored under:

```bash
proxy/templates/
```

They are rendered using environment variables defined in the selected `.env` file.

---

## Project Structure

```bash
proxy/
├── Dockerfile
├── templates/
├── nginx_snippets/
env/
├── .env.local
├── .env.stage
└── .env.prod
scripts/
└── get-ssl.sh
docker-compose.yml
docker-compose-prod.yml
```

---

## Running Locally (HTTP)

```bash
docker compose --env-file env/.env.local up --build
```

Local mode intentionally does not use SSL to simplify development workflow.

---

## Running in Production (HTTPS)

```bash
docker compose -f docker-compose-prod.yml \
  --env-file env/.env.prod \
  up --build -d
```

Production mode enables:

- HTTPS redirection
- Let's Encrypt challenge handling
- SSL certificate loading via mounted volumes

---

## Generating SSL Certificates

Before running production mode for the first time, you must obtain SSL certificates.

Run:

```bash
bash scripts/get-ssl.sh
```

This script uses Certbot to generate certificates under:

```bash
/etc/letsencrypt
```

---

## Let's Encrypt Permission Notes

Docker must be able to read certificate files from the host.

Make sure permissions are set correctly:

```bash
sudo chmod -R 755 /etc/letsencrypt
```

Certificates are mounted into the container in read-only mode:

```bash
/etc/letsencrypt:/etc/letsencrypt:ro
```

---

## SSL Snippet Naming Convention

`CERT_NAME` in the `.env` file must match the SSL snippet filename.

Example:

If you have:

```bash
proxy/nginx_snippets/ssl-example.conf
```

Then your `.env.prod` should contain:

```bash
CERT_NAME=example
```

---

## Why envsubst?

Instead of maintaining multiple static NGINX configuration files per environment, this setup:

- Uses templated configs
- Injects environment variables dynamically
- Keeps configuration DRY
- Simplifies environment switching

---

## Design Decisions

- Separate compose files for local and production to avoid unnecessary SSL complexity during development
- Templates copied into the Docker image to allow the image to be production-ready and registry-friendly
- Resource limits defined to simulate production constraints
- Environment separation via dedicated `.env` files
- SSL certificates mounted as read-only for security

---

## Disclaimer

This repository is a simplified infrastructure pattern created for demonstration purposes and does not contain any production-sensitive information.
