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
all: up

# -----------------------------------------------------------------------------#
# Build containers without starting them
# -----------------------------------------------------------------------------#
build:
	@docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) build

# -----------------------------------------------------------------------------#
# Start containers (builds automatically if needed)
# -----------------------------------------------------------------------------#
up:
	@docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) up -d

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
