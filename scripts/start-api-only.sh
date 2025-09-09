#!/bin/sh
set -e

echo "Starting Medusa API..."

# Build admin panel if it doesn't exist
if [ ! -f ".medusa/server/public/admin/index.html" ]; then
    echo "Admin panel not found. Building it now..."
    NODE_OPTIONS="--max-old-space-size=4096" npx medusa build || echo "Build failed, continuing anyway"
fi

# Start Medusa directly
exec npx medusa start
