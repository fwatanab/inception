# Makefile for the Inception Project

# Variables
SRC_DIR := srcs
DC_FILE := $(SRC_DIR)/docker-compose.yml
ENV_FILE := $(SRC_DIR)/.env

# Colors
GREEN := "\033[1;32m"
RED := "\033[1;31m"
RESET := "\033[0m"

# Default Target
all: up

# Build and Run Containers
up:
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

.PHONY: all up down clean re status logs
