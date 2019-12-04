#echo "build image..."
#docker-compose build
#echo "compose container..."
#docker-compose up --detach
#or
#docker-compose up --build --detach
#echo "get container status..."
#docker-compose ps
#echo "get container logs..."
#docker-compose logs mysql
#docker-compose stop
#docker-compose rm --force
#docker-compose logs xx #kill|restart|ps

#docker-compose logs nginx
#docker-compose logs php-fpm
#docker-compose logs mysql

project=forked-docker-lnmp-micooz
serve_xx=nginx_1
cm_xx="${project}_${serve_xx}"
#go in to container and done
docker exec -it "$cm_xx" /bin/sh
#docker exec -d "$cm_xx" /bin/sh <<EOF
echo "list static  serve file "
ls /usr/share/nginx/html
echo "get static  serve file dir right "
ls -ld /usr/share/nginx/html
echo "get ngixn main conf file txt "
cat /etc/nginx/nginx.conf
echo "list ngixn ohter conf files "
ls /etc/nginx/conf.d
cat /etc/nginx/conf.d/default.conf
#EOF
#issues:the input device is not a TTY

#get container logs

#install curl tool
#apk add curl

#curl localhost # > 403

# find 403 as above
# case:01
#check whether the nginx serve worker user and  master are the same
#ps
# change the worker user to the master user name
# sed -i "s/user.*/user  root;/" /etc/nginx/nginx.conf
# reload nginx serve
#

#curl http://localhost/index.php #> file no found
#curl http://localhost/readme.md #> ok
#nginx File not found 错误
#https://www.cnblogs.com/EdwinChan/p/8383872.html

# 01-find the err
docker-compose logs nginx
# if the err is as below :
# nginx FastCGI sent in stderr: “Primary script unknown”

# 02-fix the err
# fix:nginx FastCGI sent in stderr: “Primary script unknown”
# case01
# 01-
# set the SCRIPT_FILENAME with $document_root and set root dir
# fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
# 02- reload the nginx and php-fpm
#
#
# case02
# go into cm
#docker exec -it forked-docker-lnmp-micooz_php-fpm_1 /bin/sh
# get the php-fpm.conf file position
#ps
#> /usr/local/etc/php-fpm.conf
# get his include file
#cat /usr/local/etc/php-fpm.conf | grep "include"
#> include=etc/php-fpm.d/*.conf
# list the conf files
# ls /usr/local/etc/php-fpm.d
#> docker.conf       www.conf          www.conf.default  zz-docker.conf
# find the user and group in the conf files
#cat /usr/local/etc/php-fpm.d/docker.conf
#cat /usr/local/etc/php-fpm.d/www.conf | grep "user"
#cat /usr/local/etc/php-fpm.d/www.conf | grep "group"
#cat /usr/local/etc/php-fpm.d/zz-docker.conf | grep "user"
#cat /usr/local/etc/php-fpm.d/zz-docker.conf | grep "group"
# find the user and group now run in the process
#ps
#set them the same
#
# case03
#  go into php-fpm cm
# docker exec -it forked-docker-lnmp-micooz_php-fpm_1 /bin/sh
#whoami
#ps
# ls -ld -l /var/www
# >drwxrwxrwx    2 www-data www-data         6 Oct 22 04:38 html
# ls -ld /usr/share/nginx/html
# >drwxrwx---    1 root     980              0 Dec  2 18:20 /usr/share/nginx/html
# chmod -R 777 /usr/share/nginx/html
# update the right for  the www-data user to php-fpm
#
# or use root user replace the www-data user to run php-fpm
# go into nginx cm
# docker exec -it forked-docker-lnmp-micooz_nginx_1 /bin/sh
# ls -ld /usr/share/nginx/html
#> drwxrwx---    1 root     980              0 Dec  2 18:20 /usr/share/nginx/html
# update the right for www-data user
# chmod -R 777 /usr/share/nginx/html

# copy php-fpm conf file
docker cp forked-docker-lnmp-micooz_php-fpm_1:/usr/local/etc/php-fpm.conf $(pwd)/php-fpm/
docker cp forked-docker-lnmp-micooz_php-fpm_1:/usr/local/etc/php-fpm.d/ $(pwd)/php-fpm/
# check the copyed file right
ls -l $(pwd)/php-fpm/php-fpm.conf
ls -ld $(pwd)/php-fpm/php-fpm.d
ls -l $(pwd)/php-fpm/php-fpm.d

