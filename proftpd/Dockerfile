FROM debian:bullseye-slim

# Instalar ProFTPD, módulos de SSL y cuotas, y OpenSSL
RUN apt-get update && \
    apt-get install -y proftpd-mod-crypto proftpd-mod-quotatab openssl && \
    rm -rf /var/lib/apt/lists/*

# Copiar archivos de configuración y certificados
COPY proftpd.conf /etc/proftpd/proftpd.conf
COPY ftpquota.limittab /etc/proftpd/ftpquota.limittab
COPY ftpquota.tallytab /etc/proftpd/ftpquota.tallytab
COPY certs/proftpd.pem /etc/ssl/certs/proftpd.pem
COPY ssl_private/proftpd.key /etc/ssl/private/proftpd.key

EXPOSE 21 30000-30009

CMD ["proftpd", "--nodaemon"]
