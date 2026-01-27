FROM debian:bookworm

RUN apt-get update && apt-get install -y wget tar

RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz
RUN tar -xvf portainer-2.19.4-linux-amd64.tar.gz
RUN chmod +x /portainer/portainer

EXPOSE 9443

CMD ["/portainer/portainer"]
