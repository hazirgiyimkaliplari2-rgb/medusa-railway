#!/bin/sh
set -e

echo "Starting Medusa API..."

# Start Medusa directly - v2 doesn't have --no-admin flag
exec npx medusa start