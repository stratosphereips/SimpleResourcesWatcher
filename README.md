# Simple Resource Watcher

This simple program is designed to monitor the network bandwidth and available memory in a Linux server. If the network upload larger than 30 Mbps or the available memory is lower than 4 GB, it will send an alert to Slack. SRWatcher communicates with Slack using webhooks specified in the configuration file `slack.auth`. Slack alerts are send by default to channel #alerts.

## Dependencies

The SRWatcher requires the following packages: curl, ps, free.

## Usage

Usage: 
```
Simple Resource Watcher. Version: 0.1
Author: Veronica Valeros (vero.valeros@gmail.com)

./srwatcher.sh [interface] [slack.auth]
```

Command line output example:
```
./srwatcher.sh eth0 slack.auth

2020/03/13 20:04:41, Network Download *24 kB/s*, Network Upload *1987 kB/s*, Available RAM: *21 GB*.
```
