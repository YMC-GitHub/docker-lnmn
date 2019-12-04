#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_for_project() {
    local TXT=
    TXT=$(
        cat <<EOF
*.key
*.pem
*.crt
*.csr
dev/
*.srl
EOF
    )
    echo "gen .gitignore :$THIS_PROJECT_PATH/.gitignore"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$THIS_PROJECT_PATH/.gitignore"
}
#add_for_project
# or
#/d/code-store/Shell/add-files-to-project/add-gitignore-to-one-project.sh

function add_for_mysql() {
    local TXT=
    TXT=$(
        cat <<EOF
*
!.gitignore
EOF
    )
    echo "gen .gitignore :$THIS_PROJECT_PATH/mysql/.gitignore"
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$THIS_PROJECT_PATH/mysql/.gitignore"
}

add_for_project
add_for_mysql
### usage
#./tool/gen-gitignore.sh
