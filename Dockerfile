# Build stage
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install ALL dependencies (including devDependencies for build)
RUN yarn install --frozen-lockfile

# Copy all source files
COPY . .

# Build the application with admin panel
RUN NODE_OPTIONS="--max-old-space-size=4096" yarn build && \
    ls -la .medusa/server/public/admin/ && \
    echo "Admin panel built successfully"

# Runtime stage
FROM node:20-alpine

# Install runtime dependencies only
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install production dependencies only
RUN yarn install --production --frozen-lockfile

# Copy application source
COPY . .

# Copy built files from builder stage
COPY --from=builder /app/.medusa /app/.medusa

# Verify admin panel exists
RUN ls -la .medusa/server/public/admin/index.html

EXPOSE 9000

CMD ["yarn", "start"]