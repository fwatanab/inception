# Makefile for the Inception Project

# Variables
SRC_DIR := srcs
DC_FILE := $(SRC_DIR)/docker-compose.yml
ENV_FILE := $(SRC_DIR)/.env
DATA_DIR := /home/$(USER)/data
MARIADB_DIR := $(DATA_DIR)/mariadb_data
WORDPRESS_DIR := $(DATA_DIR)/wordpress_data

# Colors
GREEN := "\033[1;32m"
RED := "\033[1;31m"
RESET := "\033[0m"

# Default Target
all: up

# Initialize Required Directories
init:
	@if [ ! -d "$(MARIADB_DIR)" ] || [ ! -d "$(WORDPRESS_DIR)" ]; then \
		echo $(GREEN)"Initializing Directories for Volumes..."$(RESET); \
		if [ ! -d "$(MARIADB_DIR)" ]; then \
			mkdir -p "$(MARIADB_DIR)" && chmod 755 "$(MARIADB_DIR)"; \
		fi; \
		if [ ! -d "$(WORDPRESS_DIR)" ]; then \
			mkdir -p "$(WORDPRESS_DIR)" && chmod 755 "$(WORDPRESS_DIR)"; \
		fi; \
	fi

# Build and Run Containers
up: init
	@echo $(GREEN)"Building and Starting Containers..."$(RESET)
	@docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) up --build -d

# Stop Containers
down:
	@echo $(RED)"Stopping Containers..."$(RESET)
	@docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) down

# Clean Containers and Volumes
clean:
	@echo $(RED)"Removing Containers, Networks, and Volumes..."$(RESET)
	@docker-compose -f $(DC_FILE) --env-file $(ENV_FILE) down -v

# Rebuild Everything
re: clean all

# List Docker Status
status:
	@echo $(GREEN)"Listing Docker Containers:"$(RESET)
	@docker ps -a

# Check Logs
logs:
	@echo $(GREEN)"Displaying Logs for All Services:"$(RESET)
	@docker-compose -f $(DC_FILE) logs

.PHONY: all up down clean re status logs init

