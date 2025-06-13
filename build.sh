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

docker buildx build --push --platform linux/arm64,linux/amd64 --tag merik/pnpm:latest --build-arg PNPM_VERSION=$PNPM_VERSION .
docker tag merik/pnpm:latest merik/pnpm:${PNPM_VERSION}
docker tag merik/pnpm:latest merik/pnpm:${PNPM_VERSION_MAJOR}

docker push merik/pnpm:${PNPM_VERSION}
docker push merik/pnpm:${PNPM_VERSION_MAJOR}

### Alpine

docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.alpine --tag merik/pnpm:latest-alpine --build-arg PNPM_VERSION=$PNPM_VERSION .
docker tag merik/pnpm:latest-alpine merik/pnpm:${PNPM_VERSION}-alpine
docker tag merik/pnpm:latest-alpine merik/pnpm:${PNPM_VERSION_MAJOR}-alpine

docker push merik/pnpm:${PNPM_VERSION}-alpine
docker push merik/pnpm:${PNPM_VERSION_MAJOR}-alpine

### AWS Lambda

docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile.lambda --tag merik/pnpm:lambda-latest --build-arg PNPM_VERSION=$PNPM_VERSION .
docker tag merik/pnpm:lambda-latest merik/pnpm:lambda-${PNPM_VERSION}
docker tag merik/pnpm:lambda-latest merik/pnpm:lambda-${PNPM_VERSION_MAJOR}

docker push merik/pnpm:lambda-${PNPM_VERSION}
docker push merik/pnpm:lambda-${PNPM_VERSION_MAJOR}
