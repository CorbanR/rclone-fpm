#!/bin/sh

# Remove rclone binary and man file
rm /usr/bin/rclone
rm /usr/local/share/man/man1/rclone.1

# Updated man index
mandb
