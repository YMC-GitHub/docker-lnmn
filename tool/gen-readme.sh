#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)
source $THIS_FILE_PATH/config.sh

function write_introduction() {
  echo "write_introduction" >/dev/null 2>&1
  local TXT=
  TXT=$(
    cat <<EOF
deploy lnmn(Linux+Nginx+mysql/mongo+nodejs) using docker
EOF
  )
  echo "$TXT"
}
function write_architecture() {
  echo "write_architecture" >/dev/null 2>&1
  TXT=$(cat $THIS_FILE_PATH/architecture.md)
  case "$db_driver" in
  "mongo")
    TXT=$(echo "$TXT" | sed "s/mysql/mongo/g")
    ;;
  esac

  echo "$TXT"
}
function write_build() {
  echo "write_build" >/dev/null 2>&1
  local TXT=
  TXT=$(
    cat <<EOF
At first, you should have had [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose) installed.

    \$ docker-compose build
EOF
  )
  echo "$TXT"
}
function write_run() {
  echo "write_run" >/dev/null 2>&1
  local TXT=
  TXT=$(
    cat <<EOF
Without building images one by one, you can make use of \$(docker-compose) and simply use:

    \$ docker-compose up --detach

For more operations to containers, please refer to:

    \$ docker-compose --help

Check out your https://\<docker-host\> and have fun

i prefer to use : docker-compose up --build --detach
EOF
  )
  echo "$TXT"
}
function write_contributors() {
  echo "write_contributors" >/dev/null 2>&1
  local TXT=
  TXT=$(
    cat <<EOF
ymc-github yemiancheng@gmail.com
EOF
  )
  echo "$TXT"
}

function main_func() {

  local TXT=
  local part_contributors=
  local part_run=
  local part_build=
  local part_architecture=
  local part_introduction=
  write_contributors=$(write_contributors)
  part_run=$(write_run)
  part_build=$(write_build)
  part_architecture=$(write_architecture)
  part_introduction=$(write_introduction)
  TXT=$(
    cat <<EOF

## introduction

$part_introduction

## about architecture

$part_architecture

## build your images

$part_build

## create,start and run your containers

$part_run

## contributors

$write_contributors

## license

MIT

  [1]: architecture.png
EOF
  )

  echo "gen readme.md :$THIS_PROJECT_PATH/readme.md"
  echo "$TXT" >"$THIS_PROJECT_PATH/readme.md"
}

main_func

#### usage
#./tool/gen-readme.sh
