# Use a large Node.js base image to build the application and name it "build"
FROM node:18-alpine as build

WORKDIR /app

# Copy the package.json and package-lock.json files into the working directory before copying the rest of the files
# This will cache the dependencies and speed up subsequent builds if the dependencies don't change
COPY package*.json /app

# You might want to use yarn or pnpm instead
RUN npm install

COPY . /app

RUN npm run build

# Instead of using a node:18-alpine image, we are using a distroless image. These are provided by google: https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/nodejs:18 as prod

WORKDIR /app

# Copy the built application from the "build" image into the "prod" image
COPY --from=build /app/.output /app/.output

# Since this image only contains node.js, we do not need to specify the node command and simply pass the path to the index.mjs file!
CMD ["/app/.output/server/index.mjs"]