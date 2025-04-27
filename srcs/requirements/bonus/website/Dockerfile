FROM debian:bullseye

RUN apt-get update -y && apt-get install -y python3

COPY files/index.html /var/www/html/index.html
COPY files/hobbies.html /var/www/html/hobbies.html
COPY files/contactme.html /var/www/html/contactme.html

WORKDIR /var/www/html

CMD ["python3", "-m", "http.server", "8080"]
