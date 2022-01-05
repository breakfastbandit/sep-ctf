#!/bin/bash

service ssh start
apachectl restart

while true; do sleep 1; done
