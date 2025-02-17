#!/bin/sh
set -x

if ! id "prueba" >/dev/null 2>&1; then
  echo "Creando usuario 'prueba'..."
  adduser -s /bin/ash -d /home/vsftpd -m prueba
  echo "prueba:prueba" | chpasswd
  [ -f /etc/shells ] || touch /etc/shells
  if ! grep -q "^/bin/ash" /etc/shells; then
    echo "/bin/ash" >> /etc/shells
  fi
fi

echo "Iniciando vsftpd..."
/usr/sbin/run-vsftpd.sh &

echo "Manteniendo el contenedor en ejecución..."
tail -f /dev/null
