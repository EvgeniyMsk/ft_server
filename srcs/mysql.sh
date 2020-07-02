service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "GRANT ALL ON *.* TO 'user'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root