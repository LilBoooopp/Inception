FROM debian:bookworm

RUN apt-get update && apt-get install -y php php-mysql wget

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/adminer.php

WORKDIR /var/www/html
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "adminer.php"]

