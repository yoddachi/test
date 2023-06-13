# Build stage
FROM golang:1.14.2 as build

RUN go run server
