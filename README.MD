# Setup and Use

Run following commands to install docker, build docker image, and run the image in container
    
    ```
    sudo apt install docker.io
    sudo docker build --no-cache -t php-yii2 .
    chmod +x docker-yii2-run-v-rds.sh
    ./docker-yii2-run-v-rds.sh
    ```
    
# Commands

## Install

    ```
    sudo apt install docker.io
    ```

## Setup

0. Clean up docker images

   ```
   sudo docker image prune
   sudo docker rm $(docker ps -q -f 'status=exited')
   sudo docker rmi $(docker images -q -f "dangling=true")
   ```

1. Copy `docker-php-yii2` folder to home folder.

2. Copy yii2 project folders to `html` folder

3. If sub-domain setup is required, copy conf files to sites-available folder

4. Build an image (with tag = php-yii2) where Dockerfile is in current directory.

    ```
    sudo docker build --no-cache -t php-yii2 .
    ```

5. To stop a container, find out container ID and run following command

    ```
    sudo docker ps
    sudo docker stop <CONTAINER_ID>
    ```

## Run

1. Run following commands

    * stop and remove any existing running container named "my-php-yii2"
    * execute script to run container 

    ```
    sudo docker stop my-php-yii2        
    sudo docker rm my-php-yii2 
    chmod +x docker-yii2-run-v-rds.sh
    ./docker-yii2-run-v-rds.sh
    ```

# Docker Scripts
1. MySQL is not included in image. Map ports to use external MySQL Server. Remove `--rm` to run in background.

    ```
    docker run --rm -p 80:80 -p 3306:3306 --name my-php-yii2 -ti php-yii2 bash
    ```

    ```
    docker run -d -p 80:80 -p 3306:3306 --name my-php-yii2 -ti php-yii2 bash
    ```

2. For local testing, map local Sites folder to docker container. Remove `--rm` to run in background.

    `docker run --rm -p 80:80 -p 3306:3306 -v ~/sites:/var/www/html --name my-php-yii2 -ti php-yii2 bash`

    `docker run -p 80:80 -p 3306:3306 -v ~/sites:/var/www/html --name my-php-yii2 -ti php-yii2 bash`

3. Other useful docker commands
    - Clean up all dangling docker

    `docker system prune`

    - Start terminal with current running container

    `docker exec <container-id> -ti bash`

# Other Notes

To Enable clean URL in Yii2

1. Add .htaccess file in web root folder (frontend/web and backend/web for advanced template; web folder for basic template).

```
RewriteEngine on
# If a directory or a file exists, use it directly
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
# Otherwise forward it to index.php
RewriteRule . index.php
```

2. In Yii configuration file (main.php for advanced template, or web.php for basic template), set `enablePrettyUrl` to true, and set `showScriptName` to false.

    ```
    'urlManager' => [
        'class' => 'yii\web\UrlManager',
        // Disable index.php
        'showScriptName' => false,
        // Disable r= routes
        'enablePrettyUrl' => true,
        'rules' => array(
            '<controller:\w+>/<id:\d+>' => '<controller>/view',
            '<controller:\w+>/<action:\w+>/<id:\d+>' => '<controller>/<action>',
            '<controller:\w+>/<action:\w+>' => '<controller>/<action>',
        ),
    ],
    ```

3. Enable mod_rewrite for Apache by running following on terminal.

    ```
    $ sudo a2enmod rewrite
    ```

4.  Enable apache2.conf

    ```
    $ vim /etc/apache2/apache2.conf
    ```
	
    <Directory /var/www/>
	Options Indexes FollowSymLinks
	AllowOverride All
	Require all granted
    </Directory>

