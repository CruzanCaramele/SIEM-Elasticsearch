#!/bin/bash 
set -e

sudo yum update -y

# install java which is required for ELK stack
yum install -y java-1.8.0-openjdk

# import public signing key for elasticsearch
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# move rpm repositories to required location
sudo mv /vagrant/files/elasticsearch.repo /etc/yum.repos.d/

echo "elasticsearch repo file moved"

# # move sample log files to var directory
# sudo mv /vagrant/files/messages /var/log/messages
# sudo mv /vagrant/files/secure /var/log/secure

sudo echo "log files moved"

# install elasticsearch and start
echo "installing elasticsearch"
sudo yum install -y elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service


# install kibana and start
echo "installing kibana"
sudo yum install -y kibana

sudo mv /vagrant/files/kibana.yml /etc/kibana/kibana/yml
sudo chown root:root /etc/kibana/kibana.yml

sudo systemctl enable kibana.service
sudo systemctl start kibana.service


# install filebeat
echo "installing filebeat and metricbeat"
sudo yum install -y filebeat
sudo yum install -y metricbeat

# replace system.yml.disabled file
#sudo rm -f /etc/filebeat/modules.d/system.yml.disabled
sudo mv /vagrant/files/system.yml.disabled /etc/filebeat/modules.d/system.yml.disabled
sudo mv /vagrant/files/metricbeat.yml /etc/metricbeat/metricbeat.yml

# enable filebeat system module
sudo filebeat modules enable system
echo "system module enabled"

sudo chown root:root /etc/filebeat/modules.d/system.yml
sudo chown root:root /etc/metricbeat/metricbeat.yml

# install geo-ip filer plugin
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install -b ingest-geoip

sudo systemctl restart elasticsearch.service && sleep 1m

sudo echo "elasticsearch restarted"

sudo filebeat setup && sleep 1m
sudo metricbeat setup && sleep 70
echo "filebeat is now setup"

sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
echo "filebeat started"

sudo systemctl enable metricbeat.service
sudo systemctl start metricbeat.service
echo "metricbeat started"




