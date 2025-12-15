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
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	@echo "Total clean of all Docker configurations"
	@sudo rm -rf /home/$(USER)/data
	@sudo rm -rf /home/$(USER)/Downloads

rebuild: fclean up

.PHONY = all up down re clean fclean rebuild

