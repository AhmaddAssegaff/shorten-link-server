# Docker Networks

Simple network setup to separate traffic and improve security.

## Networks

| Name        | Purpose                              | Security                     |
| ----------- | ------------------------------------ | ---------------------------- |
| public-net  | Entry point (Nginx / gateway)        | Open to external traffic     |
| backend-net | App & database communication         | Fully isolated from outside  |
| obs-net     | Telemetry (OTel, Tempo, etc.)        | For observability data only  |
| mgmt-net    | Admin tools (Jenkins, pgAdmin, etc.) | Restricted management access |

## Init

```bash
docker network create public-net
docker network create backend-net --internal
docker network create obs-net --internal
docker network create mgmt-net --internal

or just run the bash file in this directory
chmod +x network/*.sh
```

## Inspect network

```bash
docker network inspect public-net
docker network inspect backend-net
docker network inspect obs-net
docker network inspect mgmt-net
```

## ⚠️ Notes

* Create once, no need to run again
* Use `external: true` in other compose files
* Only `public-net` should be exposed
* Keep other networks internal for security

