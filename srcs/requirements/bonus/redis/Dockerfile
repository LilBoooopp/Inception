FROM debian:bookworm

RUN apt-get update && apt-get install -y redis-server

RUN sed -i "s|bind 127.0.0.1|bind 0.0.0.0|g" /etc/redis/redis.conf
RUN sed -i "s|# maxmemory <bytes>|maxmemory 256mb|g" /etc/redis/redis.conf
RUN sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis/redis.conf
RUN sed -i "s|protected-mode yes|protected-mode no|g" /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]

