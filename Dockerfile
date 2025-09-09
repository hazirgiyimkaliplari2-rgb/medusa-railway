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
RUN chmod +x scripts/start.sh

EXPOSE 9000

# Use the startup script that builds admin panel if needed
CMD ["./scripts/start.sh"]