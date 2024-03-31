#!/bin/bash

find_and_delete_lock_files() {
    find "$1" -maxdepth 2 -mindepth 2 -type f -name 'SingletonLock' -o -type l -name 'SingletonLock' | while read -r lock_file; do
        profile_name=$(basename "$(dirname "$lock_file")")
        echo "Unlock chrome profile $profile_name"
        rm "$lock_file"  # Remove the lock file or symbolic link
    done
}