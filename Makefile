SHELL=/bin/bash
# UID and GID are now primarily passed as build args in docker-compose.yml
# These are kept for Makefile context if needed, but docker compose commands will use what's in the yml.
UID=$(shell id -u)
GID=$(shell id -g)

.PHONY: help init up down stop restart build ps logs shell artisan composer install fresh-db seed

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help              Show this help message"
	@echo "  init              Initialize a new Laravel project, create .env, and set up symlinks"
	@echo "  up                Start the Docker containers"
	@echo "  down              Stop and remove the Docker containers, networks, and volumes"
	@echo "  stop              Stop the Docker containers"
	@echo "  restart           Restart the Docker containers"
	@echo "  build             Build or rebuild the Docker images"
	@echo "  ps                List running Docker containers"
	@echo "  logs              Show logs from the app container (Ctrl+C to stop)"
	@echo "  logs-nginx        Show logs from the nginx container (Ctrl+C to stop)"
	@echo "  logs-db           Show logs from the db container (Ctrl+C to stop)"
	@echo "  shell             Access the app container shell as current user (using UID from docker-compose build args)"
	@echo "  root-shell        Access the app container shell as root"
	@echo "  artisan ARGS=\"...\" Run an Artisan command (e.g., make artisan ARGS=\"migrate\")"
	@echo "  composer ARGS=\"...\" Run a Composer command (e.g., make composer ARGS=\"install\")"
	@echo "  install           Run composer install and npm install & build"
	@echo "  fresh-db          Drop all tables and re-run migrations"
	@echo "  seed              Run database seeders"

init: build up
	@echo "--------------------------------------------------------------------------"
	@echo "Initializing new Laravel project in the current directory..."
	@echo "This will download Laravel and install it into the current directory."
	@echo "--------------------------------------------------------------------------"
	# Create project, move files, update .env.example, .env, and .gitignore
	docker compose exec app bash -c "\
		composer create-project --prefer-dist laravel/laravel /tmp/laravel-temp && \
		shopt -s dotglob && mv /tmp/laravel-temp/* /var/www/ && shopt -u dotglob && \
		 \
		cd /var/www/ && \
		 \
		echo \"Updating .env.example for Docker environment...\" && \
		sed -i 's/^APP_URL=.*/APP_URL=http:\/\/localhost:8000/' .env.example && \
		sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' .env.example && \
		sed -i 's/^DB_HOST=.*/DB_HOST=db/' .env.example && \
		sed -i 's/^DB_PORT=.*/DB_PORT=3306/' .env.example && \
		sed -i 's/^DB_DATABASE=.*/DB_DATABASE=laravel_db/' .env.example && \
		sed -i 's/^DB_USERNAME=.*/DB_USERNAME=laravel_user/' .env.example && \
		sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=laravel_password/' .env.example && \
		sed -i 's/^REDIS_HOST=.*/REDIS_HOST=redis/' .env.example && \
		sed -i 's/^REDIS_PASSWORD=.*/REDIS_PASSWORD=null/' .env.example && \
		sed -i 's/^REDIS_PORT=.*/REDIS_PORT=6379/' .env.example && \
		 \
		echo \"Updating .env for Docker environment (APP_KEY should be preserved)...\" && \
		sed -i 's/^APP_URL=.*/APP_URL=http:\/\/localhost:8000/' .env && \
		sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' .env && \
		sed -i 's/^DB_HOST=.*/DB_HOST=db/' .env && \
		sed -i 's/^DB_PORT=.*/DB_PORT=3306/' .env && \
		sed -i 's/^DB_DATABASE=.*/DB_DATABASE=laravel_db/' .env && \
		sed -i 's/^DB_USERNAME=.*/DB_USERNAME=laravel_user/' .env && \
		sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=laravel_password/' .env && \
		sed -i 's/^REDIS_HOST=.*/REDIS_HOST=redis/' .env && \
		sed -i 's/^REDIS_PASSWORD=.*/REDIS_PASSWORD=null/' .env && \
		sed -i 's/^REDIS_PORT=.*/REDIS_PORT=6379/' .env && \
		 \
		(echo \"\" && echo \"# Custom symlinks created by Makefile init\" && echo \"/env\") >> .gitignore && \
		 \
		rm -rf /tmp/laravel-temp && \
		echo 'Successfully initialized project, configured .env files, and updated .gitignore.' || \
		echo 'ERROR: Project initialization failed. Check logs above.'"
	@echo ""
	@echo "--------------------------------------------------------------------------"
	@echo "Laravel project created. .env file and APP_KEY should be auto-generated."
	@echo "Creating symlinks on the host machine..."
	@echo "--------------------------------------------------------------------------"
	@if [ -f .env ]; then \
		ln -sf .env env; \
		echo "Created symlink: env -> .env"; \
	else \
		echo "Error: .env file not found on host. Cannot create 'env' symlink. This might happen if Laravel installation failed or .env was not created."; \
	fi
	@if [ -f .env.example ]; then \
		ln -sf .env.example env-example; \
		echo "Created symlink: env-example -> .env.example"; \
	else \
		echo "Error: .env.example file not found on host. Cannot create 'env-example' symlink. This might happen if Laravel installation failed."; \
	fi
	@echo ""
	@echo "--------------------------------------------------------------------------"
	@echo "Project initialization complete!"
	@echo "--------------------------------------------------------------------------"
	@echo "Next steps:"
	@echo "  1. IMPORTANT: Review and customize your .env file."
	@echo "     Ensure DB_HOST=db, DB_DATABASE=laravel_db, DB_USERNAME=laravel_user, DB_PASSWORD=laravel_password, REDIS_HOST=redis."
	@echo "  2. Run 'make install' to install additional PHP (vendor) and JS dependencies and build assets."
	@echo "  3. Run 'make fresh-db' to set up the database schema."
	@echo "  4. Optionally, run 'make seed' if you have database seeders."
	@echo "--------------------------------------------------------------------------"

up:
	docker compose up -d

down:
	docker compose down -v

stop:
	docker compose stop

restart:
	docker compose restart

build:
	# UID and GID are passed to docker compose build via environment variables
	# which are then used by args in docker-compose.yml
	docker compose build --no-cache

ps:
	docker compose ps

logs:
	docker compose logs -f app

logs-nginx:
	docker compose logs -f nginx

logs-db:
	docker compose logs -f db

shell:
	# The -u flag in exec will be based on the user created in Dockerfile (sail, with UID/GID from build args)
	docker compose exec app bash

root-shell:
	docker compose exec app bash

artisan:
	docker compose exec app php artisan $(ARGS)

composer:
	docker compose exec app composer $(ARGS)

install:
	make composer ARGS="install"
	docker compose exec app npm install
	docker compose exec app npm run build

fresh-db:
	make artisan ARGS="migrate:fresh"

seed:
	make artisan ARGS="db:seed"