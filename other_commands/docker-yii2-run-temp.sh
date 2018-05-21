# Use rm to run script only on foreground. Script stops once terminal ends
sudo docker run --rm -p 80:80 -p 3306:3306 -v ~/Sites:/var/www/html --name my-php-yii2 -ti php-yii2 bash

