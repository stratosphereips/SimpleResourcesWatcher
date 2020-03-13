# Simple Resource Watcher

This simple program is designed to monitor certain resources in a Linux based server and send alerts to Slack.

## Dependencies

The SRWatcher requires the following packages: curl, ps, free

## Usage

Usage: 
```
Simple Resource Watcher. Version: 0.1
Author: Veronica Valeros (vero.valeros@gmail.com)

./srwatcher.sh [interface] [slack.auth]
```

Example output:
```
./srwatcher.sh eth0 slack.auth

2020/03/13 20:04:41, Network Download *24 kB/s*, Network Upload *1987 kB/s*, Available RAM: *21 GB*.
```
