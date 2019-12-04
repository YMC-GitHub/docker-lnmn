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

    PM_PATH="$THIS_PROJECT_PATH/mysql/init/"
    CM_PATH=/etc/mysql/
    name=init
    file="${PM_PATH}${name}.sql"
    TXT=$(
        cat <<EOF
create database test;
use test;
create table user
(
id int auto_increment primary key,
username varchar(64) unique not null,
email varchar(120) unique not null,
password_hash varchar(128) not null,
avatar varchar(128) not null
);
insert into user values(1, "zhangsan","test12345@qq.com","passwd","avaterpath");
insert into user values(2, "lisi","12345test@qq.com","passwd","avaterpath");
EOF
    )
    mkdir -p "$PM_PATH"
    echo "gen mysql init data:$file"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"
}
main_fun
#### usage
#./tool/gen-mysql-init-data.sh
