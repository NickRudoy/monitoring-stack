#!/bin/bash

# Локальный запуск стека мониторинга
echo "🚀 Запуск локального стека мониторинга..."

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker Desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен"
    exit 1
fi

# Создание необходимых директорий
echo "📁 Создание директорий..."
mkdir -p configs/prometheus
mkdir -p dashboards
mkdir -p logs

# Копирование конфигурации Prometheus для локального использования
if [ ! -f "configs/prometheus/prometheus.yml" ]; then
    echo "📋 Копирование конфигурации Prometheus..."
    cp configs/prometheus/prometheus.local.yml configs/prometheus/prometheus.yml
fi

# Запуск сервисов
echo "🐳 Запуск Docker контейнеров..."
docker-compose -f docker-compose.local.yml up -d

# Ожидание запуска сервисов
echo "⏳ Ожидание запуска сервисов..."
sleep 10

# Проверка статуса
echo "📊 Статус сервисов:"
docker-compose -f docker-compose.local.yml ps

echo ""
echo "🎉 Стек мониторинга запущен!"
echo ""
echo "📱 Доступные сервисы:"
echo "  • GitLab:        http://localhost:8080"
echo "  • Grafana:       http://localhost:3000 (admin/admin)"
echo "  • Prometheus:    http://localhost:9090"
echo "  • Node Exporter: http://localhost:9100"
echo "  • PlantUML:      http://localhost:9999"
echo "  • Portainer:     http://localhost:9000"
echo ""
echo "🔑 GitLab пароль можно получить командой:"
echo "   docker-compose -f docker-compose.local.yml logs gitlab | grep 'Password:'"
echo ""
echo "🛑 Для остановки используйте:"
echo "   docker-compose -f docker-compose.local.yml down"
