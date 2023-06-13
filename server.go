package main

import (
	"fmt"
	"net"
)

func main() {
	// Configura el servidor proxy para escuchar en el puerto 25565
	listener, err := net.Listen("tcp", "0.0.0.0:25565")
	if err != nil {
		fmt.Println("Error al iniciar el servidor proxy:", err)
		return
	}

	fmt.Println("Servidor proxy de Minecraft en marcha en localhost:25565")

	// Acepta conexiones entrantes
	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("Error al aceptar la conexión:", err)
			continue
		}

		// Maneja cada conexión en una goroutine separada
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	// Conéctate al servidor de Spigot en el puerto 25566
	serverConn, err := net.Dial("tcp", "mc.librecraft.com:25565")
	if err != nil {
		fmt.Println("Error al conectar al servidor de Spigot:", err)
		return
	}

	fmt.Println("Cliente conectado:", conn.RemoteAddr())

	// Copia los datos del cliente al servidor y viceversa
	go copyData(conn, serverConn)
	go copyData(serverConn, conn)
}

func copyData(src net.Conn, dest net.Conn) {
	defer src.Close()
	defer dest.Close()

	buffer := make([]byte, 1024)
	for {
		// Lee datos del origen
		n, err := src.Read(buffer)
		if err != nil {
			fmt.Println("Error al leer datos:", err)
			break
		}

		// Escribe los datos en el destino
		_, err = dest.Write(buffer[:n])
		if err != nil {
			fmt.Println("Error al escribir datos:", err)
			break
		}
	}

	fmt.Println("Conexión cerrada:", src.RemoteAddr())
}
