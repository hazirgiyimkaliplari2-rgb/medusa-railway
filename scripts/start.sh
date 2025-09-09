#!/bin/sh
set -e

echo "Starting Medusa application..."

# Check if admin panel exists - FORCE BUILD ALWAYS ON FIRST RUN
if [ ! -f ".medusa/server/public/admin/index.html" ]; then
    echo "Admin panel not found. Building it now (this will take 1-2 minutes)..."
    NODE_OPTIONS="--max-old-space-size=4096" npx medusa build
    
    # Verify build was successful
    if [ -f ".medusa/server/public/admin/index.html" ]; then
        echo "Admin panel built successfully!"
        ls -la .medusa/server/public/admin/
    else
        echo "ERROR: Failed to build admin panel!"
        echo "Trying alternative build command..."
        NODE_OPTIONS="--max-old-space-size=4096" yarn build
        
        if [ -f ".medusa/server/public/admin/index.html" ]; then
            echo "Admin panel built with yarn build!"
        else
            echo "FATAL: Could not build admin panel with any method!"
            exit 1
        fi
    fi
else
    echo "Admin panel exists at .medusa/server/public/admin/index.html"
fi

# Start the application - USE npx medusa start to use local version!
echo "Starting Medusa server..."
exec npx medusa start