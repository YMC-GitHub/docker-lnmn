#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

#echo "caculate config and save in a dictionary dic..."
#source $RUN_SCRIPT_PATH/tool/caculate-config.sh

source $RUN_SCRIPT_PATH/tool/gen-dir-construtor.sh
source $RUN_SCRIPT_PATH/tool/gen-readme.sh
source $RUN_SCRIPT_PATH/tool/gen-license.sh
source $RUN_SCRIPT_PATH/tool/gen-gitignore.sh
source $RUN_SCRIPT_PATH/tool/gen-docker-compose.sh
source $RUN_SCRIPT_PATH/tool/gen-dockerfile.sh
source $RUN_SCRIPT_PATH/tool/gen-mysql-conf.sh
source $RUN_SCRIPT_PATH/tool/gen-mysql-init-data.sh
### usage
#./tool/init.sh
