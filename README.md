# Monitoring GitLab Stack

Стек мониторинга и GitLab на основе Docker с автоматизацией через Ansible. Проект предоставляет готовое решение для развертывания GitLab с интегрированным мониторингом на базе Prometheus, Grafana и Node Exporter, а также включает PlantUML сервер для создания диаграмм.

## Возможности

- **GitLab CE**
  - Полнофункциональный GitLab с настроенным проксированием через Nginx
  - Оптимизированная конфигурация для средних нагрузок
  - Автоматическое резервное копирование

- **Мониторинг**
  - Prometheus для сбора метрик
  - Grafana с преднастроенными дашбордами
  - Node Exporter для системных метрик

- **Дополнительные сервисы**
  - PlantUML сервер для UML диаграмм
  - Nginx как reverse proxy
  - Автоматическое обновление версий контейнеров

## Предварительные требования

### Сервер
- Debian 12
- Минимум 4GB RAM
- 20GB свободного места на диске
- Открытые порты: 80, 9999

### Локальная машина
- Git
- SSH доступ к серверу

### Домены
- Настроенные DNS записи для:
  - gitlab.ваш-домен
  - metrics.ваш-домен

## Быстрая установка

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd monitoring-gitlab-stack
```

2. Создайте файл `ansible/inventory/hosts.yml`:

```yaml
all:
hosts:
monitoring_server:
ansible_host: ваш_ip
    ansible_user: ваш_пользователь
    ansible_become: yes
    ansible_become_method: sudo
```

3. Настройте домены в `configs/nginx/default.conf`:

```nginx
server {
    server_name metrics.ваш-домен;
        ...
}
server {
    server_name gitlab.ваш-домен;
        ...
}
```

4. Запустите установку:

```bash
chmod +x setup.sh
./setup.sh
```

## Доступ к сервисам

### GitLab
- URL: http://gitlab.ваш-домен
- Первый вход:
  - Логин: root
  - Пароль: находится в логах GitLab
  ```bash
  docker-compose logs gitlab | grep 'Password:'
  ```

### Grafana
- URL: http://metrics.ваш-домен
- Учетные данные по умолчанию:
  - Логин: admin
  - Пароль: admin

### PlantUML
- URL: http://ваш-ip:9999
- Не требует аутентификации

## Мониторинг

### Доступные метрики
- Системные ресурсы
  - CPU, RAM, Диск
  - Сетевой трафик
  - Файловые дескрипторы
- GitLab метрики
- Nginx статистика

### Дашборды
Преднастроенные дашборды находятся в `dashboards/`:
- OS General - основные системные метрики
- Добавьте свои дашборды в эту директорию


### Проверка новых версий
```bash
chmod +x check_versions.sh
./check_versions.sh
```
Скрипт:
- Проверяет наличие обновлений образов
- Создает резервную копию docker-compose.yml
- Предлагает автоматическое обновление

### Применение обновлений
После обновления версий:
```bash
cd /opt/monitoring
docker-compose up -d
```

## Резервное копирование

### GitLab
- Расположение: `/var/opt/gitlab/backups`
- Периодичность: еженедельно
- Хранение: 7 дней

### Grafana
- Данные хранятся в Docker volume: grafana_data
- Дашборды можно экспортировать через UI

## Обслуживание

### Проверка состояния

```bash
Статус контейнеров
docker-compose ps
Логи
docker-compose logs [сервис]
Использование ресурсов
docker stats
```
### Перезапуск сервисов
```bash
docker-compose restart [сервис]
```

## Устранение неполадок

### Общие проблемы
1. GitLab не запускается
   - Проверьте RAM: `free -m`
   - Проверьте логи: `docker-compose logs gitlab`

2. Grafana недоступна
   - Проверьте Nginx конфигурацию
   - Проверьте DNS записи

3. Метрики не собираются
   - Проверьте доступность Node Exporter
   - Проверьте конфигурацию Prometheus

### Логи
```bash
Все логи
docker-compose logs
Конкретный сервис
docker-compose logs [сервис] --tail 100
```
## Структура проекта
├── ansible/ # Ansible конфигурация
│ ├── inventory/ 
│ └── roles/ # Роли
├── configs/ # Конфигурационные файлы
│ ├── grafana/
│ ├── nginx/
│ └── prometheus/
├── dashboards/ # Дашборды Grafana
├── docker-compose.yml # Docker Compose файл
├── setup.sh # Скрипт установки
└── check_versions.sh # Скрипт обновления


