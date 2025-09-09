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

# Don't build during Docker - will build at runtime
# This ensures the build happens with the correct environment variables

EXPOSE 9000

# Railway will run yarn start, which now points to our script
CMD ["yarn", "start"]