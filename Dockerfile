# Define la imagen base de Go
FROM golang:1.16-alpine as builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de código fuente al contenedor
COPY . .

# Compila la aplicación Go
RUN go build -o server .

# Crea una nueva imagen ligera para ejecutar la aplicación
FROM alpine:latest

# Instala dependencias necesarias
RUN apk --no-cache add ca-certificates

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /root/

# Copia el ejecutable de la aplicación desde el builder
COPY --from=builder /app/server .

# Expone el puerto en el que la aplicación escucha
EXPOSE 25565
