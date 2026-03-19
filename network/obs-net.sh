#!/bin/bash
docker network create obs-net --internal 2>/dev/null || echo "obs-net already exists"
