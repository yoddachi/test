# Define la imagen base de Go
FROM golang:1.16-alpine as builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de código fuente al contenedor
COPY . .

# Compila la aplicación Go
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Crea una nueva imagen ligera para ejecutar la aplicación
FROM alpine:latest

# Instala dependencias necesarias
RUN apk --no-cache add ca-certificates

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /root/

# Copia el ejecutable de la aplicación desde el builder
COPY --from=builder /app/app .

# Expone el puerto en el que la aplicación escucha
EXPOSE 25565

# Define el comando para ejecutar la aplicación
CMD ["./app"]
Para construir y ejecutar el contenedor en Google Cloud Run, sigue estos pasos:

Asegúrate de tener Docker instalado en tu máquina local.

Crea un archivo llamado Dockerfile en el directorio raíz de tu proyecto Go y pega el contenido del Dockerfile proporcionado.

Abre una terminal, navega hasta el directorio raíz de tu proyecto y ejecuta el siguiente comando para construir la imagen del contenedor:

shell
Copy code
docker build -t server .
Reemplaza nombre-imagen con el nombre que deseas darle a tu imagen Docker.

Una vez que se complete la construcción de la imagen, puedes probarla localmente ejecutando el siguiente comando:

shell
Copy code
docker run -p 8080:8080 nombre-imagen
Esto ejecutará el contenedor y expondrá el puerto 8080 para acceder a tu aplicación.

Si la prueba



