# **************************************************************************** #
#                                   INCEPTION                                  #
# **************************************************************************** #

COMPOSE_FILE = ./srcs/docker-compose.yml
PROJECT_NAME = inception

# Volume names
VOLUME_WP = wp_data
VOLUME_DB = db_data
VOLUME_CERTS = certs

# Default target
all: config up

config:
	@if ! grep -q asanni /etc/hosts; then \
		echo "127.0.0.1 asanni.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	fi

	@if [ ! -d "/home/asanni/data/wordpress" ]; then \
		sudo mkdir -p /home/asanni/data/wordpress; \
	fi
	@if [ ! -d "/home/asanni/data/mariadb" ]; then \
		sudo mkdir -p /home/asanni/data/mariadb; \
	fi

# -----------------------------------------------------------------------------#
# Build containers without starting them
# -----------------------------------------------------------------------------#
build:
	@docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) build

# -----------------------------------------------------------------------------#
# Start containers (builds automatically if needed)
# -----------------------------------------------------------------------------#
up:
	@docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) up --build -d

# -----------------------------------------------------------------------------#
# Stop containers but keep data
# -----------------------------------------------------------------------------#
down:
	@docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) down

# -----------------------------------------------------------------------------#
# Remove all containers and images but keep volumes
# -----------------------------------------------------------------------------#
clean: down
	@docker system prune -af

# -----------------------------------------------------------------------------#
# Full cleanup: containers, images, volumes, networks
# -----------------------------------------------------------------------------#
fclean: down
	@docker volume rm -f $(VOLUME_WP) $(VOLUME_DB) $(VOLUME_CERTS)
	@docker system prune -af
	@docker network rm $(PROJECT_NAME)_inception 2>/dev/null || true
	@sudo rm -fr /home/asanni

# -----------------------------------------------------------------------------#
# Rebuild everything from zero
# -----------------------------------------------------------------------------#
re: fclean all

# -----------------------------------------------------------------------------#
# Utility: Show running containers
# -----------------------------------------------------------------------------#
ps:
	@docker ps

# -----------------------------------------------------------------------------#
# Utility: Show volumes
# -----------------------------------------------------------------------------#
volumes:
	@docker volume ls

.PHONY: all build up down clean fclean re ps volumes
