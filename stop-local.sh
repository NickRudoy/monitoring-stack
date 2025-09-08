#!/bin/bash

# Остановка локального стека мониторинга
echo "🛑 Остановка локального стека мониторинга..."

# Остановка контейнеров
docker-compose -f docker-compose.local.yml down

echo "✅ Стек мониторинга остановлен"
echo ""
echo "💾 Данные сохранены в Docker volumes:"
echo "  • GitLab данные: gitlab_data"
echo "  • Grafana данные: grafana_data"
echo "  • Prometheus данные: prometheus_data"
echo ""
echo "🗑️  Для полного удаления данных используйте:"
echo "   docker-compose -f docker-compose.local.yml down -v"
