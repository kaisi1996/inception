# Developer Documentation

## Overview

This document provides comprehensive technical guidance for developers working on the Inception project. It covers environment setup, build processes, development workflows, and system architecture.

## Environment Setup from Scratch

### Prerequisites

#### System Requirements
- **Working Area**: Debian Virtual Machine

#### Installation Commands

**In Debian Virtual Machine:**
```bash
# Update package index
sudo apt update

# Install what is required
apt install -y sudo ufw docker docker-compose make openbox xinit kitty firefox-esr
```

### Project Setup

#### 1. Clone the Repository
```bash
git clone <repo>
cd inception
```

#### 2. Configuration Files Setup

**Create Environment File:**
```bash
# Create .env file in srcs/ directory
touch srcs/.env
```

**Environment Variables Template:**
```bash
# Copy this template to srcs/.env and modify values
# Database Configuration
MYSQL_ROOT_PASSWORD=SecureRootPassword123!
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=SecureUserPassword123!

# WordPress Configuration
DOMAIN_NAME=localhost
WP_ADMIN_LOGIN=admin
WP_ADMIN_PASSWORD=SecureAdminPassword123!
WP_ADMIN_EMAIL=admin@example.com
WP_USER_LOGIN=editor
WP_USER_PASSWORD=SecureEditorPassword123!
WP_USER_EMAIL=editor@example.com
```

#### 3. Directory Structure Setup
```bash
# Create necessary directories (handled by make)
mkdir -p /home/$USER/data/wordpress_vol
mkdir -p /home/$USER/data/mariadb_vol
```

## Build and Launch Process

### Makefile Commands

#### Primary Commands

**make** - Build and start all services
```bash
make
```
**Process:**
1. Runs `srcs/requirements/wordpress/tools/init_dir.sh` to create directories
2. Executes `docker-compose build` for all services
3. Starts containers with `docker-compose up -d`

**make down** - Stop all services
```bash
make down
```
**Process:**
1. Stops all running containers
2. Removes containers
3. Preserves volumes and networks

**make re** - Restart services
```bash
make re
```
**Process:**
1. Executes `make down`
2. Executes `make up`

#### Maintenance Commands

**make clean** - Clean unused Docker resources
```bash
make clean
```
**Process:**
1. Stops services
2. Runs `docker system prune --all`
3. Removes unused images

**make fclean** - Complete cleanup
```bash
make fclean
```
**Process:**
1. Stops services
2. Runs complete Docker cleanup
3. Removes networks and volumes
4. Deletes data directories

**make rebuild** - Complete rebuild
```bash
make rebuild
```
**Process:**
1. Executes `make fclean`
2. Executes `make up`

### Docker Compose Configuration

#### Service Architecture
```yaml
services:
  nginx:      # Web server with SSL termination
  wordpress:  # PHP application server
  mariadb:    # Database server
```

#### Build Process Details

**1. Nginx Service Build:**
```dockerfile
FROM alpine:3.22
# Installs nginx and openssl
# Generates self-signed SSL certificate
# Copies custom configuration
# Exposes port 443
```

**2. WordPress Service Build:**
```dockerfile
FROM alpine:3.22
# Installs PHP 8.3 and extensions
# Configures PHP-FPM
# Installs WP-CLI
# Sets up WordPress initialization script
# Exposes port 9000
```

**3. MariaDB Service Build:**
```dockerfile
FROM alpine:3.22
# Installs MariaDB server
# Copies initialization script
# Sets up database and users
# Exposes port 3306
```

## Container Management Commands

### Container Operations

#### Basic Container Management
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View container details
docker inspect <container_name>

# Execute commands in container
docker exec -it <container_name> /bin/sh

# View container logs
docker logs <container_name>

# Follow container logs in real-time
docker logs -f <container_name>
```

### Network Management

#### Docker Networks
```bash
# List networks
docker network ls

# Inspect network
docker network inspect <network>

# Connect container to network
docker network connect <network> <container>

# Disconnect container from network
docker network disconnect <network> <container>
```

### Volume Management

#### Volume Operations
```bash
# List volumes
docker volume ls

# Inspect volume details
docker volume inspect <volume>
```

## Data Persistence and Storage

### Data Storage Architecture

#### WordPress Data
- **Location**: `/home/$USER/data/wordpress_vol/`
- **Volume Type**: Docker bind mount
- **Persistence**: Survives container restarts and recreation

#### MariaDB Data
- **Location**: `/home/$USER/data/mariadb_vol/`
- **Volume Type**: Docker bind mount
- **Persistence**: Survives container restarts and recreation
