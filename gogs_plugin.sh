################################################
# Gogs Server API Plugin for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.1
# Date: 2024-01-08
# License: MIT
################################################
function gogs_plugin_version(){ echo "vzool_0.1"; }
function gogs_check_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
    $HTTP_HOST/orgs/$domain?token=$TOKEN)
}
function gogs_create_organization(){
  local domain="$1"
  local username="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"username": "'$domain'", "visibility":"private", "full_name": "My Repositores Mirror from '$domain'"}' \
        $HTTP_HOST/org/users/$username/orgs)
}
function gogs_check_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
          -H "Content-Type: application/json" \
          -H "Authorization: token $TOKEN" $HTTP_HOST/repos/$domain/$repository)
}
function gogs_organization_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl   --write-out '%{http_code}' --silent --output /dev/null \
                -X 'POST' \
                -H "Authorization: Bearer $TOKEN" \
                -H 'accept: application/json' \
                -H 'Content-Type: application/json' \
                --data '{"name":"'$repository'", "private":true, "auto_init": false}' \
                $HTTP_HOST/admin/users/$domain/repos)
}