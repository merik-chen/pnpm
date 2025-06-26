#! /bin/sh

download() {
  if command -v curl > /dev/null 2>&1; then
    curl -fsSL "$1"
  else
    wget -qO- "$1"
  fi
}

PNPM_VERSION="$(download https://registry.npmjs.org/@pnpm/exe | grep -o '"latest":[[:space:]]*"[0-9.]*"' | grep -o '[0-9.]*')"
PNPM_VERSION_MAJOR=$(echo ${PNPM_VERSION} | cut -d "." -f 1)

### Debian

docker buildx build --push --platform linux/arm64,linux/amd64 --tag merik/pnpm:latest --tag merik/pnpm:${PNPM_VERSION} --tag merik/pnpm:${PNPM_VERSION_MAJOR} --build-arg PNPM_VERSION=$PNPM_VERSION --build-arg PNPM_VERSION_MAJOR=$PNPM_VERSION_MAJOR .

### Alpine

docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.alpine --tag merik/pnpm:latest-alpine --tag merik/pnpm:${PNPM_VERSION}-alpine --tag merik/pnpm:${PNPM_VERSION_MAJOR}-alpine --build-arg PNPM_VERSION=$PNPM_VERSION .

### AWS Lambda

docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.lambda --tag merik/pnpm:lambda-latest --tag merik/pnpm:lambda-${PNPM_VERSION} --tag merik/pnpm:lambda-${PNPM_VERSION_MAJOR} --build-arg PNPM_VERSION=$PNPM_VERSION .
