#!/bin/bash
# create networks
docker network create public-net 2>/dev/null || echo "public-net already exists"
docker network create backend-net 2>/dev/null || echo "backend-net already exists"
docker network create mgmt-net 2>/dev/null || echo "mgmt-net already exists"
docker network create obs-net 2>/dev/null || echo "obs-net already exists"
echo "All networks created"
