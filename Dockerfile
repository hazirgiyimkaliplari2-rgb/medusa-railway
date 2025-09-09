# Single stage build with runtime build capability
FROM node:20-alpine

# Install build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install all dependencies (needed for build)
RUN yarn install

# Copy all source files
COPY . .

# Make scripts executable
RUN chmod +x scripts/start.sh scripts/start-api-only.sh

# Try to build admin panel during Docker build (may fail, will retry at runtime)
RUN NODE_OPTIONS="--max-old-space-size=4096" npx medusa build || \
    echo "Admin panel build failed during Docker build, will retry at runtime"

EXPOSE 9000

# Railway will run yarn start, which now points to our script
CMD ["yarn", "start"]