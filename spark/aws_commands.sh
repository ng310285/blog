# Commands to get the spark cluster up and running on AWS
# Using an AWS Linux instance (large or larger, to get enough memory)
sudo yum update
sudo yum install docker
sudo pip install docker-compose
sudo yum install git
sudo service docker start

git clone https://github.com/ng310285/blog.git
cd blog/spark
sudo docker build -t spark-2:latest .
sudo /usr/local/bin/docker-compose up
