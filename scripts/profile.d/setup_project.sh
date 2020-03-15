#!/usr/bin/env bash

setup_project () {

   if [ -z "$HTTP_PROXY" ]; then
      unset HTTP_PROXY
      unset HTTPS_PROXY_REQUEST_FULLURI
      unset HTTP_PROXY_REQUEST_FULLURI
      unset http_proxy
      unset HTTPS_PROXY
      unset https_proxy
   fi

   cd /var/www/html

   sudo -E bash <<-EOF
      apk update --no-cache && apk add --no-cache zip vim util-linux
      exit
EOF

   wget https://get.symfony.com/cli/installer -O - | bash

   if [ "${SYMFONY_VER}" != "latest" ]; then
   	symfony new ${PROJECT_NAME} --full --version=${SYMFONY_VER}
   else
   	symfony new ${PROJECT_NAME} --full
   fi

   git config --global user.name "splitant"
   git config --global user.email "axel.depret.pro@gmail.com"
}
