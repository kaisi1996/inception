*This project has been created as part of the 42 curriculum by aalkaisi.*

# Inception

## Description

Inception is a comprehensive Docker-based project that implements a secure, multi-service web hosting infrastructure. The project demonstrates advanced containerization concepts by deploying a complete WordPress stack with MariaDB database, all orchestrated through Docker Compose and secured with SSL/TLS encryption.

The goal of this project is to build a resilient web hosting environment that follows industry best practices for containerization, security, and service orchestration. This infrastructure provides a complete (Nginx, MariaDB, WordPress) running in isolated Docker containers with persistent data storage and secure communication channels.

## Instructions

### Prerequisites
- Docker and Docker Compose installed on your system
- Make utility for automated build and deployment
- A browser to check the project

### Installation and Execution

1. **Clone the repository**
   ```bash
   git clone <link>
   cd inception
   ```

2. **Configure environment variables**
   Create a `.env` file in the `srcs/` directory with your configuration:
   ```bash
   # Database Configuration
   MYSQL_ROOT_PASSWORD=your_secure_root_password
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wordpress_user
   MYSQL_PASSWORD=your_secure_password

   # WordPress Configuration
   DOMAIN_NAME=your-domain.com
   WP_ADMIN_EMAIL=admin@your-domain.com
   WP_USER_LOGIN=editor
   WP_USER_PASSWORD=editor_password
   WP_USER_EMAIL=editor@your-domain.com
   ```

3. **Build and launch the project**
   ```bash
   make
   ```
   This command will:
   - Initialize necessary directories
   - Build all Docker images
   - Start all services in detached mode

4. **Access your WordPress site**
   - Open your browser and navigate to `aalkaisi.42.fr`
   - Use the admin credentials from your `.env` file to access the WordPress dashboard

### Management Commands
- `make up`: Start all services
- `make down`: Stop all services
- `make re`: Restart all services
- `make clean`: Stop services and clean unused Docker resources
- `make fclean`: Complete cleanup including volumes and data directories
- `make rebuild`: Complete rebuild from scratch

## Resources

### Documentation and References
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [WordPress Codex](https://codex.wordpress.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Alpine Linux Documentation](https://wiki.alpinelinux.org/wiki/Main_Page)

### Articles and Tutorials
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [WordPress Docker Deployment Guide](https://developer.wordpress.org/cli/commands/)
- [SSL/TLS Configuration for Nginx](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)

### AI Usage

AI was utilized in this project for the following tasks:

1. **Documentation Generation**: AI assistance was used to create a sample of README.md, USER_DOC.md, and DEV_DOC.md files with proper formatting and structure.

2. **Troubleshooting Guidance**: AI provided assistance in debugging container orchestration issues.

## Project Design Choices

### Docker Implementation

This project uses Docker to create a containerized web hosting environment with the following design considerations:

1. **Service Isolation**: Each component (Nginx, WordPress, MariaDB) runs in separate containers for security and maintainability
2. **Resource Efficiency**: Alpine Linux base images minimize container size and attack surface
3. **Automated Configuration**: Custom scripts handle service initialization and WordPress setup

### Technology Comparisons

#### Virtual Machines vs Docker
**Virtual Machines** provide complete hardware virtualization with full operating systems, offering strong isolation but requiring significant resources and longer startup times.

**Docker** uses OS-level virtualization, sharing the host kernel while providing process isolation. This results in:
- Faster startup times
- Lower resource consumption
- Easier deployment
- More Compatibile

#### Secrets vs Environment Variables
**Docker Secrets** provide encrypted storage for sensitive data, automatic rotation capabilities, and secure distribution to services. However, they are more complex to manage.

**Environment Variables** are simpler to implement, work with Docker Compose, and are easier for development environments. They provide basic security through file permissions but lack encryption.

#### Docker Network vs Host Network
**Docker Network** creates isolated network environments for containers, allowing service discovery by name and providing network segmentation. This enhances security and enables complex multi-container applications.

**Host Network** shares the host's network stack, but eliminating network isolation.

#### Docker Volumes vs Bind Mounts
**Docker Volumes** are managed by Docker, provide cross-platform compatibility, and support volume drivers for advanced storage solutions. They offer better performance and easier backup capabilities.

**Bind Mounts** map host filesystem paths directly into containers, providing direct access but creating platform dependencies and potential permission issues.

