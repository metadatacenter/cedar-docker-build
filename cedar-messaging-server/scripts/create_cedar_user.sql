DROP USER 'cedarMySQLUser'@'localhost';

CREATE USER 'cedarMySQLUser'@'localhost' IDENTIFIED BY 'changeme';

GRANT ALL PRIVILEGES ON cedar_messaging.* TO 'cedarMySQLUser'@'localhost';