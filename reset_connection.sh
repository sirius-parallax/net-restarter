#!/bin/bash

# Имя интерфейса (замени на свой)
INTERFACE="eth0"

# Имя соединения
CONNECTION_NAME="LAN1"

# Удаляем существующее соединение
nmcli con delete "$CONNECTION_NAME" 2>/dev/null

# Создаём новое соединение
nmcli con add type ethernet ifname "$INTERFACE" con-name "$CONNECTION_NAME" \
    ipv4.method auto \
    ipv6.method auto \
    dns-search "expnet.ru"

# Активируем соединение
nmcli con up "$CONNECTION_NAME"

echo "Интернет-соединение пересоздано с доменом поиска expnet.ru"
