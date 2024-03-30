FROM node:lts-alpine3.18 as base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./
RUN yarn set version classic
RUN yarn install --production --pure-lockfile && \
    yarn cache clean

FROM base as build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json  ./
RUN yarn set version classic
RUN yarn install --production=false --pure-lockfile && \
    yarn cache clean
COPY . .
RUN yarn build


FROM base
WORKDIR /usr/src/wpp-server/
RUN apk update && \
    apk add --no-cache \
    chromium \
    vips-dev \
    fftw-dev \
    gcc \
    g++ \
    make \
    libc6-compat \
    && rm -rf /var/cache/apk/*
RUN yarn add @babel/runtime && \
    yarn add sharp mongoose prom-client --ignore-engines && \
    yarn cache clean
COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/
EXPOSE 21465
ENTRYPOINT ["npm", "start"]
