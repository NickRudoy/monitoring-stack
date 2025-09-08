# Локальный стек мониторинга и GitLab

Упрощенная версия стека мониторинга для локальной разработки без привязки к доменам.

## 🚀 Быстрый старт

### Предварительные требования
- Docker Desktop
- Docker Compose
- 4GB+ RAM
- 10GB+ свободного места

### Запуск
```bash
# Клонируйте репозиторий
git clone <repository-url>
cd monitoring-stack

# Запустите стек
./start-local.sh
```

### Остановка
```bash
./stop-local.sh
```

## 📱 Доступные сервисы

| Сервис | URL | Учетные данные |
|--------|-----|----------------|
| **GitLab** | http://localhost:8080 | root / [см. пароль ниже] |
| **Grafana** | http://localhost:3000 | admin / admin |
| **Prometheus** | http://localhost:9090 | - |
| **Node Exporter** | http://localhost:9100 | - |
| **PlantUML** | http://localhost:9999 | - |
| **Portainer** | http://localhost:9000 | - |

## 🔑 Получение пароля GitLab

```bash
docker-compose -f docker-compose.local.yml logs gitlab | grep 'Password:'
```

## 🏗️ Архитектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitLab CE     │    │    Grafana      │    │   Prometheus    │
│  localhost:8080 │    │  localhost:3000 │    │ localhost:9090  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Node Exporter  │
                    │ localhost:9100  │
                    └─────────────────┘
```

## 📊 Мониторинг

### Доступные метрики
- **Системные**: CPU, RAM, диск, сеть
- **GitLab**: (опционально, требует настройки)
- **Docker**: (опционально, требует настройки)

### Дашборды Grafana
- **OS General**: основные системные метрики
- Добавьте свои дашборды в папку `dashboards/`

## ⚙️ Конфигурация

### GitLab
- Внешний URL: `http://localhost:8080`
- SSH порт: `2222`
- Оптимизирован для локального использования

### Prometheus
- Конфигурация: `configs/prometheus/prometheus.local.yml`
- Хранение данных: 200 часов
- Автоматическое перезагрузка конфигурации

### Grafana
- Пароль администратора: `admin`
- Регистрация новых пользователей отключена
- Дашборды загружаются из папки `dashboards/`

## 🔧 Управление

### Просмотр логов
```bash
# Все сервисы
docker-compose -f docker-compose.local.yml logs

# Конкретный сервис
docker-compose -f docker-compose.local.yml logs gitlab
docker-compose -f docker-compose.local.yml logs grafana
```

### Перезапуск сервиса
```bash
docker-compose -f docker-compose.local.yml restart gitlab
```

### Обновление образов
```bash
# Проверка обновлений
./check_versions.sh

# Обновление
docker-compose -f docker-compose.local.yml pull
docker-compose -f docker-compose.local.yml up -d
```

## 💾 Данные

### Volumes
- `gitlab_data`: данные GitLab
- `grafana_data`: настройки и дашборды Grafana
- `prometheus_data`: метрики Prometheus

### Резервное копирование
```bash
# Создание бэкапа GitLab
docker-compose -f docker-compose.local.yml exec gitlab gitlab-backup create

# Экспорт дашбордов Grafana
# Используйте UI Grafana: Configuration → Data Sources → Export
```

## 🛠️ Разработка

### Добавление новых дашбордов
1. Создайте JSON файл в папке `dashboards/`
2. Перезапустите Grafana: `docker-compose -f docker-compose.local.yml restart grafana`

### Настройка мониторинга GitLab
1. Отредактируйте `configs/prometheus/prometheus.local.yml`
2. Раскомментируйте секцию `gitlab`
3. Перезапустите Prometheus: `docker-compose -f docker-compose.local.yml restart prometheus`

## 🐛 Устранение неполадок

### GitLab не запускается
```bash
# Проверьте логи
docker-compose -f docker-compose.local.yml logs gitlab

# Проверьте использование памяти
docker stats
```

### Grafana недоступна
```bash
# Проверьте статус
docker-compose -f docker-compose.local.yml ps grafana

# Перезапустите
docker-compose -f docker-compose.local.yml restart grafana
```

### Метрики не собираются
```bash
# Проверьте Prometheus
curl http://localhost:9090/api/v1/targets

# Проверьте Node Exporter
curl http://localhost:9100/metrics
```

## 🔄 Отличия от продакшн версии

### Упрощения
- ❌ Убран Nginx reverse proxy
- ❌ Убрана привязка к доменам
- ❌ Убрана Ansible автоматизация
- ❌ Убраны SSL сертификаты

### Добавления
- ✅ Прямой доступ к сервисам через порты
- ✅ Portainer для управления Docker
- ✅ Упрощенные скрипты запуска/остановки
- ✅ Оптимизация для локального использования

## 📝 Лицензия

Этот проект использует открытые компоненты:
- GitLab CE (MIT)
- Grafana (Apache 2.0)
- Prometheus (Apache 2.0)
- Node Exporter (Apache 2.0)
