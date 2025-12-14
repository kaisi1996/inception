*This project has been created as part of the 42 curriculum by kaisi1996.*

# Inception

## Description

Inception is a comprehensive Docker-based project that implements a secure, multi-service web hosting infrastructure. The project demonstrates advanced containerization concepts by deploying a complete WordPress stack with MariaDB database, all orchestrated through Docker Compose and secured with SSL/TLS encryption.

The goal of this project is to build a resilient web hosting environment that follows industry best practices for containerization, security, and service orchestration. This infrastructure provides a complete LEMP stack (Linux, Nginx, MariaDB, PHP) running in isolated Docker containers with persistent data storage and secure communication channels.

### Key Features
- **Containerized Architecture**: Each service runs in its own isolated Docker container
- **SSL/TLS Security**: Self-signed certificates for encrypted HTTPS communication
- **Persistent Data**: Database and WordPress files are stored in Docker volumes
- **Automated Deployment**: One-command setup using Docker Compose and Makefile
- **Production-Ready**: Includes proper service dependencies, restart policies, and configuration management

## Instructions

### Prerequisites
- Docker and Docker Compose installed on your system
- Make utility for automated build and deployment
- Sufficient permissions to manage Docker containers and volumes

### Installation and Execution

1. **Clone the repository**
   ```bash
   git clone https://github.com/kaisi1996/inception.git
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
   WP_ADMIN_LOGIN=admin
   WP_ADMIN_PASSWORD=admin_password
   WP_ADMIN_EMAIL=admin@your-domain.com
   WP_USER_LOGIN=editor
   WP_USER_PASSWORD=editor_password
   WP_USER_EMAIL=editor@your-domain.com
   ```

3. **Build and launch the project**
   ```bash
   make up
   ```
   This command will:
   - Initialize necessary directories
   - Build all Docker images
   - Start all services in detached mode

4. **Access your WordPress site**
   - Open your browser and navigate to `https://your-domain.com`
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

1. **Documentation Generation**: AI assistance was used to create comprehensive README.md, USER_DOC.md, and DEV_DOC.md files with proper formatting and structure according to 42 curriculum requirements.

2. **Code Review and Optimization**: AI helped review Dockerfile configurations and suggested improvements for security, performance, and maintainability.

3. **Troubleshooting Guidance**: AI provided assistance in debugging container orchestration issues and service dependency problems.

4. **Best Practices Implementation**: AI helped implement industry best practices for Docker security, volume management, and service configuration.

The AI tools were specifically used for:
- Generating project documentation that meets 42 school standards
- Reviewing Docker Compose configuration for optimal service orchestration
- Providing guidance on SSL certificate generation and Nginx configuration
- Suggesting improvements for container security and resource management

All core implementation, architecture decisions, and technical solutions were developed independently, with AI serving as a supportive tool for documentation and code quality enhancement.

## Project Design Choices

### Docker Implementation

This project uses Docker to create a containerized web hosting environment with the following design considerations:

1. **Service Isolation**: Each component (Nginx, WordPress, MariaDB) runs in separate containers for security and maintainability
2. **Resource Efficiency**: Alpine Linux base images minimize container size and attack surface
3. **Automated Configuration**: Custom scripts handle service initialization and WordPress setup
4. **Persistent Storage**: Docker volumes ensure data persistence across container restarts

### Technology Comparisons

#### Virtual Machines vs Docker
**Virtual Machines** provide complete hardware virtualization with full operating systems, offering strong isolation but requiring significant resources and longer startup times.

**Docker** uses OS-level virtualization, sharing the host kernel while providing process isolation. This results in:
- Faster startup times (seconds vs minutes)
- Lower resource consumption
- More efficient resource utilization
- Easier deployment and scaling

**Choice**: Docker was selected for this project due to its efficiency, faster development cycles, and industry adoption for microservices architectures.

#### Secrets vs Environment Variables
**Docker Secrets** provide encrypted storage for sensitive data, automatic rotation capabilities, and secure distribution to services. However, they require Docker Swarm and are more complex to manage.

**Environment Variables** are simpler to implement, work with Docker Compose, and are easier for development environments. They provide basic security through file permissions but lack encryption.

**Choice**: Environment variables were chosen for simplicity and compatibility with Docker Compose, with the understanding that production environments should implement additional security measures.

#### Docker Network vs Host Network
**Docker Network** creates isolated network environments for containers, allowing service discovery by name and providing network segmentation. This enhances security and enables complex multi-container applications.

**Host Network** shares the host's network stack, providing better performance but eliminating network isolation and making port management more complex.

**Choice**: Docker Network was selected to maintain proper service isolation, enable service discovery, and follow container networking best practices.

#### Docker Volumes vs Bind Mounts
**Docker Volumes** are managed by Docker, provide cross-platform compatibility, and support volume drivers for advanced storage solutions. They offer better performance and easier backup capabilities.

**Bind Mounts** map host filesystem paths directly into containers, providing direct access but creating platform dependencies and potential permission issues.

**Choice**: Docker Volumes with bind mount options were selected to combine the benefits of managed volumes with the transparency of host filesystem access for data persistence and backup purposes.