FROM debian:bookworm

RUN apt-get update && apt-get install -y python3

RUN mkdir -p /var/www/html

COPY conf/index.html /var/www/html/index.html

WORKDIR /var/www/html
EXPOSE 8000
CMD ["python3", "-m", "http.server", "8000"]

