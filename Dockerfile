# Nuxt 3 builder
FROM node:18-alpine as builder

# Create app directory
WORKDIR /app
ADD . /app/

# global install & update
RUN npm install -g npm@10.4.0
RUN npm i yarn

RUN rm yarn.lock
# RUN rm package-lock.json
RUN yarn
RUN yarn build

# Nuxt 3 production
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /app/.output  /app/.output
ENV NITRO_PORT=3000

ENV HOST 0.0.0.0
EXPOSE 3000

# start command
CMD [ "node", ".output/server/index.mjs" ]
