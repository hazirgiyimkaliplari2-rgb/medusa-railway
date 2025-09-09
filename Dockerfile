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

# Build the application (includes admin panel)
RUN yarn build

# Expose port
EXPOSE 9000

# Start the application (serves both API and admin panel)
CMD ["yarn", "start"]