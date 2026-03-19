#!/bin/bash
docker network create public-net 2>/dev/null || echo "public-net already exists"
