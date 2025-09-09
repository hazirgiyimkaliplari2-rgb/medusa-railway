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

# Build admin panel during Docker build
RUN NODE_OPTIONS="--max-old-space-size=4096" npx medusa build || \
    echo "Admin panel build failed during Docker build, will retry at runtime"

# Make scripts executable
RUN chmod +x scripts/start.sh

EXPOSE 9000

# Use the startup script that builds admin panel if needed
ENTRYPOINT ["./scripts/start.sh"]