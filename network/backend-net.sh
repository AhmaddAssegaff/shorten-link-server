#!/bin/bash
docker network create backend-net --internal 2>/dev/null || echo "backend-net already exists"
