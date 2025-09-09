#!/bin/sh
set -e

echo "Starting Medusa application..."

# ALWAYS BUILD on first run since Docker layers don't preserve build output
echo "Building admin panel (this will take 1-2 minutes on first run)..."
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

# Start the application - USE npx medusa start to use local version!
echo "Starting Medusa server..."
exec npx medusa start