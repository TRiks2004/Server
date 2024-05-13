# ------------------------------------------------------------------------------

network ?= default_network

network-create:
	sudo docker network create $(network) 

network-check:
	@echo "Проверка сети $(network)..."
	@if ! sudo docker network inspect $(network) > /dev/null 2>&1; then \
		echo "Сеть $(network) не найдена. Создание сети..."; \
		make network-create network=$(network); \
	else \
		echo "Сеть $(network) уже существует."; \
	fi

frontend-network-check:
	make network-check network="frontend-global_network"

backend-network-check:
	make network-check network="backend-global_network"
# ------------------------------------------------------------------------------

container-up: frontend-network-check backend-network-check
	sudo docker compose -f ./$(path_dir)/docker-compose.yml up -d

container-down:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml down

container-restart:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml restart

container-ps:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml ps

container-config:
	sudo docker compose -f ./$(path_dir)/docker-compose.yml config

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

nextcloud-config:
	make container-config path_dir=$(nextcloud)

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

npm-config:
	make container-config path_dir=$(npm)

npm-echo-name-dir:
	make name-dir-echo path_dir=$(npm)

# ==============================================================================

postgresCursovik := "postgresCursovik"

postgresCursovik-up:
	make container-up path_dir=$(postgresCursovik)

postgresCursovik-down:
	make container-down path_dir=$(postgresCursovik)

postgresCursovik-restart:
	make container-restart path_dir=$(postgresCursovik)		

postgresCursovik-config:
	make container-config path_dir=$(postgresCursovik)

postgresCursovik-md5-password:
	echo "md5"&(echo -n '$(password)$(user)' | md5sum | awk '{print $1}')

postgresCursovik-ps:
	make container-ps path_dir=$(postgresCursovik)

# ==============================================================================

portainer := "portainer"

portainer-up:
	make container-up path_dir=$(portainer)

portainer-down:
	make container-down path_dir=$(portainer)

portainer-restart:
	make container-restart path_dir=$(portainer)		

portainer-config:
	make container-config path_dir=$(portainer)

portainer-ps:
	make container-ps path_dir=$(portainer)

portainer-echo-name-dir:
	make name-dir-echo path_dir=$(portainer)

# ==============================================================================

vaultwarden := "vaultwarden"

vaultwarden-up:
	make container-up path_dir=$(vaultwarden)

vaultwarden-down:
	make container-down path_dir=$(vaultwarden)

vaultwarden-restart:
	make container-restart path_dir=$(vaultwarden)		

vaultwarden-config:
	make container-config path_dir=$(vaultwarden)

vaultwarden-ps:
	make container-ps path_dir=$(vaultwarden)

vaultwarden-echo-name-dir:
	make name-dir-echo path_dir=$(vaultwarden)

# ==============================================================================

all-up: npm-up nextcloud-up portainer-up
all-down: npm-down nextcloud-down portainer-up
all-restart: npm-restart nextcloud-restart portainer-up

all-echo-name-dir: npm-echo-name-dir nextcloud-echo-name-dir postgresCursovik-ps portainer-echo-name-dir vaultwarden-echo-name-dir

# ==============================================================================

create-token:
	openssl rand -base64 48