# Developer Documentation

## Overview

This document provides comprehensive technical guidance for developers working on the Inception project. It covers environment setup, build processes, development workflows, and system architecture.

## Environment Setup from Scratch

### Prerequisites

#### System Requirements
- **Operating System**: Linux (Ubuntu 20.04+ recommended), macOS, or Windows with WSL2
- **Docker**: Version 20.10 or later
- **Docker Compose**: Version 2.0 or later
- **Make**: GNU Make utility
- **Git**: Version 2.25 or later
- **Text Editor**: VS Code, Vim, or preferred IDE with Docker support

#### Installation Commands

**Ubuntu/Debian:**
```bash
# Update package index
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin

# Install Make
sudo apt install build-essential

# Install Git
sudo apt install git
```

**macOS:**
```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop
brew install --cask docker

# Install Make and Git
brew install make git
```

**Windows (WSL2):**
```bash
# Enable WSL2
wsl --install

# Inside WSL2 Ubuntu
sudo apt update
sudo apt install docker.io docker-compose-plugin build-essential git
sudo usermod -aG docker $USER
```

### Project Setup

#### 1. Clone the Repository
```bash
git clone https://github.com/kaisi1996/inception.git
cd inception
```

#### 2. Configuration Files Setup

**Create Environment File:**
```bash
# Create .env file in srcs/ directory
touch srcs/.env
chmod 600 srcs/.env
```

**Environment Variables Template:**
```bash
# Copy this template to srcs/.env and modify values
cat > srcs/.env << EOF
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
EOF
```

#### 3. Directory Structure Setup
```bash
# Create necessary directories (handled by make up)
mkdir -p /home/$USER/data/wordpress_vol
mkdir -p /home/$USER/data/mariadb_vol
```

## Build and Launch Process

### Makefile Commands

#### Primary Commands

**make up** - Build and start all services
```bash
make up
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
3. Removes unused images, containers, and networks

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

### Build Optimization

#### Multi-stage Builds (Future Enhancement)
```dockerfile
# Example for optimization
FROM alpine:3.22 as builder
# Build dependencies

FROM alpine:3.22 as runtime
# Copy only necessary files
```

#### Layer Caching
```dockerfile
# Optimize Dockerfile layer caching
COPY package*.json ./
RUN npm install
COPY . .
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

#### Service-Specific Commands

**Nginx Management:**
```bash
# Test Nginx configuration
docker exec nginx nginx -t

# Reload Nginx configuration
docker exec nginx nginx -s reload

# View Nginx access logs
docker exec nginx tail -f /var/log/nginx/access.log

# View Nginx error logs
docker exec nginx tail -f /var/log/nginx/error.log
```

**WordPress Management:**
```bash
# Enter WordPress container
docker exec -it wordpress /bin/sh

# Check PHP-FPM status
docker exec wordpress ps aux | grep php-fpm

# Restart PHP-FPM
docker exec wordpress kill -USR2 1

# Use WP-CLI
docker exec wordpress wp --info
```

**MariaDB Management:**
```bash
# Connect to MariaDB
docker exec -it mariadb mysql -u root -p

# Check database status
docker exec mariadb mysqladmin ping

# View MariaDB logs
docker logs mariadb

# Create database backup
docker exec mariadb mysqldump -u root -p wordpress > backup.sql
```

### Network Management

#### Docker Networks
```bash
# List networks
docker network ls

# Inspect network
docker network inspect inception_inception

# Connect container to network
docker network connect inception_inception <container>

# Disconnect container from network
docker network disconnect inception_inception <container>
```

#### Service Communication
```bash
# Test connectivity between services
docker exec wordpress ping mariadb
docker exec wordpress ping nginx

# Check port exposure
docker exec wordpress netstat -tlnp
```

### Volume Management

