FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache python3 make g++

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install dependencies
RUN yarn install

# Copy application files
COPY . .

# Build the application - both server and admin
RUN NODE_ENV=production yarn build || npx medusa build || (echo "Build failed, trying with increased memory" && NODE_OPTIONS="--max-old-space-size=4096" npx medusa build)

# Expose port
EXPOSE 9000

# Start command
CMD ["yarn", "start"]