#!/bin/bash
yum update -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
# ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

db_name=`aws ssm get-parameter --name "/ak/db_name" --query 'Parameter.Value' --output text --region us-east-1`
db_username=`aws ssm get-parameter --name "/ak/db_username" --query 'Parameter.Value' --output text --region us-east-1`
db_user_password=`aws ssm get-parameter --name "/ak/user_password" --query 'Parameter.Value' --output text --region us-east-1`
# db_username=akbar
# db_user_password=akbar123
# db_name=akbar
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2
sudo yum install mysql-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb
mysql -h localhost -u root -e "create database $db_name"
mysql -h localhost -u root -e "CREATE USER '$db_username'@'%' IDENTIFIED BY '$db_user_password'"
mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_username'@'%' WITH GRANT OPTION"

sudo yum -y install expect
MYSQL_ROOT_PASS=admin

sleep 5
echo "Set root password"
expect -f - <<-EOF
    set timeout 10
    spawn mysql_secure_installation
    expect "Enter current password for root (enter for none):"
    send -- "\r"
    expect "Set root password?"
    send -- "y\r"
    expect "New password:"
    send -- "${MYSQL_ROOT_PASS}\r"
    expect "Re-enter new password:"
    send -- "${MYSQL_ROOT_PASS}\r"
    expect "Remove anonymous users?"
    send -- "y\r"
    expect "Disallow root login remotely?"
    send -- "n\r"
    expect "Remove test database and access to it?"
    send -- "y\r"sudo
    expect "Reload privilege tables now?"
    send -- "y\r"
    expect eof
EOF