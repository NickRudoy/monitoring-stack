#!/bin/bash

# Проверка наличия Ansible
if ! command -v ansible &> /dev/null; then
    echo "Ansible не установлен. Установка..."
    sudo apt update
    sudo apt install -y ansible
fi

# Проверка наличия файла inventory
if [ ! -f "ansible/inventory/hosts.yml" ]; then
    echo "Файл inventory не найден. Пожалуйста, создайте файл ansible/inventory/hosts.yml"
    exit 1
fi

# Запуск плейбука с подробным выводом
ansible-playbook -i ansible/inventory/hosts.yml ansible/site.yml -vv