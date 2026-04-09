#!/bin/bash
# =============================================================
# Linux Lab - Quick Reset Script
# Destroys the current container and rebuilds a fresh one.
# Reads DISTRO from .env (defaults to ubuntu).
# =============================================================

set -e

# Load distro name from .env if available
DISTRO="ubuntu"
if [ -f .env ]; then
    eval "$(grep -E '^DISTRO=' .env | head -1)"
fi

echo "🔄  Resetting Linux Lab environment ($DISTRO)..."
echo ""

docker compose down --volumes --remove-orphans 2>/dev/null || true
docker compose build --no-cache
docker compose up -d

echo ""
echo "✅  Fresh Linux Lab ($DISTRO) is ready!"
echo "   Run:  docker exec -it linux-lab bash"
echo ""
