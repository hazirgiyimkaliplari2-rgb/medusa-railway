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

# Run database migrations on container start
# and then start the application
EXPOSE 9000

# Create a startup script
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'echo "Running database migrations..."' >> /app/start.sh && \
    echo 'npx medusa db:migrate' >> /app/start.sh && \
    echo 'echo "Starting Medusa server..."' >> /app/start.sh && \
    echo 'yarn start' >> /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]