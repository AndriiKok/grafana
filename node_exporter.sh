#!/bin/bash

#Удаляем node_exporter
sudo systemctl stop node_exporter && systemctl disable node_exporter
sudo apt-get remove prometheus-node-exporter
sudo apt-get purge prometheus-node-exporter
sudo apt-get autoremove

#Удаляем prometheus
sudo systemctl stop prometheus && systemctl disable prometheus
sudo apt-get remove prometheus
sudo rm -rf /etc/prometheus /var/lib/prometheus
sudo apt-get autoremove

#Устанавливаем node_exporter
sudo apt-get update
sudo apt-get install prometheus-node-exporter -y
sudo systemctl enable prometheus-node-exporter && sudo systemctl restart prometheus-node-exporter

# Оптимизируем количество собираемых метрик
service_file="/lib/systemd/system/prometheus-node-exporter.service"
new_execstart='ExecStart=/usr/bin/prometheus-node-exporter $ARGS --collector.disable-defaults --collector.textfile --collector.stat --collector.uname --collector.meminfo --collector.cpu --collector.loadavg --collector.filesystem --collector.diskstats --collector.netstat --collector.sockstat --collector.netdev'
sed -i "/^ExecStart/c\\$new_execstart" "$service_file"
systemctl daemon-reload
systemctl restart prometheus-node-exporter
