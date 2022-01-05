#!/bin/bash

./apache2.sh &

./sshd.sh &

while true; do sleep 1; done
