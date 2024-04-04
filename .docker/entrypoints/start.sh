#!/bin/bash

# Set to root directory
rootDir="/usr/src/wpp-server"
cd $rootDir

source .docker/entrypoints/helpers/unlock_profile.sh

profiles_locations="/userDataDir"

onStart(){
echo "Initializing..."
if [ -f config/config.json ]; then
    echo "Using existing config."
else
    echo "Creating new config => config/config.json"
    cp ./.config.example.json config/config.json
fi
find_and_delete_lock_files "$rootDir$profiles_locations"
}

onExit() {
    echo "Performing cleanup before exiting..."
    find_and_delete_lock_files "$rootDir$profiles_locations"
}

onStart

# Trap signals and call the cleanup function
trap 'onExit' EXIT TERM INT

# Run npm start in the background
npm start &

wait $!

exit 0
