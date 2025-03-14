#!/bin/bash
lsblk
read -p "Select WRF device letter: " wrf
read -p "Select GEOG device letter: " geog
read -p "Select LOGS device letter: " logs
sudo mkdir -p /WRF /GEOG /LOGS
sudo mount /dev/sd${wrf}1 /WRF || echo "Failed to mount /dev/sd${wrf}1"
ls /WRF
sudo mount /dev/sd${geog}1 /GEOG || echo "Failed to mount /dev/sd${geog}1"
ls /GEOG
sudo mount /dev/sd${logs}1 /LOGS || echo "Failed to mount /dev/sd${logs}1"
ls /LOGS
lsblk