#!/bin/bash

# Путь к файлу службы
service_file="/lib/systemd/system/prometheus-node-exporter.service"

# Новая строка ExecStart
new_execstart='ExecStart=/usr/bin/prometheus-node-exporter $ARGS --collector.disable-defaults --collector.textfile --collector.stat --collector.uname --collector.meminfo --collector.cpu --collector.loadavg --collector.filesystem --collector.diskstats --collector.netstat --collector.sockstat --collector.netdev'

# Замена строки ExecStart на новую строку
sed -i "/^ExecStart/c\\$new_execstart" "$service_file"

# Перезагрузка конфигурации systemd и перезапуск службы
systemctl daemon-reload
systemctl restart prometheus-node-exporter

echo "Строка ExecStart успешно обновлена в файле $service_file и служба перезапущена."
