#!/usr/bin/env bash
# install.sh - installation and update script for git_sync
# Author: Abdelaziz Elrashed (@vzool)
# Version: 0.0.1-dev
# Date: 2024-01-12
# URL: https://github.com/vzool/git_sync
# License: MIT

# Check for dependencies and exit if not found
for cmd in curl git sed jq
do
  if ! command -v $cmd &> /dev/null
  then
    echo "[ERROR] `$cmd` command could not be found, please install it!"
    exit 1
  fi
done

# set destination directory path and local bin
LOCAL_BIN="$HOME/.local/bin"
DST="$HOME/.local/git_sync"

# remove command
if [ "$1" == "remove" ]
then
    echo "[INFO] removing git_sync..."
    if [ ! -d $DST ]
    then
        echo "[ERROR] git_sync not found, already removed?"
    fi
    rm -rf $DST
    if [ ! -L $LOCAL_BIN/git_sync ]
    then
        echo "[ERROR] git_sync symbolic link not found, already removed?"
    fi
    rm -rf $LOCAL_BIN/git_sync
    echo "[INFO] git_sync removed successfully!"
    exit 0
fi

# check if destination directory exists, if not, clone the repo
if [ ! -d $DST ]
then
    FRESH_INSTALL=true
    echo "[INFO] git_sync not found, cloning it..."
    git clone git@github.com:vzool/git_sync.git $DST
else
    echo "[INFO] git_sync found, updating it..."
    cd $DST
    git pull
fi

# create local_bin if not exists
if [ ! -d $LOCAL_BIN ]
then
    echo "[INFO] local_bin not found in home directory, creating it..."
    mkdir -p $LOCAL_BIN
else
    echo "[INFO] local_bin found in home directory, skipping it!"
fi

# check if destination directory is added to environment variables, if not, add it
if [[ ":$PATH:" != *"$LOCAL_BIN"* ]]
then
    echo "[INFO] local_bin directory not found in PATH, adding it..."
    [ -f "$HOME/.bashrc" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.bashrc
    [ -f "$HOME/.zshrc" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.zshrc
    [ -f "$HOME/.profile" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.profile
    [ -f "$HOME/.bash_profile" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.bash_profile && $HOME/.bash_profile
    [ -f "$HOME/.config/fish/config.fish" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.config/fish/config.fish
    [ -f "$HOME/.config/fish/fish.config" ] && echo "export PATH=\"\$PATH:$LOCAL_BIN\"" >> $HOME/.config/fish/fish.config
else
    echo "[INFO] local_bin directory found in PATH, skipping it!"
fi

# create symbolic link to git_sync if not exists
if [ ! -L $LOCAL_BIN/git_sync ]
then
    echo "[INFO] git_sync symbolic link not found, creating it..."
    ln -s $DST/git_sync $LOCAL_BIN/git_sync
else
    echo "[INFO] git_sync symbolic link found, skipping it!"
fi

# check git_sync has execution permission, if not, add it
if [ ! -x $DST ]
then
    echo "[INFO] git_sync not executable, adding it..."
    chmod +x $DST
else
    echo "[INFO] git_sync is already an executable file, skipping it!"
fi

# if FRESH_INSTALL is true, then print the installation message
if [ "$FRESH_INSTALL" = true ]
then
    echo "[INFO] git_sync installed successfully, please open a new terminal to use it!"
fi