#!/bin/bash
# =============================================================
# Linux Lab - Quick Reset Script
# Destroys the current container and rebuilds a fresh one.
# =============================================================

set -e

echo "🔄  Resetting Linux Lab environment..."
echo ""

docker compose down --volumes --remove-orphans 2>/dev/null || true
docker compose build --no-cache
docker compose up -d

echo ""
echo "✅  Fresh Linux Lab is ready!"
echo "   Run:  docker exec -it linux-lab bash"
echo ""
