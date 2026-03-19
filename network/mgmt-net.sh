#!/bin/bash
docker network create mgmt-net --internal 2>/dev/null || echo "mgmt-net already exists"

