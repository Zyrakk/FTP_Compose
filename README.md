# VSFTPD

Este repositorio contiene la configuración necesaria para desplegar un servidor FTP seguro utilizando `vsftpd` dentro de un contenedor Docker.

## Archivos incluidos

### 1. `docker-compose.yml`

Este archivo define el servicio `vsftpd` con la imagen `fauria/vsftpd`, mapea los puertos necesarios y monta los volúmenes para los datos, la configuración y los certificados SSL.

```yaml
version: '3'
services:
  vsftpd:
    image: fauria/vsftpd
    container_name: vsftpd
    ports:
      - "21:21"
      - "21000-21010:21000-21010"
    volumes:
      - ./data:/home/vsftpd
      - ./vsftpd.conf:/etc/vsftpd.conf:ro
      - ./certs:/etc/ssl/certs:ro
      - ./ssl_private:/etc/ssl/private:ro
    environment:
      - FTP_USER=prueba
      - FTP_PASS=prueba
      - PASV_ADDRESS=127.0.0.1
      - PASV_MIN_PORT=21000
      - PASV_MAX_PORT=21010
```

### 2. `vsftpd.conf`

Archivo de configuración de `vsftpd`, donde se habilita el acceso anónimo, se establecen límites de conexión y se configura FTPS.

```ini
# vsftpd.conf para contenedor Docker

listen=YES
anonymous_enable=YES
anon_root=/var/ftp
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ftpd_banner=Welcome to vsftpd service.
max_clients=2
max_per_ip=2
idle_session_timeout=3600
data_connection_timeout=3600

# Configuración FTPS
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
rsa_cert_file=/etc/ssl/certs/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.key
```

## Generación de Certificados SSL

Antes de ejecutar el contenedor, es necesario generar los certificados SSL para FTPS. Utiliza el siguiente comando:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl_private/vsftpd.key -out certs/vsftpd.pem
```

Este comando generará dos archivos:

- `vsftpd.pem`: Certificado público.
- `vsftpd.key`: Clave privada.

Coloca estos archivos en las carpetas `certs` y `ssl_private` respectivamente.

## Despliegue

Para iniciar el servidor FTP, ejecuta:

```sh
docker-compose up -d
```

El servidor estará disponible en el puerto `21` para conexiones FTP y usará los puertos `21000-21010` para conexiones en modo pasivo.

## Acceso y pruebas

Puedes conectarte utilizando un cliente FTP como `FileZilla`, configurando los siguientes parámetros:

- **Servidor:** `127.0.0.1`
- **Usuario:** `prueba`
- **Contraseña:** `prueba`
- **Modo:** Activo o Pasivo (dependiendo de la configuración del cliente)

Si todo está configurado correctamente, deberías poder acceder al servicio FTP y transferir archivos de manera segura.

## Notas adicionales

- La configuración fuerza el uso de SSL para los usuarios locales, garantizando que las credenciales no sean enviadas en texto plano.
- El acceso anónimo está habilitado solo en modo lectura.
- Se han limitado las conexiones a `2` por cliente para evitar abusos.

---

# Pure-FTPD

Este repositorio contiene la configuración necesaria para desplegar un servidor FTP seguro utilizando `Pure-FTPD` dentro de un contenedor Docker.

## Archivos incluidos

### 1. `docker-compose.yml`
Este archivo define el servicio `pure-ftpd` con la imagen `stilliard/pure-ftpd`, mapea los puertos necesarios y establece variables de entorno para la configuración del servidor FTP.

```yaml
version: '3'
services:
  pureftpd:
    image: stilliard/pure-ftpd
    container_name: pure-ftpd
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    environment:
      PUBLICHOST: "127.0.0.1"
      FTP_USER_NAME: "ftpuser"
      FTP_USER_PASS: "ftppass"
      FTP_USER_HOME: "/home/ftpusers/ftpuser"
      MAXCLIENTS: "2"
      MAXCONNECTIONS: "2"
      TIMEOUT_IDLE: "3600"
      TLS: "1"
      ADDED_FLAGS: "--tls=2 --certfile=/etc/ssl/certs/pure-ftpd.pem --keyfile=/etc/ssl/private/pure-ftpd.key"
    volumes:
      - ./data:/home/ftpusers
      - ./certs:/etc/ssl/certs:ro
      - ./ssl_private:/etc/ssl/private:ro
```

## Generación de Certificados SSL
Antes de ejecutar el contenedor, es necesario generar los certificados SSL para FTPS. Utiliza el siguiente comando:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl_private/pure-ftpd.key -out certs/pure-ftpd.pem
```

Este comando generará dos archivos:
- `pure-ftpd.pem`: Certificado público.
- `pure-ftpd.key`: Clave privada.

Coloca estos archivos en las carpetas `certs` y `ssl_private` respectivamente.

## Configuración de Usuarios Virtuales

Para agregar usuarios virtuales y enjaular sus directorios, usa los siguientes comandos dentro del contenedor:

```sh
pure-pw useradd <nombre_usuario> -u ftpuser -d /home/ftpusers/<nombre_usuario>
pure-pw mkdb
```

Si deseas aplicar una cuota de 100MB a un usuario, ejecuta:

