#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function list_crt() {
    local PM_PATH=
    PM_PATH="$THIS_PROJECT_PATH/nginx/ca/"
    ls "$PM_PATH"
}
function ls_cm_crt() {
    local PM_PATH=
    local CM_PATH=
    local name=
    local file_name=
    local cm_name=

    PM_PATH="$THIS_PROJECT_PATH/nginx/ca/"
    CM_PATH=/etc/nginx/
    file_name=server
    cm_name="${CM_PATH}${file_name}"
    echo "$cm_name"
    #sed "s#ssl_certificate_key *.*#ssl_certificate_key ${cm_name}.key;#" $THIS_PROJECT_PATH/nginx/conf.d/default.conf
    #sed "s#ssl_certificate *.*#ssl_certificate ${cm_name}.crt;#" $THIS_PROJECT_PATH/nginx/conf.d/default.conf
    echo "the crt file nginx uses in cm is:"
    cat $THIS_PROJECT_PATH/nginx/conf.d/default.conf | grep "ssl_certificate "
    cat $THIS_PROJECT_PATH/nginx/conf.d/default.conf | grep "ssl_certificate_key "
    echo "the crt file genrate in pm is:$PM_PATH"
    echo "the crt files in pm is:"
    ls "$PM_PATH"

}

function main_fun() {

    local PM_PATH=
    local CM_PATH=
    local name=
    local key_file=
    local csr_file=
    local crt_file=
    local ca_file=
    local file_name=

    PM_PATH="$THIS_PROJECT_PATH/nginx/ca/"
    CM_PATH=/etc/nginx/
    file_name=server
    #key_file="${PM_PATH}${file_name}.key"
    #csr_file="${PM_PATH}${file_name}.csr"
    #crt_file="${PM_PATH}${file_name}.crt"
    #ca_file="${PM_PATH}ca.crt"
    name="${PM_PATH}${file_name}"
    cm_name="${CM_PATH}${file_name}"
    # 创建
    echo "create nginx crt ..."
    openssl genrsa -des3 -out "${name}.key" 2048
    openssl rsa -in "${name}.key" -out "${name}.key"
    openssl req -new -key "${name}.key" -out "${name}.csr"
    openssl req -new -x509 -key "${name}.key" -out "${PM_PATH}ca.crt" -days 3650
    openssl x509 -req -days 3650 \
        -in "${name}.csr" \
        -CA "${PM_PATH}ca.crt" \
        -CAkey "${name}.key" \
        -CAcreateserial -out "${name}.crt"
    # 列出文件
    ls "$PM_PATH"
    # 使用文件
    sed -i "s#ssl_certificate_key *.*#ssl_certificate_key ${cm_name}.key;#" $THIS_PROJECT_PATH/nginx/conf.d/default.conf
    sed -i "s#ssl_certificate *.*#ssl_certificate ${cm_name}.crt;#" $THIS_PROJECT_PATH/nginx/conf.d/default.conf
    # 重载配置
    #nginx -s reload
}
main_fun
#ls_cm_crt
#### usage
#./tool/gen-nginx-cert.sh
