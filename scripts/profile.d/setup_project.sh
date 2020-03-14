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

   drupal_projects=(
      webform
      admin_toolbar
      google_analytics
      config_split
      devel
      ds
      fontawesome
      linkit
      field_group
      paragraphs
      inline_entity_form
      fontawesome_menu_icons
      search_api
      search_api_solr
      facets
      metatag
      pathauto
      token
      redirect
      robotstxt
      simple_sitemap
      sharethis
      recaptcha
      better_exposed_filters
      views_infinite_scroll
      emulsify
      bootstrap
      adminimal_theme
   )

   if [ "${DRUPAL_VER}" != "latest" ]; then
      composer -n create-project drupal/recommended-project:${DRUPAL_VER} --no-install ./
      composer require drupal/core-recommended:${DRUPAL_VER} drupal/core-dev:${DRUPAL_VER} --update-with-dependencies
   else
      composer create-project drupal/recommended-project ./ 
   fi

   composer install --prefer-dist

   for project in "${drupal_projects[@]}"; do
      composer require drupal/$project
   done

   composer require drush/drush

   git config --global user.name "splitant"
   git config --global user.email "axel.depret.pro@gmail.com"

   drush si standard --db-url=${DB_DRIVER}://root:${DB_ROOT_PASSWORD}@${DB_HOST}/${DB_NAME} -y 
   drush upwd admin admin
}
