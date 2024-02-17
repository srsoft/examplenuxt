# Use a large Node.js base image to build the application and name it "build"
FROM node:18-alpine as build

# Exact same steps as before
WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

RUN npm run build

# Create a new Docker image and name it "prod"
FROM node:18-alpine as prod

WORKDIR /app

# Copy the built application from the "build" image into the "prod" image
# This will only copy whatever is in the .output folder and ignore useless files like node_modules!
COPY --from=build /app/.output /app/.output

# Start is the same as before
CMD ["node", ".output/server/index.mjs"] 
