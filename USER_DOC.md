# User Documentation

## Overview

This document provides essential information for end users and system administrators who need to manage and interact with the Inception WordPress hosting environment.

## Services Provided

The Inception stack provides the following services:

### Web Services
- **WordPress Website**: A full-featured content management system accessible via HTTPS
- **MariaDB Database**: Backend database service for WordPress data storage
- **Nginx Web Server**: High-performance web server with SSL/TLS termination

## Starting and Stopping the Project

### Starting the Project

To start all services, use the following command from the project root directory:

```bash
make
```

This command will:
1. Initialize necessary directories for data storage
2. Build all Docker containers if they don't exist
3. Start all services in the correct order

### Stopping the Project

To stop all services while preserving data:

```bash
make down
```

This will:
- Stop all running containers
- Remove the containers
- Preserve all data in Docker volumes
- Keep the network configuration

## Accessing the Website and Administration Panel

### Website Access

**Open your web browser** and navigate to: `aalkaisi.42.fr`
   
   **Note**: You may see a browser security warning due to the self-signed SSL certificate. This is normal for development environments. Click "Advanced" and "Proceed to website" to continue.

### Administration Panel Access

1. **Navigate to**: `aalkaisi.42.fr/wp-admin`

2. **Login with Administrator Credentials** (from your `.env` file):
   - **Username**: (your `WP_ADMIN_LOGIN`)
   - **Password**: (your `WP_ADMIN_PASSWORD`)

## Locating and Managing Credentials

### Environment Variables File

All sensitive credentials should be stored in the `srcs/.env` file:

```bash
# Database Credentials
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_secure_password

# WordPress Credentials
DOMAIN_NAME=your-domain.com
WP_ADMIN_EMAIL=admin@your-domain.com
WP_USER_LOGIN=editor
WP_USER_PASSWORD=editor_password
WP_USER_EMAIL=editor@your-domain.com
```

### Accessing Database Directly

For advanced users who need direct database access:

```bash
# Connect to MariaDB container
docker exec -it mariadb sh

# Login using root user. Note: you need to put the root password afterward
mariadb -u root -p;

# Use the WordPress database
USE wordpress;

# Exit MySQL
EXIT
```

## Checking Service Status

### Docker Container Status

To check if all services are running correctly:

```bash
docker ps
```

### Service Health Checks

#### View Specific Service Logs
```bash
# Nginx logs
docker logs nginx

# WordPress logs
docker logs wordpress

# MariaDB logs
docker logs mariadb
```

#### Real-time Log Monitoring
```bash
# Follow logs for specific service
docker logs -f nginx
```

