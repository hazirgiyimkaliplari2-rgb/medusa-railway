#!/bin/sh
set -e

echo "Starting Medusa application..."

# Check if admin panel exists
if [ ! -f ".medusa/server/public/admin/index.html" ]; then
    echo "Admin panel not found. Building it now..."
    NODE_OPTIONS="--max-old-space-size=4096" npx medusa build
    
    # Verify build was successful
    if [ -f ".medusa/server/public/admin/index.html" ]; then
        echo "Admin panel built successfully!"
    else
        echo "ERROR: Failed to build admin panel!"
        exit 1
    fi
else
    echo "Admin panel already exists."
fi

# Start the application
echo "Starting Medusa server..."
exec yarn start