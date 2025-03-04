#!/bin/bash

# Имя интерфейса
INTERFACE="eth0"

# Имя целевого соединения
CONNECTION_NAME="LAN1"

# Проверка существования соединения LAN1
if nmcli con show | grep -q "$CONNECTION_NAME"; then
    # Если LAN1 существует, удаляем его
    nmcli con delete "$CONNECTION_NAME" 2>/dev/null
    echo "Соединение $CONNECTION_NAME удалено."
else
    # Если LAN1 не существует, удаляем все соединения на интерфейсе eth0
    for conn in $(nmcli -t -f NAME,DEVICE con show | grep ":$INTERFACE$" | cut -d: -f1); do
        nmcli con delete "$conn" 2>/dev/null
        echo "Удалено соединение: $conn"
    done

    # Создаём новое соединение LAN1 без dns-search
    nmcli con add type ethernet ifname "$INTERFACE" con-name "$CONNECTION_NAME" \
        ipv4.method auto \
        ipv6.method auto

    # Проверяем, успешно ли создано соединение
    if nmcli con show | grep -q "$CONNECTION_NAME"; then
        # Устанавливаем домен поиска expnet.ru
        nmcli con mod "$CONNECTION_NAME" ipv4.dns-search "expnet.ru"

        # Активируем соединение
        nmcli con up "$CONNECTION_NAME"
        echo "Создано и активировано новое соединение $CONNECTION_NAME с доменом поиска expnet.ru"
    else
        echo "Ошибка: не удалось создать соединение $CONNECTION_NAME"
        exit 1
    fi
fi
