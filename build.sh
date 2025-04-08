#! /bin/bash
# PNPM_VERSION=8.15.8
PNPM_VERSION="$(curl -fsSL https://registry.npmjs.org/@pnpm/exe | grep -o '"latest":[[:space:]]*"[0-9.]*"' | grep -o '[0-9.]*')"
PNPM_VERSION_MAJOR=$(echo ${PNPM_VERSION} | cut -d "." -f 1)

docker buildx build --push --platform linux/arm64,linux/amd64  --tag merik/pnpm:latest .
docker buildx build --push --platform linux/arm64,linux/amd64  --tag merik/pnpm:${PNPM_VERSION} .
docker buildx build --push --platform linux/arm64,linux/amd64  --tag merik/pnpm:${PNPM_VERSION_MAJOR} .

docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.lambda --tag merik/pnpm:lambda-latest .
docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.lambda --tag merik/pnpm:lambda-${PNPM_VERSION} .
docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.lambda --tag merik/pnpm:lambda-${PNPM_VERSION_MAJOR} .
