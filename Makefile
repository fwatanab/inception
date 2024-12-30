# Makefile for the Inception Project

# Variables
SRC_DIR := srcs
DC_FILE := $(SRC_DIR)/docker-compose.yml
ENV_FILE := $(SRC_DIR)/.env

# .envからVOLUME_DIRを読み込み
VOLUME_DIR := $(shell grep ^VOLUME_DIR $(ENV_FILE) | cut -d '=' -f2)
MARIADB_DIR := $(VOLUME_DIR)/mariadb_data
WORDPRESS_DIR := $(VOLUME_DIR)/wordpress_data

# Colors
GREEN := "\033[1;32m"
RED := "\033[1;31m"
RESET := "\033[0m"

# Default Target
all: up

# Initialize Required Directories
init:
	@echo $(GREEN)"Initializing Directories for Volumes..."$(RESET)
	@if [ ! -d "$(MARIADB_DIR)" ]; then \
		sudo mkdir -p "$(MARIADB_DIR)" && sudo chmod 755 "$(MARIADB_DIR)"; \
		echo $(GREEN)"$(MARIADB_DIR) created."$(RESET); \
	fi
	@if [ ! -d "$(WORDPRESS_DIR)" ]; then \
		sudo mkdir -p "$(WORDPRESS_DIR)" && sudo chmod 755 "$(WORDPRESS_DIR)"; \
		echo $(GREEN)"$(WORDPRESS_DIR) created."$(RESET); \
	fi

# Build and Run Containers
up: init
	@echo $(GREEN)"Building and Starting Containers..."$(RESET)
	@sudo docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) up --build -d

# Stop Containers
down:
	@echo $(RED)"Stopping Containers..."$(RESET)
	@sudo docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) down

# Clean Containers and Volumes
clean:
	@echo $(RED)"Removing Containers, Networks, and Volumes..."$(RESET)
	@sudo docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) down -v
	@echo $(RED)"Removing Local Volume Directories..."$(RESET)
	@sudo rm -fr $(VOLUME_DIR)

# Rebuild Everything
re: clean all

# List Docker Status
status:
	@echo $(GREEN)"Listing Docker Containers:"$(RESET)
	@sudo docker ps -a

# Check Logs
logs:
	@echo $(GREEN)"Displaying Logs for All Services:"$(RESET)
	@sudo docker-compose -f $(DC_FILE) logs

.PHONY: all up down clean re status logs init

