FROM debian:bookworm

RUN apt-get update && apt-get install -y vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 20 21 21100-21110

ENTRYPOINT ["/usr/local/bin/script.sh"]
