#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_nginx() {
  local TXT=
  TXT=$(
    cat <<EOF
# static web serve with nginx
nginx:
  # which image it uses
  #image: nginx:1.17-alpine
  build: ./nginx
  ports:
    - "80:80"
    - "443:443"
    - "8080:80"
  volumes:
    # staitc web
    - ./app:/usr/share/nginx/html
    # nginx configs
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./nginx/conf.d/:/etc/nginx/conf.d/:ro
    # nginx logs
    #- ./nginx/log:/var/log/nginx
    # certificates
    - ./nginx/ca/server.crt/:/etc/nginx/server.crt:ro
    - ./nginx/ca/server.key/:/etc/nginx/server.key:ro
    # uses local machine time to cm
    - /etc/localtime:/etc/localtime
  links:
    - nodejs:__DOCKER_NODEJS__
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function add_nodejs() {
  local TXT=
  TXT=$(
    cat <<EOF
#dymatic web serve with nodejs
nodejs:
  build: ./nodejs
  ports:
    - "3000:3000"
  volumes:
    # dymatic web
    - ./app:/usr/share/nginx/html
    # uses local machine time to cm
    - /etc/localtime:/etc/localtime
  # environment:
    # set your app env variables here:
    # - APP_KEY=
    # - DB_HOST=
    # - DB_DATABASE=
    # - DB_USERNAME=
    # - DB_PASSWORD=
  links:
    - mysql:mysql
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}
function add_mysql() {
  local TXT=
  TXT=$(
    cat <<EOF
# data serve with mysql
mysql:
  build: ./mysql
  ports:
    # allow client to access 3306
    - "3306:3306"
  volumes:
    # NOTE: your data will be stored in ./mysql
    #- ./mysql/log/:/var/log/mysql
    - ./mysql/my.cnf:/etc/mysql/my.cnf
    - ./mysql/data:/var/lib/mysql
    #- ./mysql/init:/docker-entrypoint-initdb.d
    #- ./mysql/data:/app/mysql
    # uses local machine time to cm
    - /etc/localtime:/etc/localtime
  environment:
    # define var in CM for mysql root password
    - MYSQL_ROOT_PASSWORD=your_mysql_password
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function main_fun() {
  local name="Ye Miancheng"
  local email="ymc.github@gmail.com"
  local homepage="https://github.com/YMC-GitHub"
  local TXT=
  local nginx_txt=$(add_nginx)
  local nodejs_txt=$(add_nodejs)
  local mysql_txt=$(add_mysql)
  TXT=$(
    cat <<EOF
$mysql_txt
$nodejs_txt
$nginx_txt
EOF
  )
  echo "gen docker-compose.yml :$THIS_PROJECT_PATH/docker-compose.yml"
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$THIS_PROJECT_PATH/docker-compose.yml"
}
main_fun
#### usage
#./tool/gen-docker-compose.sh
