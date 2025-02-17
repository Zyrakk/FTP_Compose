FROM fauria/vsftpd

# Copia tu archivo de configuración personalizado (si lo necesitas)
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

# Copia el script entrypoint y dale permisos de ejecución
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Establece el nuevo entrypoint
ENTRYPOINT ["/entrypoint.sh"]
