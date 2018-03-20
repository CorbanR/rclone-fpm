#!/bin/sh

# Ensure permissions are correct
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone

# Updated man index
mandb
