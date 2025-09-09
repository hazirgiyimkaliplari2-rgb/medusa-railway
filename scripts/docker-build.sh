#!/bin/sh
set -e

echo "Starting Medusa build process..."

# Build the application
echo "Building Medusa application..."
yarn build

# Verify admin panel was built
if [ ! -f ".medusa/server/public/admin/index.html" ]; then
    echo "ERROR: Admin panel was not built successfully!"
    echo "Attempting to build admin panel separately..."
    npx medusa build
fi

# Final verification
if [ -f ".medusa/server/public/admin/index.html" ]; then
    echo "SUCCESS: Admin panel built successfully!"
    ls -la .medusa/server/public/admin/
else
    echo "FATAL: Admin panel build failed!"
    exit 1
fi

echo "Build process completed successfully!"