#!/bin/bash

SERVICES=("pg-admin" "postgre" "jenkins" "monitoring" "observability")

echo "=== Docker Service ==="
echo ""
echo "Select action:"
echo "1) Up (create + start)"
echo "2) Down (stop + remove)"
echo "3) Restart"
echo "4) Stop"
echo "5) Start existing containers"
echo ""

read -p "Enter your choice (1-5): " action

echo ""
echo "Select services (separate with space):"
echo ""

for i in "${!SERVICES[@]}"; do
    echo "$((i + 1))) ${SERVICES[$i]}"
done

echo ""
read -p "Enter numbers (example: 1 2 3): " choices

echo ""

read -p "Are you sure? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

for num in $choices; do
    index=$((num - 1))
    svc=${SERVICES[$index]}

    if [ -z "$svc" ]; then
        echo "Invalid selection: $num"
        continue
    fi

    case $action in
    1)
        echo "Up $svc..."
        docker compose -p $svc -f $svc/docker-compose.yml up -d
        ;;
    2)
        echo "Down $svc..."
        docker compose -p $svc -f $svc/docker-compose.yml down
        ;;
    3)
        echo "Restart $svc..."
        docker compose -p $svc -f $svc/docker-compose.yml restart
        ;;
    4)
        echo "Stop $svc..."
        docker compose -p $svc -f $svc/docker-compose.yml stop
        ;;
    5)
        echo "Start $svc..."
        docker compose -p $svc -f $svc/docker-compose.yml start
        ;;
    *)
        echo "Invalid action"
        exit 1
        ;;
    esac
done
