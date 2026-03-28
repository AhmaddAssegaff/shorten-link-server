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
docker compose up -d
```

---

## Notes
* These certificates are **self-signed** and not trusted by browsers by default
* To avoid warnings, import `ca/ca.crt` into your system trust store
* Never expose `ca.key` publicly ❗
---
