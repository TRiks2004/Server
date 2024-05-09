# ------------------------------------------------------------------------------

network ?= default_network

network-create:
	sudo docker network create $(network) 

network-check:
	@echo "Проверка сети $(network)..."
	@if ! sudo docker network inspect $(network) > /dev/null 2>&1; then \
		echo "Сеть $(network) не найдена. Создание сети..."; \
		network network=$(network); \
	else \
		echo "Сеть $(network) уже существует."; \
	fi

npm-network-check:
	make check-network network="nginx-proxy-manager_network"

# ------------------------------------------------------------------------------

container-up:
	make npm-network-check
	sudo docker compose -f ./$(path_dir)/docker-compose.yml up -d

container-down:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml down

container-restart:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml restart

container-ps:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml ps

name-dir-echo:
	@echo $(path_dir)

# ------------------------------------------------------------------------------

nextcloud := "nextcloud"

nextcloud-up:
	make container-up path_dir=$(nextcloud)

nextcloud-down:
	make container-down path_dir=$(nextcloud)

nextcloud-restart:
	make container-restart path_dir=$(nextcloud)

nextcloud-ps:
	make container-ps path_dir=$(nextcloud)

nextcloud-echo-name-dir:
	make name-dir-echo path_dir=$(nextcloud)

# ------------------------------------------------------------------------------

npm := "nginx\ proxy\ manager"

npm-up:
	make container-up path_dir=$(npm)

npm-down:
	make container-down path_dir=$(npm)

npm-restart:
	make container-restart path_dir=$(npm)

npm-ps:
	make container-ps path_dir=$(npm)

npm-echo-name-dir:
	make name-dir-echo path_dir=$(npm)

# ==============================================================================

all-up: npm-up nextcloud-up
all-down: npm-down nextcloud-down
all-restart: npm-restart nextcloud-restart

all-echo-name-dir: npm-echo-name-dir nextcloud-echo-name-dir
