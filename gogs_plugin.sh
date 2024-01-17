################################################
# Gogs Server API Plugin for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.3
# Date: 2024-01-08
# License: MIT
# REF: https://github.com/gogs/go-gogs-client
################################################
function gogs_plugin_version(){ echo "vzool_0.3"; }
function gogs_required_permissions(){ echo "non-specifiable"; }
function gogs_user_can_create_repo_flag(){ echo "true"; }
function gogs_check_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
          -H "Content-Type: application/json" \
          -H "Authorization: token $TOKEN" $HTTP_HOST/api/v1/repos/$domain/$repository)
}
function gogs_user_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl   --write-out '%{http_code}' --silent --output /dev/null -X 'POST' \
                -H 'accept: application/json' \
                -H 'Content-Type: application/json' \
                --data '{"name":"'$repository'", "private":true, "auto_init": false}' \
                $HTTP_HOST/api/v1/user/repos?token=$TOKEN)
}
function gogs_check_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
    $HTTP_HOST/api/v1/orgs/$domain?token=$TOKEN)
}
function gogs_create_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
        -H "Content-Type: application/json" \
        -d '{"username": "'$domain'", "full_name": "'$domain'", "description": "My Repositores Mirror from '$domain'"}' \
        $HTTP_HOST/api/v1/user/orgs?token=$TOKEN)
}
function gogs_organization_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl   --write-out '%{http_code}' --silent --output /dev/null -X 'POST' \
                -H 'accept: application/json' \
                -H 'Content-Type: application/json' \
                --data '{"name":"'$repository'", "private":true, "auto_init": false}' \
                $HTTP_HOST/api/v1/org/$domain/repos?token=$TOKEN)
}