```sh
pure-pw usermod <nombre_usuario> -N 100 -m
```

## Despliegue

Para iniciar el servidor FTP, ejecuta:

```sh
docker-compose up -d
```

El servidor estará disponible en el puerto `21` para conexiones FTP y usará los puertos `30000-30009` para conexiones en modo pasivo.

## Acceso y pruebas

Puedes conectarte utilizando un cliente FTP como `FileZilla`, configurando los siguientes parámetros:
- **Servidor:** `127.0.0.1`
- **Usuario:** `ftpuser`
- **Contraseña:** `ftppass`
- **Modo:** Activo o Pasivo (dependiendo de la configuración del cliente)

Si todo está configurado correctamente, deberías poder acceder al servicio FTP y transferir archivos de manera segura.

## Notas adicionales
- Se utiliza TLS para encriptar las credenciales de los usuarios y transferencias de datos.
- Se ha limitado el número de conexiones simultáneas para evitar abusos.
- Es posible gestionar usuarios virtuales y aplicar cuotas según sea necesario.

---

# ProFTPD

Este repositorio contiene la configuración necesaria para desplegar un servidor FTP seguro utilizando `ProFTPD` dentro de un contenedor Docker. 

## Archivos incluidos

### 1. `Dockerfile`
Este archivo se encarga de construir la imagen de `ProFTPD` basada en Debian, instalando ProFTPD y los módulos necesarios para FTPS y gestión de cuotas.

### 2. `docker-compose.yml`
Define el servicio `proftpd`, mapea los puertos necesarios y monta los volúmenes requeridos para los datos y la configuración.

```yaml
version: '3'
services:
  proftpd:
    build: .
    container_name: proftpd
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - ./data:/var/ftp
```

### 3. `proftpd.conf`
Archivo de configuración de `ProFTPD` que incluye:
- Acceso anónimo restringido a solo lectura.
- Autenticación virtual con archivos de credenciales (`ftpd.passwd`, `ftpd.group`).
- Configuración de FTPS con certificados SSL.
- Gestión de cuotas con los archivos `ftpquota.limittab` y `ftpquota.tallytab`.

```ini
ServerName                      "ProFTPD Server"
ServerType                      standalone
DefaultServer                   on
Port                            21
MaxInstances                    2

<Global>
  TimeoutNoTransfer 3600
  TimeoutSession    3600
</Global>

# Acceso Anónimo
<Anonymous /var/ftp/anonymous>
  User                          ftp
  Group                         nogroup
  UserAlias                     anonymous ftp
  MaxClients                    2 "Sorry, max %m users -- try again later"
  <Directory *>
    <Limit WRITE>
      DenyAll
    </Limit>
  </Directory>
</Anonymous>

# Autenticación Virtual
AuthUserFile /etc/proftpd/ftpd.passwd
AuthGroupFile /etc/proftpd/ftpd.group
RequireValidShell off

# Configuración FTPS
TLSEngine                     on
TLSLog                        /var/log/proftpd/tls.log
TLSProtocol                   TLSv1 TLSv1.1 TLSv1.2
TLSRSACertificateFile         /etc/ssl/certs/proftpd.pem
TLSRSACertificateKeyFile      /etc/ssl/private/proftpd.key
TLSRequired                   on

# Configuración de Cuotas
<IfModule mod_quotatab.c>
  QuotaEngine on
  QuotaDirectoryTally on
  QuotaLimitTable /etc/proftpd/ftpquota.limittab
  QuotaTallyTable /etc/proftpd/ftpquota.tallytab
</IfModule>
```

### 4. `ftpquota.limittab` y `ftpquota.tallytab`
Archivos de configuración para la gestión de cuotas de usuarios. La cuota predeterminada es de 100MB.

## Generación de Certificados SSL
Antes de ejecutar el contenedor, es necesario generar los certificados SSL para FTPS. Utiliza el siguiente comando:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl_private/proftpd.key -out certs/proftpd.pem
```

Este comando generará dos archivos:
- `proftpd.pem`: Certificado público.
- `proftpd.key`: Clave privada.

Coloca estos archivos en las carpetas `certs` y `ssl_private` respectivamente.

## Despliegue

Para iniciar el servidor FTP, ejecuta:

```sh
docker-compose up -d --build
```

El servidor estará disponible en el puerto `21` para conexiones FTP y usará los puertos `30000-30009` para conexiones en modo pasivo.

## Acceso y pruebas

Puedes conectarte utilizando un cliente FTP como `FileZilla`, configurando los siguientes parámetros:
- **Servidor:** `127.0.0.1`
- **Usuario:** Según los datos en `ftpd.passwd`
- **Modo:** Activo o Pasivo (dependiendo de la configuración del cliente)

Si todo está configurado correctamente, deberías poder acceder al servicio FTP y transferir archivos de manera segura.

## Notas adicionales
- Se utiliza FTPS para encriptar las credenciales de los usuarios y transferencias de datos.
- Se ha limitado el número de conexiones simultáneas a `2` para evitar abusos.
- Es posible gestionar usuarios virtuales a través de archivos de autenticación.
- La gestión de cuotas permite limitar el almacenamiento de los usuarios a 100MB por defecto.
