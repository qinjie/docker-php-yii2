#!/bin/bash
FILES=*.conf
for filename in $FILES
do
    #file = "${filename}.conf"
    echo $filename
    a2dissite $filename
    a2ensite $filename
done

service apache2 restart

