#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function main_fun() {
  local KEY_VAL_MAP=
  local key=
  local val=
  local var=
  local KEY_VAL_ARR=
  local REG_SHELL_COMMOMENT_PATTERN=
  local path=

  KEY_VAL_MAP=$(
    cat <<EOF
  nginx=nginx
  nodejs=nodejs
  mysql=mysql
  mongo=mongo
EOF
  )
  KEY_VAL_MAP=$(echo "$KEY_VAL_MAP" | sed "s/^ *#.*//g" | sed "/^ *$/d")

  REG_SHELL_COMMOMENT_PATTERN="^#"
  KEY_VAL_ARR=(${KEY_VAL_MAP//,/ })
  for var in ${KEY_VAL_ARR[@]}; do
    if [[ "$var" =~ $REG_SHELL_COMMOMENT_PATTERN ]]; then
      echo "$var" >/dev/null 2>&1
    else
      key=$(echo "$var" | cut -d "=" -f1)
      val=$(echo "$var" | cut -d "=" -f2)
      path="$THIS_PROJECT_PATH/$val"
      echo "mkdir -p $path"
      mkdir -p $path
    fi
  done
}
main_fun

#### usage
#./tool/gen-readme.sh
