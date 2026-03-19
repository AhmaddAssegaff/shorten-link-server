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
docker compose -f docker-compose.network.yml up -d
```

## ⚠️ Notes

* Create once, no need to run again
* Use `external: true` in other compose files
* Only `public-net` should be exposed
* Keep other networks internal for security

