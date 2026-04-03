# Generating SSL Certificate (OpenSSL)
Production systems should not use unencrypted traffic.
This guide explains how to generate SSL certificates manually using OpenSSL (without Certbot).

---

## 1. Go to certificates directory

```bash
cd etc/nginx/certs
```

---

## 2. Create Root Certificate Authority (CA)

```bash
mkdir -p ca
cd ca

# Generate private key
openssl genrsa -out ca.key 2048

# Generate root certificate
openssl req -x509 \
  -subj "/CN=Local Dev CA" \
  -nodes \
  -key ca.key \
  -days 3650 \
  -out ca.crt

cd ..
```

---

## 3. Create certificate for `ahmadasgf.my.id`

```bash
mkdir -p ahmadasgf.my.id

openssl req -newkey rsa:2048 -nodes \
  -subj "/CN=ahmadasgf.my.id" \
  -addext "subjectAltName=DNS:ahmadasgf.my.id" \
  -keyout ahmadasgf.my.id/privkey.pem \
  -out ahmadasgf.my.id/server.csr

# Sign with CA
openssl x509 -req \
  -in ahmadasgf.my.id/server.csr \
  -out ahmadasgf.my.id/fullchain.pem \
  -CA ca/ca.crt \
  -CAkey ca/ca.key \
  -CAcreateserial \
  -days 365 \
  -copy_extensions copy

rm ahmadasgf.my.id/server.csr
```

---

## 4. Create certificate for `drone.ahmadasgf.my.id`

```bash
mkdir -p drone.ahmadasgf.my.id

openssl req -newkey rsa:2048 -nodes \
  -subj "/CN=drone.ahmadasgf.my.id" \
  -addext "subjectAltName=DNS:drone.ahmadasgf.my.id" \
  -keyout drone.ahmadasgf.my.id/privkey.pem \
  -out drone.ahmadasgf.my.id/server.csr

# Sign with CA
openssl x509 -req \
  -in drone.ahmadasgf.my.id/server.csr \
  -out drone.ahmadasgf.my.id/fullchain.pem \
  -CA ca/ca.crt \
  -CAkey ca/ca.key \
  -CAcreateserial \
  -days 365 \
  -copy_extensions copy

rm drone.ahmadasgf.my.id/server.csr
```

---

## 5. Configure NGINX
Edit your domain config inside:

```bash
etc/nginx/conf.d/*.conf
```

### Example: `ahmadasgf.my.id.conf`

```nginx
ssl_certificate /etc/nginx/certs/ahmadasgf.my.id/fullchain.pem;
ssl_certificate_key /etc/nginx/certs/ahmadasgf.my.id/privkey.pem;
```

### Example: `drone.ahmadasgf.my.id.conf`

```nginx
ssl_certificate /etc/nginx/certs/drone.ahmadasgf.my.id/fullchain.pem;
ssl_certificate_key /etc/nginx/certs/drone.ahmadasgf.my.id/privkey.pem;
```

---

## 6. Start NGINX

```bash
docker compose up -d nginx
```

---

## Notes
* These certificates are **self-signed** and not trusted by browsers by default
* To avoid warnings, import `ca/ca.crt` into your system trust store
* Never expose `ca.key` publicly ❗
---

# Generating SSL Certificate (certbot)

### change nginx conf ahmadasgf.my.id
```nginx
server {
    listen 80;
    server_name ahmadasgf.my.id www.ahmadasgf.my.id;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}
```

### change nginx conf drone.ahmadasgf.my.id
```nginx
server {
    listen 80;
    server_name drone.ahmadasgf.my.id;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}
```
### run nginx container
```bash
docker compose up -d nginx
```

## generate certificates drone.ahmadasgf.my.id with certbot
```bash
docker run --rm -v $(pwd)/etc/nginx/certs:/etc/letsencrypt -v $(pwd)/etc/nginx/www:/var/www/certbot certbot/certbot certonly --webroot --webroot-path=/var/www/certbot -d drone.ahmadasgf.my.id --email ahmadasgf89@gmail.com --agree-tos --no-eff-email
```

## generate certificates ahmadasgf.my.id with certbot
```bash
docker run --rm -v $(pwd)/etc/nginx/certs:/etc/letsencrypt -v $(pwd)/etc/nginx/www:/var/www/certbot certbot/certbot certonly --webroot --webroot-path=/var/www/certbot -d ahmadasgf.my.id --email ahmadasgf89@gmail.com --agree-tos --no-eff-email
```

### run certbot container
```bash
docker compose up -d certbot 
```

### delete cert (optional)
```bash
docker run -it --rm -v $(pwd)/etc/nginx/certs:/etc/letsencrypt certbot/certbot delete
```
