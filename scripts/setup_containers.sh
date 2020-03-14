#!/bin/bash

sudo rm -rf web/{*,.*}
docker-compose up -d --build --force-recreate --renew-anon-volumes

project_name_setting=`sed -n '/PROJECT_NAME=/p' .env`
IFS='=' read -r -a part <<< "$project_name_setting"
project_name=${part[1]}
php_container=${project_name}"_php"

docker exec -ti ${php_container} bash -c -l "setup_project"
