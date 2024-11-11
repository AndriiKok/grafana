## 1.	Устанавливаем Node Exporter
Этот софт ставим на все сервера, которые хотим мониторить: <br/>

    bash <(curl -s https://raw.githubusercontent.com/AndriiKok/grafana/refs/heads/main/node_exporter.sh)

Скрипт трижды спросит хотите ли вы продолжить, это запрос на удаление и очистку зависимостей предыдущей инсталляции Node Exporter перед новой установкой. <br/>

Проверяем всё ли стало корректно: <br/>

    sudo systemctl status prometheus-node-exporter

## 2.	Устанавливаем Prometheus и Grafana
Выбираем один сервер, на который будем ставить сервис мониторинга, и устанавливаем на него необходимый софт:

    bash <(curl -s https://raw.githubusercontent.com/AndriiKok/grafana/refs/heads/main/Grafana.sh)

Проверяем по очереди всё ли стало корректно:

    sudo systemctl status prometheus
    
    sudo systemctl status grafana-server

При установке мы заменили порт по умолчанию с 3000 на 3002 из-за ноды Ritual, но если при проверке статуса увидели проблему, проверьте первым делом не занят ли порт 3002 у вас чем-то, что вы ставили самостоятельно.

## 3.	Настраиваем Prometheus
А именно заполняем его конфиг информацией о серверах, которые хотим мониторить. Для этого открываем как удобно файл: 

<div align="center">
<i>/etc/prometheus/prometheus.yml</i>
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/AndriiKok/grafana/refs/heads/main/Pic1.png" alt="Description of image">
</div>

Сейчас здесь информация только про текущий сервер, то есть Grafana отобразит только его в своём дашборде. 

Продублируйте выделенный блок и укажите в нём данные сервера, который хотите добавить в Grafana.

После каждого изменения этого файла делайте рестарт сервиса

    sudo systemctl restart prometheus 

То есть если вы хотите мониторить 10 серверов, у вас должно быть 10 блоков **targets** с соответствующими адресами ваших серверов и именами, какие вы уже придумаете. 

## 4.	Настраиваем Grafana 

- Шаг 1. Переходим на http://АДРЕС_СЕРВЕРА:3002/, входим под **admin/admin** и сразу меняем пароль.

- Шаг 2. Выбираем «**Add data source**» и указываем первый из списка вариант **Prometheus**. Заполняем поле **URL** значением **http://localhost:9090**, далее «**Save & Test**».

- Шаг 3. Переходим на http://АДРЕС_СЕРВЕРА:3002/dashboard/import и в поле «**Or paste JSON**» вставляем весь текст из json файла:

      https://github.com/AndriiKok/grafana/blob/main/Grafana_model.json

Далее **Load**, на следующей странице можем изменить **Name** и далее **Import**

Поздравляю, теперь у вас свой мониторинг. Я убрал из этой модели всё лишнее на мой взгляд, можете покопаться и добавить что-то под себя. 

<div align="center">
<img src="https://raw.githubusercontent.com/AndriiKok/grafana/refs/heads/main/Pic2.png" alt="Description of image">
</div>
 
