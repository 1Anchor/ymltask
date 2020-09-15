#!/bin/bash

# Массив серверов, с паролем
SERVERS=(
    "192.168.1.100:!1a"
    "192.168.1.110:@2b"
)
# проходимся по массиву
for i in ${!SERVERS[@]}
do
    # преобразуем элемент массива в новый массив через разделитель
    IFS=':' read -ra SERV <<< "${SERVERS[$i]}"

    # объявляем в переменные элементы массива SERV
    ip=${SERV[0]}
    pass=${SERV[1]}

    # подключаемся по ssh к серверу и выполняем команду
    sshpass -p "${pass}" ssh ${ip} -l root "apt update -y && apt install apache2 -y"
    if [ "$?" = "0" ]; then
        echo "Seccess update server ${ip}"
    else
        echo "Error"
        exit 1
    fi
    # любая команда возвращает сигнал true в случае успеха и false если ошибка
    # это условие проверяет чем закончилась команда на сервере
    # в случае успеха, можно уже проверять журнал на сервере
    # а в ошибке обработать откат на сервере
done