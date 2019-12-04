#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function main_fun() {

    local PM_PATH=
    local CM_PATH=
    local name=
    local TXT=
    local file=

    PM_PATH="$THIS_PROJECT_PATH/mysql/"
    CM_PATH=/etc/nginx/
    name=my
    file="${PM_PATH}${name}.cnf"
    TXT=$(
        cat <<EOF
[mysqld]
user=root
#设置字符编码
#character_set_server=utf8
#init_connect='SET NAMES utf8'
#设置数据目录
#datadir=/var/lib/mysql
datadir=/app/mysql
#不区分大小写
#lower_case_table_names = 1
#explicit_defaults_for_timestamp=true
#设置时区位置
#default-time_zone = '+8:00'
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8

#[mysqld]
#user = root
#datadir = /app/mysql
#port = 3306
#log-bin = /app/mysql/mysql-bin
EOF
    )
    mkdir -p "$PM_PATH"
    echo "gen mysql conf:$file"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"
}
main_fun

#### usage
#./tool/gen-mysql-conf.sh
