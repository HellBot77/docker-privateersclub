FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/privateersclub/wiki.git && \
    cd wiki && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG})
    # rm -rf .git

FROM --platform=$BUILDPLATFORM node AS build

WORKDIR /wiki
COPY --from=base /git/wiki .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /wiki/docs/.vitepress/dist ./public