#### Volume Operations
```bash
# List volumes
docker volume ls

# Inspect volume details
docker volume inspect inception_wordpress_data
docker volume inspect inception_mariadb_data

# Create volume backup
docker run --rm -v inception_wordpress_data:/data -v $(pwd):/backup alpine tar czf /backup/wordpress-backup.tar.gz -C /data .

# Restore volume from backup
docker run --rm -v inception_wordpress_data:/data -v $(pwd):/backup alpine tar xzf /backup/wordpress-backup.tar.gz -C /data
```

#### Bind Mount Management
```bash
# Check bind mount status
docker exec nginx ls -la /var/www/html

# Monitor disk usage
du -sh /home/$USER/data/

# Check file permissions
ls -la /home/$USER/data/wordpress_vol/
ls -la /home/$USER/data/mariadb_vol/
```

## Development Workflow

### Local Development

#### Development Environment Setup
```bash
# Create development environment file
cp srcs/.env srcs/.env.dev

# Modify for development
echo "DOMAIN_NAME=localhost" >> srcs/.env.dev
```

#### Hot Reloading Configuration
```bash
# For development with live reload
docker-compose -f srcs/docker-compose.yml --env-file srcs/.env.dev up --build
```

### Debugging

#### Container Debugging
```bash
# Debug Nginx configuration
docker exec nginx nginx -T

# Debug PHP configuration
docker exec wordpress php -i

# Debug database connection
docker exec wordpress wp db check
```

#### Log Analysis
```bash
# View all service logs
docker-compose -f srcs/docker-compose.yml logs

# Filter logs by service
docker-compose -f srcs/docker-compose.yml logs nginx
docker-compose -f srcs/docker-compose.yml logs wordpress
docker-compose -f srcs/docker-compose.yml logs mariadb

# View logs with timestamps
docker-compose -f srcs/docker-compose.yml logs -t

# View last 100 lines
docker-compose -f srcs/docker-compose.yml logs --tail=100
```

### Testing

#### Service Health Checks
```bash
# Create health check script
cat > health_check.sh << 'EOF'
#!/bin/bash
echo "Checking Nginx..."
curl -k https://localhost/ || echo "Nginx failed"

echo "Checking WordPress..."
curl -k https://localhost/wp-admin/ || echo "WordPress failed"

echo "Checking MariaDB..."
docker exec mariadb mysqladmin ping || echo "MariaDB failed"
EOF

chmod +x health_check.sh
./health_check.sh
```

#### Load Testing
```bash
# Install Apache Bench
sudo apt install apache2-utils

# Run load test
ab -n 100 -c 10 https://localhost/
```

## Data Persistence and Storage

### Data Storage Architecture

#### WordPress Data
- **Location**: `/home/$USER/data/wordpress_vol/`
- **Contents**: WordPress files, themes, plugins, uploads
- **Volume Type**: Docker bind mount
- **Persistence**: Survives container restarts and recreation

#### MariaDB Data
- **Location**: `/home/$USER/data/mariadb_vol/`
- **Contents**: Database files, logs, configuration
- **Volume Type**: Docker bind mount
- **Persistence**: Survives container restarts and recreation

### Data Management

#### Backup Strategies
```bash
# Automated backup script
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/$USER/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup WordPress files
tar czf "$BACKUP_DIR/wordpress_$DATE.tar.gz" -C /home/$USER/data/ wordpress_vol

# Backup MariaDB data
tar czf "$BACKUP_DIR/mariadb_$DATE.tar.gz" -C /home/$USER/data/ mariadb_vol

# Database dump
docker exec mariadb mysqldump -u root -p$MYSQL_ROOT_PASSWORD wordpress > "$BACKUP_DIR/database_$DATE.sql"

echo "Backup completed: $DATE"
EOF

chmod +x backup.sh
```

#### Restoration Procedures
```bash
# Restore WordPress files
tar xzf /home/$USER/backups/wordpress_YYYYMMDD_HHMMSS.tar.gz -C /home/$USER/data/

# Restore MariaDB data
tar xzf /home/$USER/backups/mariadb_YYYYMMDD_HHMMSS.tar.gz -C /home/$USER/data/

# Import database
docker exec -i mariadb mysql -u root -p wordpress < /home/$USER/backups/database_YYYYMMDD_HHMMSS.sql
```

