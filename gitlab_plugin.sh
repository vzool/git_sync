################################################
# GitLab Server API Plugin for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.2
# Date: 2024-01-16
# License: MIT
# REF: https://docs.gitlab.com/16.7/ee/api/api_resources.html
################################################
function gitlab_plugin_version(){ echo "vzool_0.2"; }
function gitlab_required_permissions(){ echo "api"; }
function gitlab_user_can_create_repo_flag(){ echo "true"; }
function gitlab_check_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
          -H "PRIVATE-TOKEN: $TOKEN" \
          $HTTP_HOST/api/v4/projects/$domain%2F$repository)
}
function gitlab_user_create_repository(){
  local domain="$1"
  local repository="$2"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
              -H "PRIVATE-TOKEN: $TOKEN" \
              --data "name=$repository&visibility=private" \
              $HTTP_HOST/api/v4/projects)
}
function gitlab_check_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X GET \
              -H "PRIVATE-TOKEN: $TOKEN" \
              "$HTTP_HOST/api/v4/groups/$domain")
}
function gitlab_create_organization(){
  local domain="$1"
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
              -H "PRIVATE-TOKEN: $TOKEN" \
              -H "Content-Type: application/json" \
              --data '{"path": "'$domain'", "name": "'$domain'", "visibility": "private", "description": "My Repositores Mirror from '$domain'"}' \
              "$HTTP_HOST/api/v4/groups")
}
function gitlab_organization_create_repository(){
  local domain="$1"
  local repository="$2"
  local namespace_id=$(curl -X GET -H "PRIVATE-TOKEN: $TOKEN" "$HTTP_HOST/api/v4/namespaces/$domain" | jq '.id')
  echo $(curl --write-out '%{http_code}' --silent --output /dev/null -X POST \
              -H "PRIVATE-TOKEN: $TOKEN" \
              -H "Content-Type: application/json" \
              --data '{"name": "'$repository'", "path": "'$repository'", "visibility": "private", "initialize_with_readme": "false", "namespace_id": '$namespace_id'}' \
              "$HTTP_HOST/api/v4/projects")
}