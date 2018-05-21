# Use mysql server on local machine
sudo docker run -d -p 80:80 -v $PWD/html:/var/www/html --name my-php-yii2 --link mysql01 php-yii2 
