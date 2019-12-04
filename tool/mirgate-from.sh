path=/d/code-store/Shell
project=docker-lnmn
pro-image-build.sh
cp --recursive forked-docker-lnmp-micooz docker-lnmn
rm -rf docker-lnmn/.git
rm -rf docker-lnmn/php-fpm
rm -rf docker-lnmn/tool/test*
rm -rf docker-lnmn/tool/delete*
rm -rf docker-lnmn/tool/caculate*
rm -rf docker-lnmn/tool/migrate*
rm -rf docker-lnmn/dev
# updates gen-dockerfile
# updates gen-docker-compose
# updates gen-dir-construtor
# updates architecture.png md
