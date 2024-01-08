# git_sync: Easily sync repositories between Git servers

## Overview

This script automates the process of syncing repositories from one Git server to another. It's designed to be flexible and supports multiple Git servers storage target through plugins.

When to sync `git@github.com:vzool/git_sync.git` for instance, `git_sync` will create a new repository name `git_sync` under a new orgnization name `vzool.github.com`.

So, things will be separated automatically by namespaces. :)

#### Support Plugins

- [x] [Gitea](https://about.gitea.com/).
- [ ] [Gogs](https://gogs.io/). [WIP]
- [ ] [OneDev](https://onedev.io/).
- [ ] [Github](https://github.com/).
- [ ] [BitBucket](https://bitbucket.org/).
- [ ] [GitLab](https://about.gitlab.com/).


## Key Features

- Syncs repositories across Git servers: Clones repositories locally and pushes them to a target Git server, utilizing Git server APIs for organization and repository management.
- Supports multiple Git servers: Uses plugins to interact with different Git server platforms.
- Configurable: Employs a configuration file for settings and preferences.
- User-friendly: Offers interactive prompts and confirmations.
- Provides additional commands:
    - git_sync init: Create config file based on user input and exit.
    - git_sync list: Edit the list of repositories to sync.
    - git_sync config: Displays loaded configuration variables.
    - git_sync size: Shows the size of locally stored repositories.
    - git_sync version: Output version information and exit.

## Requirements

- SSH key pair already set for the Gitea server.
- SSH key pair already set for all source Git servers.
- `git` command line tool.
- Accesss Token with the following permissions:
    - write:organization
    - write:repository

## Usage

- Ensure dependencies: Verify that required commands like git and curl are installed.
- Set up configuration:
    - If a configuration file doesn't exist, run git_sync init to create one interactively.
    - You can also manually edit the configuration file.
- Run the script:
    - Use the -v flag for verbose output.
    - Use the -y flag to skip confirmation prompts.

## Example

To sync repositories listed in repos.txt to a Gitea server, run:

```bash
./git_sync init # Create .git_sync directory at home directory
./git_sync config # Show loaded config
./git_sync -y # Run without confirmation

# OR

ENV="/path/to/.env" ./git_sync

# OR

TOKEN="xxxxxx" USER="vzool" HTTP_HOST="http://192.168.88.248:3000" SSH_HOST="git@192.168.88.248" LIST="/path/to/git_sync_repo.txt" ./git_sync

# OR

TOKEN="xxxxxx" USER="vzool" HTTP_HOST="http://192.168.88.248:3000" SSH_HOST="git@192.168.88.248" SSH_PORT="22" LIST="git_sync_repo.txt" DIR="repo/" ./git_sync
```

## Anatomy

![00-local-file-storage](images/00-local-file-storage.png)
![01-configuration-file](images/01-configuration-file.png)
![02-repositories-list.png](images/02-repositories-list.png)

## Further Information

**Configuration file**: See config.example.sh for configuration options.

**Supported Git servers**: Currently supports Gitea only.

**Plugins**: Explore available plugins in the plugins directory.

**Contributing**: Feel free to contribute to the project!

## License

This project is licensed under the MIT License.

## Author

Abdelaziz Elrashed (c) 2024
