Документация скрипта 
Этот скрипт предназначен для управления сетевым соединением на интерфейсе eth0 в операционной системе Linux с использованием NetworkManager. Он проверяет наличие соединения с именем LAN1 и в зависимости от результата выполняет следующие действия:

1.Проверка существования соединения LAN1: Скрипт использует команду nmcli con show, чтобы получить список всех активных соединений, и ищет в нем строку с именем LAN1 с помощью grep -q. Если соединение найдено, выполняется удаление, если нет — создание нового соединения.
2.Удаление соединения LAN1 (если оно существует): Если соединение LAN1 найдено, скрипт выполняет команду nmcli con delete LAN1 для его удаления. Ошибки перенаправляются в /dev/null, чтобы они не отображались в терминале. После удаления выводится сообщение "Соединение LAN1 удалено."
3.Удаление всех существующих соединений на интерфейсе eth0 и создание LAN1 (если LAN1 отсутствует): Если соединение LAN1 не найдено, скрипт выполняет следующие шаги:

  -Получает список всех соединений, привязанных к интерфейсу eth0, с помощью nmcli -t -f NAME,DEVICE con show, фильтрует строки, заканчивающиеся на :eth0, и извлекает имена соединений с помощью cut -d: -f1.
  -В цикле for удаляет каждое найденное соединение на интерфейсе eth0 с помощью nmcli con delete, выводя сообщение об удалении каждого соединения.
  -Создает новое соединение с именем LAN1 на интерфейсе eth0 с помощью nmcli con add type ethernet ifname eth0 con-name LAN1 ipv4.method auto ipv6.method auto. Соединение настраивается на автоматическое получение IP-адресов через DHCP.
  -Проверяет, было ли соединение успешно создано, с помощью nmcli con show и grep -q LAN1.
  -Если создание прошло успешно, модифицирует соединение, добавляя домен поиска expnet.ru с помощью nmcli con mod LAN1 ipv4.dns-search "expnet.ru".
  -Активирует соединение командой nmcli con up LAN1 и выводит сообщение "Создано и активировано новое соединение LAN1 с доменом поиска expnet.ru".
  -Если создание не удалось, выводит сообщение об ошибке "Ошибка: не удалось создать соединение LAN1" и завершает выполнение с кодом ошибки 1.
  -Скрипт требует прав root для выполнения команд NetworkManager и предполагает, что интерфейс eth0 существует и NetworkManager используется для управления сетью.

АВТОМАТИЗАЦИЯ ВЫПОЛНЕНИЯ  ОТ ОБЫЧНОГО ПОЛЬЗОВАТЕЛЯ

Перемести скрипт и дай права
sudo mv reset_connection.sh /usr/local/bin/

sudo chmod +x /usr/local/bin/reset_connection.sh

Настрой sudoers для запуска без пароля
sudo visudo

Добавь строку в конец файла, заменив username на имя твоего пользователя
username ALL=(ALL) NOPASSWD: /usr/local/bin/reset_connection.sh

Важно что бы эта строчка находилась желательно выше других так как порядок имеет значение.

Это разрешает пользователю alex запускать только этот скрипт через sudo без ввода пароля.
Сохрани изменения и выйди (в visudo это обычно Ctrl+O, Enter, Ctrl+X).

Теперь обычный пользователь может запускать скрипт так:
sudo /usr/local/bin/reset_connection.sh

===============
Упрощённый запуск через алиас
Чтобы не писать sudo каждый раз, можно добавить алиас в файл ~/.bashrc пользователя:
alias resetnet='sudo /usr/local/bin/reset_connection.sh'

Сохрани и обнови настройки
source ~/.bashrc

Теперь достаточно просто ввести resetnet в терминале, и скрипт выполнится.
