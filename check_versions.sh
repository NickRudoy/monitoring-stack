#!/bin/bash

# Функция для получения последней версии образа
get_latest_version() {
    local image=$1
    curl -s "https://hub.docker.com/v2/repositories/${image}/tags?page_size=100" | \
    jq -r '.results[].name' | grep -v 'latest' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1
}

# Массив образов для проверки
declare -A images=(
    ["gitlab/gitlab-ce"]="17.5.1-ce.0"
    ["prom/prometheus"]="v2.48.0"
    ["prom/node-exporter"]="v1.7.0"
    ["grafana/grafana"]="10.2.2"
    ["nginx"]="1.25.3"
    ["plantuml/plantuml-server"]="v1.2023.13"
)

echo "Checking for updates..."
echo "======================="

needs_update=false

for image in "${!images[@]}"; do
    current_version=${images[$image]}
    latest_version=$(get_latest_version "$image")
    
    echo "Image: $image"
    echo "Current version: $current_version"
    echo "Latest version: $latest_version"
    
    if [ "$current_version" != "$latest_version" ]; then
        echo "Update available!"
        needs_update=true
    else
        echo "Up to date"
    fi
    echo "======================="
done

if [ "$needs_update" = true ]; then
    echo "Updates are available. Would you like to update docker-compose.yml? (y/n)"
    read -r answer
    if [ "$answer" = "y" ]; then
        # Создаем резервную копию
        cp docker-compose.yml docker-compose.yml.backup
        
        # Обновляем версии в docker-compose.yml
        for image in "${!images[@]}"; do
            latest_version=$(get_latest_version "$image")
            sed -i "s|image: ${image}:.*|image: ${image}:${latest_version}|g" docker-compose.yml
        done
        
        echo "docker-compose.yml has been updated. Original file backed up as docker-compose.yml.backup"
        echo "Please review the changes and run 'docker-compose up -d' to apply updates"
    fi
fi 