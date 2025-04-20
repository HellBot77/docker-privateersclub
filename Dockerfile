FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/privateersclub/wiki.git && \
    cd wiki && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG})
    # rm -rf .git

FROM node AS build

WORKDIR /wiki
COPY --from=base /git/wiki .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /wiki/docs/.vitepress/dist .
