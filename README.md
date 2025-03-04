# net-restarter
Перемести скрипт и дай права
sudo mv reset_connection.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/reset_connection.sh

Настрой sudoers для запуска без пароля
sudo visudo

Добавь строку в конец файла, заменив username на имя твоего пользователя
username ALL=(ALL) NOPASSWD: /usr/local/bin/reset_connection.sh

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
