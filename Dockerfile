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

# Build the application with admin panel
RUN NODE_OPTIONS="--max-old-space-size=4096" npx medusa build && \
    ls -la .medusa/server/public/admin/ || \
    (echo "Build failed, retrying..." && NODE_OPTIONS="--max-old-space-size=4096" yarn build) && \
    if [ ! -f ".medusa/server/public/admin/index.html" ]; then \
        echo "ERROR: Admin panel build failed!" && exit 1; \
    fi && \
    echo "Admin panel built successfully!"

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
RUN if [ -f ".medusa/server/public/admin/index.html" ]; then \
        echo "Admin panel verified successfully"; \
        ls -la .medusa/server/public/admin/; \
    else \
        echo "ERROR: Admin panel not found in runtime image!"; \
        ls -la .medusa/server/public/ || echo "Public directory not found"; \
        exit 1; \
    fi

EXPOSE 9000

CMD ["yarn", "start"]