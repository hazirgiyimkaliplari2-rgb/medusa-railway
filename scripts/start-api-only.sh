#!/bin/sh
set -e

echo "Starting Medusa API (without admin panel)..."

# Start Medusa without admin panel
exec npx medusa start --no-admin