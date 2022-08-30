#!/bin/bash
yum update -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
yum install amazon-linux-extras httpd -y 
amazon-linux-extras install php7.2 -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
cp -r wp-config-sample.php wp-config.php
# DB_HOST=akbar-database.ci6pixnrgmml.us-east-1.rds.amazonaws.com
db_name=`aws ssm get-parameter --name "/ak/db_name" --query 'Parameter.Value' --output text --region us-east-1`
db_username=`aws ssm get-parameter --name "/ak/db_username" --query 'Parameter.Value' --output text --region us-east-1`
db_user_password=`aws ssm get-parameter --name "/ak/user_password" --query 'Parameter.Value' --output text --region us-east-1`
sed -i "s/database_name_here/$db_name/g" /var/www/html/wp-config.php
sed -i "s/username_here/$db_username/g" /var/www/html/wp-config.php
sed -i "s/password_here/$db_user_password/g" /var/www/html/wp-config.php
sed -i "s/localhost/${DB_HOST}/g" /var/www/html/wp-config.php
#sed -i "s/wp_/wp1_/g" /var/www/html/wp-config.php
rm -rf wordpress
rm -rf latest.tar.gz
chmod -R 755 /var/www/html/*
chown -R apache:apache /var/www/html/*
# - DB_HOST: !GetAtt AkNLB.DNSName