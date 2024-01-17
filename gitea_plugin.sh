################################################
# Gitea Server API Plugin for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.3
# Date: 2024-01-08
# License: MIT
# REF: https://docs.gitea.com/api/1.20/
################################################
function gitea_plugin_version(){ echo "vzool_0.3"; }
function gitea_required_permissions(){ echo "write:organization, write:repository, write:user"; }
function gitea_user_can_create_repo_flag(){ echo "true"; }
function gitea_check_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
          -H "Content-Type: application/json" \
          -H "Authorization: token $TOKEN" $HTTP_HOST/api/v1/repos/$domain/$repository)
}
function gitea_user_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl   --write-out '%{http_code}' --silent --output /dev/null \
                -X 'POST' \
                -H 'accept: application/json' \
                -H 'Content-Type: application/json' \
                --data '{"name":"'$repository'", "private":true, "auto_init": false}' \
                $HTTP_HOST/api/v1/user/repos?access_token=$TOKEN)
}
function gitea_check_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
    -H "Authorization: Bearer $TOKEN" \
    $HTTP_HOST/api/v1/orgs/$domain)
}
function gitea_create_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"username": "'$domain'", "visibility":"private", "full_name": "My Repositores Mirror from '$domain'"}' \
        $HTTP_HOST/api/v1/orgs)
}
function gitea_organization_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl   --write-out '%{http_code}' --silent --output /dev/null \
                -X 'POST' \
                -H 'accept: application/json' \
                -H 'Content-Type: application/json' \
                --data '{"name":"'$repository'", "private":true, "auto_init": false}' \
                $HTTP_HOST/api/v1/orgs/$domain/repos?access_token=$TOKEN)
}