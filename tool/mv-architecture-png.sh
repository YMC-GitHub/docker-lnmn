#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
source $THIS_FILE_PATH/config.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function mv_png() {
  local cmd=
  local src=
  local des=
  src=
  des="${RUN_SCRIPT_PATH}/architecture.png"
  case "$db_driver" in
  "mysql")
    src="${RUN_SCRIPT_PATH}/dev/nginx-node-mysql.png"
    ;;
  "mongo")
    src="${RUN_SCRIPT_PATH}/dev/nginx-node-mongo.png"
    ;;

  esac

  echo "mv -f $src $des"
  mv -f "$src" "$des"
}
mv_png

## file-usege
# ./tool/mv-architecture-png.sh
