FROM node:lts

ARG PNPM_VERSION
ENV PNPM_VERSION=$PNPM_VERSION
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN curl -fsSL https://get.pnpm.io/install.sh | PNPM_VERSION=${PNPM_VERSION} bash -

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "pnpm" ]