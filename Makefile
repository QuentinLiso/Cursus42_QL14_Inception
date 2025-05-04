
# ********************************* VARIABLES
DOMAIN	=	qliso.42.fr
IP	=	127.0.0.1


# ********************************* 1
# First make rule, calls add-host and inception
all: add-host inception


# ********************************* 2
# docker compose up		: builds docker images and run docker containers from services specified in the file 
# 				 	-f	: specify which docker compose file we want to use
#					-d	: run docker containers in background and print container ID
inception: add-folders-volumes
	docker compose -f srcs/docker-compose.yml up -d

# ********************************* 3
# docker compose down		: stop and removes containers
# 				 		-f	: specify which docker compose file we want to use
#					--volumes : remove volumes
#					--rmi all : remove images
clean: remove-host
	docker compose -f srcs/docker-compose.yml down --volumes --rmi all
	rm -rf /home/qliso/data/

# ********************************* 4
# creates the /home/qliso/date folders to store the containers volumes
add-folders-volumes:
	mkdir -p /home/qliso/data/wordpress && mkdir -p /home/qliso/data/mariadb && mkdir -p /home/qliso/data/website

# ********************************* 5
# add host qliso.42.fr to the /etc/hosts file
# /etc/hosts is a sudo protected file, so to write into it, we echo "something" and pipe with the tee command
# grep -q : write nothing to stdout, only exit with 0 if grep found something, 1 otherwise
# 	tee : read from standard input and write to standard output and files
#	 -a : append to the given file
add-host:
	@if ! grep -q  "$(DOMAIN)" /etc/hosts; then \
		echo "Adding $(DOMAIN) to hosts..." ; \
		echo "$(IP) $(DOMAIN)" | sudo tee -a /etc/hosts > /dev/null; \
		echo "$(DOMAIN) added to hosts !"; \
	else \
		echo "$(DOMAIN) already in hosts !"; \
	fi

# ********************************* 6
# remove host qliso.42.fr from the /etc/hosts file
# sed -i.bak : edit files in place (makes backup if SUFFIX supplied, which is the case with .bak here)
remove-host:
	@echo "Removing $(DOMAIN) to hosts..."
	@sudo sed -i.bak "/$(DOMAIN)/d" /etc/hosts
	@echo "$(DOMAIN) removed from hosts !"

# ********************************* OPTIONAL
# install filezilla if not installed
filezilla:
	@ if ! which filezilla | grep -q "filezilla"; then \
		echo "Installing FileZilla..."; \
		sudo apt-get update -y && sudo apt-get install -y filezilla; \
		echo "FileZilla installed !" ; \
	else \
		echo "FileZilla already installed !"; \
	fi
