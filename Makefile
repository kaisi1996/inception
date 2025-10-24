NAME = Inception

all: up

up:
	@echo "Launching configuration $(NAME)..."
	@bash srcs/requirements/wordpress/tools/init_dir.sh 
	@docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@echo "Stopping configuration $(NAME)..."
	@docker compose -f srcs/docker-compose.yml --env-file srcs/.env down

re: down up

clean: down
	@echo "Cleaning configuration $(NAME)..."
	@yes | docker system prune --all

fclean: down
	@echo "Total clean of all Docker configurations"
	@yes | docker system prune --all
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf /home/$(USER)/data
	@sudo rm -rf /home/$(USER)/Downloads

rebuild: fclean up

.PHONY = start all build down re clean fclean

