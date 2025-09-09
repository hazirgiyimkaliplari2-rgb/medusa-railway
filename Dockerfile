FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache python3 make g++ bash

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# Install dependencies
RUN yarn install

# Copy application files
COPY . .

# Build the Medusa application and admin panel
RUN npx medusa build

# Verify build was successful
RUN ls -la .medusa/server/public/admin/

# Expose port
EXPOSE 9000

# Create a startup script
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'echo "Starting Medusa server with admin panel..."' >> /app/start.sh && \
    echo 'exec yarn start' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]