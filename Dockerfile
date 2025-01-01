# Gunakan Alpine sebagai base image
FROM alpine:latest

# Install Redis
RUN apk add --no-cache redis

# Tentukan direktori kerja
WORKDIR /app

# Salin konfigurasi Redis atau file aplikasi kamu jika ada
COPY . .

# Expose port default Redis
EXPOSE 6379

# Perintah untuk menjalankan Redis server
CMD ["redis-server", "/app/redis.conf"]
