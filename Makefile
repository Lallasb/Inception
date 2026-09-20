RUN = docker compose  up  -d --build
DOWN = docker compose down
CLEAR = docker compose  down -v
DATA = /home/lasoubai/data/

all:
	@mkdir -p $(DATA)/mariadb $(DATA)/wordpress
	@cd src && $(RUN)

down:
	@cd src && $(DOWN)

clear:
	@cd src && $(CLEAR)

fclean: clear
	@sudo rm -rf $(DATA)/mariadb/*
	@sudo rm -rf $(DATA)/wordpress/*

re: clear all

.PHONY: all down re clear fclean