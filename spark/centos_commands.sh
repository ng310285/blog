# Commands to get the spark cluster up and running on a CentOS VM
# 
# Run this script as the root user

yum update

wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.1.ce-1.el7.centos.x86_64.rpm
yum install ./docker-ce-17.03.1.ce-1.el7.centos.x86_64.rpm

systemctl start docker

curl -L https://github.com/docker/compose/releases/download/1.11.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#git clone https://github.com/ng310285/blog.git
#cd blog/spark
#docker build -t spark-2:latest .
#/usr/local/bin/docker-compose up
