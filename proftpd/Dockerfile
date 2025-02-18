FROM debian:bullseye-slim

# Actualizar repositorios e instalar ProFTPD y herramientas necesarias
RUN apt-get update && apt-get install -y \
    proftpd \
    openssl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copiar la configuración de ProFTPD
COPY proftpd.conf /etc/proftpd/proftpd.conf

# Copiar el script de inicialización
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/entrypoint.sh"]
