name = inception

LOGIN = cbopp

WORDPRESS_DATA = /home/$(LOGIN)/data/wordpress
MARIADB_DATA = /home/$(LOGIN)/data/mariadb

all:
	@printf "Launch configuration ${name}...\n"
	@mkdir -p $(WORDPRESS_DATA)
	@mkdir -p $(MARIADB_DATA)

	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a

fclean: clean
	@printf "Total clean of all docker configurations\n"
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

	@sudo rm -rf /home/$(LOGIN)/data/wordpress
	@sudo rm -rf /home/$(LOGIN)/data/mariadb

	@mkdir -p $(WORDPRESS_DATA)
	@mkdir -p $(MARIADB_DATA)

.PHONY: all down re clean fclean
