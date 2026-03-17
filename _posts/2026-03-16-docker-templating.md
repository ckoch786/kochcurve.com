---
layout: post
title: "Using Docker Templating to Keep Builds Flexible"
date: 2026-03-16 10:00:00 -0500
tags: [docker, devops, templating, ci]
---

Docker build-time templating is a small but powerful way to make your images reusable across environments.

In this post, we'll cover when to use Docker's templating features, how to use `ARG` + `ENV`, and a real-world example with a multi-stage Dockerfile.

## Why Docker templating matters

Hardcoded values (`ENV`, paths, app names) make Dockerfiles brittle. Templating turns a statically-defined image into a configurable artifact for staging, production, and CI.

Benefits:

- Fewer Dockerfile copies across projects
- Extra control for CI branching and deployments
- Reduce risk of accidentally baking secrets into images

## 1) Build args and environment variables

Use `ARG` at build time and map it to runtime defaults with `ENV`.

```dockerfile
# Dockerfile
ARG APP_ENV=production
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

FROM base AS runtime
ARG APP_ENV
ENV APP_ENV=${APP_ENV}
EXPOSE 3000
CMD ["node", "server.js"]
```

Build with custom args:

```bash
docker build --build-arg APP_ENV=staging -t myapp:staging .
```

Then runtime in your app can read `process.env.APP_ENV`.

## 2) Template with `docker-compose` variables

Use `.env` files or pass values via compose CLI.

```yaml
version: "3.9"
services:
  web:
    build:
      context: .
      args:
        APP_ENV: ${APP_ENV:-production}
    image: myapp:${TAG:-latest}
    ports:
      - "3000:3000"
```

`.env`:

```text
APP_ENV=development
TAG=dev
```

Then run:

```bash
docker compose up --build
```

## 3) Multi-stage with templated stage names and scripts

You can use args and conditional scripts in shell to template commands.

```dockerfile
ARG NODE_VERSION=20-alpine
FROM node:${NODE_VERSION} AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . ./
RUN npm run build

FROM nginx:stable-alpine AS runtime
ARG APP_PORT=8080
ENV PORT=${APP_PORT}
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE ${APP_PORT}
CMD ["nginx", "-g", "daemon off;"]
```

Build with templated values:

```bash
docker build --build-arg NODE_VERSION=20-alpine --build-arg APP_PORT=8080 -t myapp:latest .
```

## 4) When to avoid templating

Templating is not a replacement for secrets management. Don't template API keys or credentials directly into builds.

Keep secrets in secure stores (`Vault`, AWS Secrets Manager, GitHub Secrets), and inject them at runtime.

## 5) Quick checklist for clean templating

- [x] Use `ARG` for build-time variation
- [x] Use `ENV` for runtime defaults
- [x] Keep minimal image instructions
- [x] Avoid secrets in Dockerfile
- [x] Use tags for environment-specific builds

## Conclusion

Docker templating with `ARG`, `ENV`, and compose variables helps you produce the same image across environments while controlling behavior through flags. When done correctly, it makes builds repeatable, faster, and safer.

Try it today by converting one hardcoded value in your Dockerfile to an `ARG` and passing it from your CI pipeline.
