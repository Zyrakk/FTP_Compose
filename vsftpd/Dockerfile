FROM fauria/vsftpd
# Copiar config de vsftpd al contenedor
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
# Creamos el usuario 'prueba' con home directory /home/vsftpd
RUN adduser -D -h /home/vsftpd -s /bin/ash prueba && \
    echo "prueba:prueba" | chpasswd && \
    echo "/bin/ash" >> /etc/shells
