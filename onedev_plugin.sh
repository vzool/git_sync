################################################
# OneDev Server API Plugin for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.1
# Date: 2024-01-17
# License: MIT
# REF: http://127.0.0.1:6610/~help/api
################################################
function onedev_plugin_version(){ echo "vzool_0.1"; }
function onedev_required_permissions(){ echo "non-specifiable"; }
function onedev_user_can_create_repo_flag(){ echo "false"; }
function onedev_remote_origin(){
    local repository="$1"
    host=$(echo $SSH_HOST | sed 's/git@//')
    echo "ssh://$host:$SSH_PORT/$repository";
}
function onedev_custom_push_updates(){
    git push --all $(onedev_remote_origin $TARGET_DOMAIN_NAME/$TARGET_REPOSITORY_NAME)
    git push --tags $(onedev_remote_origin $TARGET_DOMAIN_NAME/$TARGET_REPOSITORY_NAME)
}
function onedev_check_repository(){ # DONE
    local domain="$1"
    local repository="$2"
    # curl -u vzool:vENyJiBu981gMoibO8ktBIMUaWUSQoOLgcqtVuvF http://127.0.0.1:6610/\~api/projects\?query\=%22Name%22+is+%22m7mdra.github.com%22\&count\=1\&offset\=0 | jq '.[0].id'
    local id=$(curl -u $domain:$TOKEN "$HTTP_HOST/~api/projects?query=%22Name%22+is+%22$repository%22&count=1&offset=0" | jq '.[0].id')
    # if id is null then echo 404 else echo 200
    if [ "$id" == "null" ]
    then
        echo 404
    else
        echo 200
    fi
}
function onedev_user_create_repository(){ # DONE
    local domain="$1"
    local repository="$2"
    local parentId="$3"
    [ -z "$parentId" ] && parentId="null"
    # curl -u vzool:vENyJiBu981gMoibO8ktBIMUaWUSQoOLgcqtVuvF --write-out '%{http_code}' --silent --output /dev/null -X POST --data '{"name":"asd", "codeManagement" : true, "issueManagement" : true, "timeTracking" : false, "pendingDelete" : false}' -H "Content-Type: application/json" http://127.0.0.1:6610/~api/projects
    response=$(curl -u $domain:$TOKEN --write-out '%{http_code}' --silent --output /dev/null -X POST \
        --data '{"name":"'$repository'","parentId":'$parentId',"codeManagement":true,"issueManagement":true,"timeTracking":false,"pendingDelete":false}' \
        -H "Content-Type: application/json" \
        "$HTTP_HOST/~api/projects")
    # if response is 200 then echo 201 else echo whatever response is returned
    if [ "$response" == 200 ]
    then
        echo 201
    else
        echo $response
    fi
}
function onedev_check_organization(){ # SET
  local domain="$1"
  echo $(onedev_check_repository $domain $domain)
}
function onedev_create_organization(){ # SET
  local domain="$1"
  echo $(onedev_user_create_repository $domain $domain)
}
function onedev_organization_create_repository(){ # SET
  local domain="$1"
  local repository="$2"
  local parentId=$(curl -u $domain:$TOKEN "$HTTP_HOST/~api/projects?query=%22Name%22+is+%22$domain%22&count=1&offset=0" | jq '.[0].id')
  echo $(onedev_user_create_repository $domain $repository $parentId)
}