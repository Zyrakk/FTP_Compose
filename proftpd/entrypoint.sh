#!/bin/bash
set -e

# Crear directorio para el usuario virtual "prueba"
mkdir -p /var/ftp/prueba

# Crear el usuario virtual "prueba" (se utilizará "prueba" como contraseña)
echo "prueba" | ftpasswd --passwd --name=prueba --uid=1001 --gid=1001 --home=/var/ftp/prueba --shell=/bin/false --stdin
ftpasswd --group --name=ftpusers --gid=1001 --member=prueba

# Crear los ficheros (tablas) de cuotas
ftpquota --create-table --type=limit --table-path=/etc/proftpd/ftpquota.limittab
ftpquota --create-table --type=tally --table-path=/etc/proftpd/ftpquota.tallytab

# Añadir las cuotas para el usuario "prueba"
ftpquota --add-record --type=limit --name=prueba --quota-type=user --bytes-upload=100 --bytes-download=100 --units=Mb --files-upload=15 --files-download=50 --table-path=/etc/proftpd/ftpquota.limittab
ftpquota --add-record --type=tally --name=prueba --quota-type=user

# Iniciar ProFTPD en modo primer plano
exec /usr/sbin/proftpd --nodaemon
