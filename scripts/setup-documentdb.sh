#!/bin/bash

# DocumentDB Local Setup Script
# This script sets up a local DocumentDB instance using Docker

set -e

echo "🚀 Setting up DocumentDB Local..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Stop and remove existing container if it exists
echo "🧹 Cleaning up existing DocumentDB container..."
docker stop documentdb-container 2>/dev/null || true
docker rm documentdb-container 2>/dev/null || true

# Pull the latest DocumentDB image
echo "📥 Pulling DocumentDB image..."
docker pull ghcr.io/microsoft/documentdb/documentdb-local:latest

# Tag the image for easier reference
echo "🏷️  Tagging DocumentDB image..."
docker tag ghcr.io/microsoft/documentdb/documentdb-local:latest documentdb

# Run DocumentDB container
echo "🔧 Starting DocumentDB container..."
docker run -dt \
  -p 10260:10260 \
  --name documentdb-container \
  documentdb \
  --username admin \
  --password password123

# Clean up the original image to save space
echo "🧹 Cleaning up original image..."
docker image rm -f ghcr.io/microsoft/documentdb/documentdb-local:latest 2>/dev/null || echo "No original image to remove"

# Wait for DocumentDB to start
echo "⏳ Waiting for DocumentDB to start..."
sleep 10

# Test the connection
echo "🔍 Testing connection..."
if docker exec documentdb-container pg_isready -h localhost -p 10260 > /dev/null 2>&1; then
    echo "✅ DocumentDB is running successfully!"
    echo ""
    echo "📋 Connection Details:"
    echo "   Host: localhost"
    echo "   Port: 10260"
    echo "   Username: admin"
    echo "   Password: password123"
    echo "   Connection String: mongodb://admin:password123@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true&authMechanism=SCRAM-SHA-256"
    echo ""
    echo "🎉 You can now connect using the DocumentDB for VS Code extension!"
else
    echo "❌ DocumentDB failed to start properly. Please check the logs:"
    echo "   docker logs documentdb-container"
    exit 1
fi