# check the config file
# nginx -t
# reload nginx serve
# nginx -s reload

###
# reload php-fpm serve
###
# netstat -lntup | grep 9000
# killall php-fpm
# php-fpm  -D
# or
# docker-compose stop php-fpm
# docker-compose up -d

#ls the relative files rigth and user in CM for mysql serve
docker-compose logs mysql
docker exec -it forked-docker-lnmp-micooz_mysql_1 /bin/sh
whoami
ps
ls -ld /etc/mysql
#> drwxr-xr-x    1 root     root            20 Dec  1 18:30 /etc/mysql
ls -ld /var/lib/mysql
#>drwxrwx---    1 root     980              0 Dec  2 15:23 /var/lib/mysql
ls -ld /etc/localtime
#>-rw-r--r--    5 root     root           528 Jul 11 05:44 /etc/localtime

#https://www.cnblogs.com/luoahong/articles/9139888.html
#php配置php-fpm启动参数及配置详解
#https://www.cnblogs.com/mingaixin/p/3794227.html
#为什么我的 PHP -fpm 必须要 root 用户启动?
#https://www.v2ex.com/amp/t/351078
#修改php-fpm和nginx运行用户
#https://blog.csdn.net/tterminator/article/details/65651343
# on the vm
cat /etc/group | grep "root"
cat /etc/group | grep "www-data"
cat /etc/group | grep "www"
cat /etc/group | grep "mysql"
cat /etc/group | grep "nginx"
cat /etc/group | grep "php"
cat /etc/group | grep "yemiancheng"
cat /etc/group | grep "nobody"
ls -ld app/src
#chmod -R 770 app/src
#chown -R nobody:98 app/src

#https://blog.csdn.net/weixin_34281537/article/details/85190632
#烂泥：nginx、php-fpm、mysql用户权限解析

# todos
# start nginx with root user in cm
# run with nobody user in cm
# start php-fpm with root user in cm
# run with nobody user in cm
# start mysql with root user in cm
# run with nobody user in cm

# set the website file root dir in vm belong to nobody user and group
name=nobody
ID=$(cat /etc/group | grep "^$name:" | cut -d ":" -f2)
chown -R "$name":"$ID" app
ls -ld app

####
#Q:windows下Virtualbox共享目录修改文件权限的问题--改不了？！！
#A: 你的Windows + VirtualBox 的 vboxsf 文件系统不支持更改文件权限了。这和你不能更改 FAT 分区上文件的权限是一样的。

###
# install php-fpm core ext
###
#
docker exec -it forked-docker-lnmp-micooz_php-fpm_1 /bin/sh
#get some help
#php --help
#Show compiled in modules
php -m
#PHP information
php -i
# update apk sources
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# intall mysqli
docker-php-ext-install mysqli
# intall pdo and it's dirver
docker-php-ext-install pdo pdo_sqlite pdo_odbc pdo_mysql

#Possible values for ext-name:
#bcmath bz2 calendar ctype curl dba dom enchant exif ffi fileinfo filter ftp gd gettext gmp hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline reflection session shmop simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader xmlrpc xmlwriter xsl zend_test zip

# unpack the source
docker-php-source extract
# install ext
#...
# delte the source that unpacked before
docker-php-source delete

###
# install php-fpm pear ext
###
pecl install xxxx && docker-php-ext-enable xxx

###
# install php-fpm other ext
###
echo "install ext .."
curl -L -o /tmp/reids.tar.gz https://codeload.github.com/phpredis/phpredis/tar.gz/5.0.2
cd /tmp
tar -xzf reids.tar.gz
ls
docker-php-source extract
mv phpredis-5.0.2 /usr/src/php/ext/phpredis
ls -l /usr/src/php/ext | grep redis
docker-php-ext-install phpredis
php -m | grep redis

php_ext_install_path=/usr/local/etc/php
echo "list ext has been installed ..."
ls "$php_ext_install_path"
echo "list ext has been enabled ..."
#php -m | grep redis
php -m
echo "set ext enable ..."
docker-php-ext-enable redis
php -m | grep redis

echo "uninstall ext .."
rm -rf /usr/local/etc/php/conf.d/docker-php-ext-redis.ini
php -m
#Docker php安装扩展步骤详解
#https://www.cnblogs.com/yinguohai/p/11329273.html
#https://hub.docker.com/_/php/

###
# uses composer to install php lib(dev)
###
#D:\code-store\Shell\use-composer-to-install-php-lib-with-docker\index.sh
