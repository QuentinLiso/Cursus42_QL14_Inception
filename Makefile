DOMAIN	=	qliso.42.fr
IP	=	127.0.0.1

all: add-host inception

inception: add-folders-volumes
	docker compose -f srcs/docker-compose.yml up -d

clean: remove-host
	docker compose -f srcs/docker-compose.yml down --volumes --rmi all

add-folders-volumes:
	mkdir -p /home/qliso/data/wordpress && mkdir -p /home/qliso/data/mariadb && mkdir -p /home/qliso/data/website


add-host:
	@if ! grep -q  "$(DOMAIN)" /etc/hosts; then \
		echo "Adding $(DOMAIN) to hosts..." ; \
		echo "$(IP) $(DOMAIN)" | sudo tee -a /etc/hosts > /dev/null; \
		echo "$(DOMAIN) added to hosts !"; \
	else \
		echo "$(DOMAIN) already in hosts !"; \
	fi

remove-host:
	@echo "Removing $(DOMAIN) to hosts..."
	@sudo sed -i.bak "/$(DOMAIN)/d" /etc/hosts
	@echo "$(DOMAIN) removed from hosts !"

filezilla:
	@ if ! which filezilla | grep -q "filezilla"; then \
		echo "Installing FileZilla..."; \
		sudo apt-get update -y && sudo apt-get install -y filezilla; \
		echo "FileZilla installed !" ; \
	else \
		echo "FileZilla already installed !"; \
	fi
