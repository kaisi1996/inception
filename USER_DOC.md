# User Documentation

## Overview

This document provides essential information for end users and system administrators who need to manage and interact with the Inception WordPress hosting environment.

## Services Provided

The Inception stack provides the following services:

### Web Services
- **WordPress Website**: A full-featured content management system accessible via HTTPS
- **MariaDB Database**: Backend database service for WordPress data storage
- **Nginx Web Server**: High-performance web server with SSL/TLS termination

### Access Points
- **Main Website**: `https://your-domain.com` (WordPress frontend)
- **WordPress Admin**: `https://your-domain.com/wp-admin` (WordPress administration panel)
- **Database**: Accessible only from within the Docker network (port 3306)

## Starting and Stopping the Project

### Starting the Project

To start all services, use the following command from the project root directory:

```bash
make up
```

This command will:
1. Initialize necessary directories for data storage
2. Build all Docker containers if they don't exist
3. Start all services in the correct order
4. Enable automatic restart on system reboot

**Expected Output:**
```
Launching configuration Inception...
[+] Building 0.0s (0/0)  
[+] Running 4/4
 ✓ Network inception_inception  Created
 ✓ Volume inception_mariadb_data  Created
 ✓ Volume inception_wordpress_data  Created
 ✓ Container mariadb  Started
 ✓ Container wordpress  Started
 ✓ Container nginx  Started
```

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

**Expected Output:**
```
Stopping configuration Inception...
[+] Running 4/4
 ✓ Container nginx  Removed
 ✓ Container wordpress  Removed
 ✓ Container mariadb  Removed
 ✓ Network inception_inception  Removed
```

### Restarting Services

To restart all services:
```bash
make re
```

This will stop and then start all services, useful for applying configuration changes.

## Accessing the Website and Administration Panel

### Website Access

1. **Open your web browser** and navigate to: `https://your-domain.com`
   
   **Note**: You may see a browser security warning due to the self-signed SSL certificate. This is normal for development environments. Click "Advanced" and "Proceed to website" to continue.

2. **WordPress Frontend**: You should see the WordPress homepage with the title "My WordPress" and description "Inception"

### Administration Panel Access

1. **Navigate to**: `https://your-domain.com/wp-admin`

2. **Login with Administrator Credentials** (from your `.env` file):
   - **Username**: `admin` (or your `WP_ADMIN_LOGIN`)
   - **Password**: (your `WP_ADMIN_PASSWORD`)

3. **Additional User**: A secondary user with "author" role is also available:
   - **Username**: `editor` (or your `WP_USER_LOGIN`)
   - **Password**: (your `WP_USER_PASSWORD`)

### Available Administrative Features

- **Dashboard**: Overview of site statistics and recent activity
- **Posts**: Create and manage blog posts
- **Media**: Upload and manage images and files
- **Pages**: Create static pages
- **Comments**: Moderate user comments
- **Appearance**: Customize themes and widgets
- **Plugins**: Manage WordPress plugins
- **Users**: Manage user accounts and permissions
- **Tools**: Import/export and other utilities
- **Settings**: Configure site-wide settings

## Locating and Managing Credentials

### Environment Variables File

All sensitive credentials are stored in the `srcs/.env` file:

```bash
# Database Credentials
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_secure_password

# WordPress Credentials
DOMAIN_NAME=your-domain.com
WP_ADMIN_LOGIN=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@your-domain.com
WP_USER_LOGIN=editor
WP_USER_PASSWORD=editor_password
WP_USER_EMAIL=editor@your-domain.com
```

### Security Best Practices

1. **Change Default Passwords**: Always change default passwords before deployment
2. **File Permissions**: Ensure `.env` file has restricted permissions:
   ```bash
   chmod 600 srcs/.env
   ```
3. **Regular Updates**: Periodically update WordPress plugins and themes
4. **Backup Strategy**: Implement regular backups of WordPress files and database

### Accessing Database Directly

For advanced users who need direct database access:

```bash
# Connect to MariaDB container
docker exec -it mariadb mysql -u root -p

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

**Expected Output:**
```
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS     NAMES
xxxxxxxxxxxx   inception-nginx       "nginx -g 'daemon of…"   2 minutes ago   Up 2 minutes   443/tcp   nginx
xxxxxxxxxxxx   inception-wordpress   "/usr/local/bin/creat…"   2 minutes ago   Up 2 minutes   9000/tcp  wordpress
xxxxxxxxxxxx   inception-mariadb     "/init.sh"               2 minutes ago   Up 2 minutes   3306/tcp  mariadb
```

### Service Health Checks

#### 1. Check Nginx Status
```bash
docker exec nginx nginx -t
```
Should return: `nginx: configuration file test is successful`

#### 2. Check WordPress PHP-FPM Status
```bash
docker exec wordpress ps aux | grep php-fpm
```
Should show running PHP-FPM processes

#### 3. Check MariaDB Status
```bash
docker exec mariadb mysqladmin ping -h localhost
```
Should return: `mysqld is alive`

### Log Monitoring

#### View All Service Logs
```bash
docker-compose -f srcs/docker-compose.yml logs
```

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
# Follow logs for all services
docker-compose -f srcs/docker-compose.yml logs -f

# Follow logs for specific service
docker logs -f nginx
```

### Troubleshooting Common Issues

#### Website Not Accessible
1. Check if containers are running: `docker ps`
2. Verify Nginx configuration: `docker exec nginx nginx -t`
3. Check network connectivity: `docker network ls`

#### WordPress Installation Issues
1. Check WordPress container logs: `docker logs wordpress`
2. Verify database connectivity: `docker exec wordpress ping mariadb`
3. Check environment variables in `.env` file

#### Database Connection Problems
1. Verify MariaDB is running: `docker logs mariadb`
2. Test database connection: `docker exec mariadb mysql -u root -p`
3. Check database exists: `SHOW DATABASES;`

### Performance Monitoring

#### Resource Usage
```bash
# Check container resource usage
docker stats

# Check disk usage
docker system df
```

#### Volume Status
```bash
# List all volumes
docker volume ls

# Inspect WordPress volume
docker volume inspect inception_wordpress_data

# Inspect MariaDB volume
docker volume inspect inception_mariadb_data
```

### Emergency Procedures

#### Complete System Reset
If you need to completely reset the system:

```bash
make fclean
```

**Warning**: This will delete all data, including WordPress content and database. Use only if you want to start completely fresh.

#### Data Backup
To backup WordPress data:

```bash
# Backup WordPress files
sudo cp -r /home/$(USER)/data/wordpress_vol /path/to/backup/

# Backup MariaDB data
sudo cp -r /home/$(USER)/data/mariadb_vol /path/to/backup/
```

#### Data Restoration
To restore from backup:

```bash
# Stop services
make down

# Restore WordPress files
sudo cp -r /path/to/backup/wordpress_vol/* /home/$(USER)/data/wordpress_vol/

# Restore MariaDB data
sudo cp -r /path/to/backup/mariadb_vol/* /home/$(USER)/data/mariadb_vol/

# Start services
make up
```