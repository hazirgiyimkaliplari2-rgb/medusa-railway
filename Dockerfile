# Build stage
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install ALL dependencies (including devDependencies for build)
RUN yarn install

# Copy all source files
COPY . .

# Make build script executable and run it
RUN chmod +x scripts/docker-build.sh && \
    NODE_OPTIONS="--max-old-space-size=4096" ./scripts/docker-build.sh

# Runtime stage
FROM node:20-alpine

# Install runtime dependencies only
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install production dependencies only
RUN yarn install --production

# Copy application source
COPY . .

# Copy built files from builder stage
COPY --from=builder /app/.medusa /app/.medusa

# Verify admin panel exists
RUN ls -la .medusa/server/public/admin/index.html && \
    echo "Admin panel verification complete"

EXPOSE 9000

CMD ["yarn", "start"]