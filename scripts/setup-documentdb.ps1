# DocumentDB Local Setup Script for Windows
# This script sets up a local DocumentDB instance using Docker

param(
    [string]$Username = "admin",
    [string]$Password = "password123",
    [int]$Port = 10260
)

Write-Host "🚀 Setting up DocumentDB Local..." -ForegroundColor Green

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}

# Stop and remove existing container if it exists
Write-Host "🧹 Cleaning up existing DocumentDB container..." -ForegroundColor Yellow
docker stop documentdb-container 2>$null
docker rm documentdb-container 2>$null

# Pull the latest DocumentDB image
Write-Host "📥 Pulling DocumentDB image..." -ForegroundColor Yellow
docker pull ghcr.io/microsoft/documentdb/documentdb-local:latest

# Tag the image for easier reference
Write-Host "🏷️  Tagging DocumentDB image..." -ForegroundColor Yellow
docker tag ghcr.io/microsoft/documentdb/documentdb-local:latest documentdb

# Run DocumentDB container
Write-Host "🔧 Starting DocumentDB container..." -ForegroundColor Yellow
docker run -dt -p ${Port}:${Port} --name documentdb-container documentdb --username $Username --password $Password

# Clean up the original image to save space
Write-Host "🧹 Cleaning up original image..." -ForegroundColor Yellow
docker image rm -f ghcr.io/microsoft/documentdb/documentdb-local:latest 2>$null

# Wait for DocumentDB to start
Write-Host "⏳ Waiting for DocumentDB to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Test the connection
Write-Host "🔍 Testing connection..." -ForegroundColor Yellow
try {
    docker exec documentdb-container pg_isready -h localhost -p $Port | Out-Null
    Write-Host "✅ DocumentDB is running successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Connection Details:" -ForegroundColor Cyan
    Write-Host "   Host: localhost" -ForegroundColor White
    Write-Host "   Port: $Port" -ForegroundColor White
    Write-Host "   Username: $Username" -ForegroundColor White
    Write-Host "   Password: $Password" -ForegroundColor White
    Write-Host "   Connection String: mongodb://${Username}:${Password}@localhost:${Port}/?tls=true&tlsAllowInvalidCertificates=true&authMechanism=SCRAM-SHA-256" -ForegroundColor White
    Write-Host ""
    Write-Host "🎉 You can now connect using the DocumentDB for VS Code extension!" -ForegroundColor Green
} catch {
    Write-Host "❌ DocumentDB failed to start properly. Please check the logs:" -ForegroundColor Red
    Write-Host "   docker logs documentdb-container" -ForegroundColor Yellow
    exit 1
}