### Volume Optimization

#### Monitoring Disk Usage
```bash
# Check volume sizes
docker system df

# Monitor data directory sizes
du -sh /home/$USER/data/*
du -sh /home/$USER/data/wordpress_vol/*
du -sh /home/$USER/data/mariadb_vol/*
```

#### Cleanup Strategies
```bash
# Clean WordPress uploads older than 30 days
find /home/$USER/data/wordpress_vol/wp-content/uploads/ -type f -mtime +30 -delete

# Clean MariaDB binary logs
docker exec mariadb mysql -u root -p -e "PURGE BINARY LOGS BEFORE DATE_SUB(NOW(), INTERVAL 7 DAY);"
```

## Advanced Configuration

### Custom SSL Certificates

#### Using Let's Encrypt
```bash
# Create SSL directory
mkdir -p srcs/requirements/nginx/ssl

# Generate certificates (manual process)
certbot certonly --standalone -d your-domain.com

# Copy certificates to project
cp /etc/letsencrypt/live/your-domain.com/fullchain.pem srcs/requirements/nginx/ssl/
cp /etc/letsencrypt/live/your-domain.com/privkey.pem srcs/requirements/nginx/ssl/
```

#### Update Nginx Configuration
```dockerfile
# In nginx/Dockerfile
COPY ./ssl/fullchain.pem /etc/nginx/ssl/aalkaisi.crt
COPY ./ssl/privkey.pem /etc/nginx/ssl/aalkaisi.key
```

### Performance Optimization

#### PHP Configuration
```dockerfile
# In wordpress/Dockerfile
RUN echo "memory_limit = 1G" >> /etc/php83/php.ini
RUN echo "max_execution_time = 300" >> /etc/php83/php.ini
RUN echo "upload_max_filesize = 64M" >> /etc/php83/php.ini
```

#### MariaDB Configuration
```dockerfile
# In mariadb/tools/init.sh
cat << EOF >> /etc/my.cnf
[mysqld]
innodb_buffer_pool_size = 256M
max_connections = 100
query_cache_size = 64M
EOF
```

### Security Hardening

#### Container Security
```bash
# Run containers as non-root user
# Add to docker-compose.yml:
user: "1000:1000"

# Limit container resources
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
```

#### Network Security
```yaml
# In docker-compose.yml
networks:
  inception:
    driver: bridge
    internal: true  # Disable external access
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

## Troubleshooting Guide

### Common Issues and Solutions

#### Port Conflicts
```bash
# Check port usage
sudo netstat -tlnp | grep :443

# Kill conflicting processes
sudo kill -9 <PID>
```

#### Permission Issues
```bash
# Fix volume permissions
sudo chown -R $USER:$USER /home/$USER/data/
sudo chmod -R 755 /home/$USER/data/
```

#### Container Startup Failures
```bash
# Check container logs
docker logs <container_name>

# Inspect container state
docker inspect <container_name>

# Restart specific service
docker-compose -f srcs/docker-compose.yml restart <service_name>
```

#### Database Connection Issues
```bash
# Test database connectivity
docker exec wordpress wp db check

# Reset database password
docker exec mariadb mysql -u root -p -e "ALTER USER 'wp_user'@'%' IDENTIFIED BY 'new_password';"
```

### Performance Issues

#### High Memory Usage
```bash
# Monitor container resource usage
docker stats

# Optimize PHP memory limit
docker exec wordpress echo "memory_limit = 256M" >> /etc/php83/php.ini
```

#### Slow Database Performance
```bash
# Check MariaDB status
docker exec mariadb mysql -u root -p -e "SHOW PROCESSLIST;"

# Optimize database
docker exec mariadb mysql -u root -p -e "OPTIMIZE TABLE wp_posts;"
```

This developer documentation provides comprehensive guidance for setting up, developing, and maintaining the Inception project. It includes practical examples, troubleshooting steps, and advanced configuration options to support both beginners and experienced developers.