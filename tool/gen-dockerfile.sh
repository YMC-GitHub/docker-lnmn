#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_mysql() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  local TXT=
  TXT=$(
    cat <<EOF
######
# See: https://github.com/YMC-GitHub/mirror-mysql
######
# data serve with mysql
FROM registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.10.3
EXPOSE 3306
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata
#COPY \$(pwd)/mysql/conf/my.cnf /etc/mysql/my.cnf
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function add_nodejs() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  TXT=$(
    cat <<EOF
######
# See: https://hub.docker.com/_/node/
######
#FROM node:8.16.2-alpine3.9
#FROM node:8.16.2-alpine3.10
#FROM node:10.17.0-alpine3.9
FROM node:10.17.0-alpine3.10
#FROM node:12.13.1-alpine3.9
#FROM node:12.13.1-alpine3.10
#FROM node:13.2.0-alpine3.9
#FROM node:13.2.0-alpine3.10
MAINTAINER ${author} <${email}>
EXPOSE 3000
ENV PROJECT_DIR=/usr/share/nginx/html
WORKDIR \$PROJECT_DIR
CMD ["node", "./be/index.js"]
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function add_nginx() {
  local author=
  local email=
  local TXT=
  author=ymc-github
  email=yemiancheng@gmail.com
  local TXT=
  TXT=$(
    cat <<EOF
######
# See: https://hub.docker.com/_/nginx/
######
# static serve with nginx
FROM nginx:1.17-alpine
MAINTAINER ${author} <${email}>

#update static file dir belong to nginx to fix 403 error
# or uses the root user run
#RUN chown -R nginx:nginx /usr/share/nginx/html
#set timezone
#uses local pm time with -v /etc/localtime:/etc/localtime in compose file
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add -U tzdata &&  cp "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime" && apk del tzdata
EOF
  )
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT"
}

function main_fun() {
  local path=
  local TXT=

  path="$THIS_PROJECT_PATH/nginx/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_nginx)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"

  path="$THIS_PROJECT_PATH/nodejs/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_nodejs)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"

  path="$THIS_PROJECT_PATH/mysql/Dockerfile"
  echo "gen Dockerfile.yml :$path"
  TXT=$(add_mysql)
  TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
  echo "$TXT" >"$path"
}
main_fun

#### usage
#./tool/gen-dockerfile.sh
