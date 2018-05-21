
sudo docker run -d -p 80:80 -p 3306:3306 -v $PWD/html:/var/www/html --name my-php-yii2 -ti php-yii2 bash

