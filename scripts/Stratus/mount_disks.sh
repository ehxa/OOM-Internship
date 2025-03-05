#!/bin/bash
sudo mkdir -p /WRF
sudo mkdir -p /GEOG
sudo mkdir -p /LOGS
sudo mount /dev/sdb1 /WRF || true
sudo mount /dev/sdc1 /GEOG || true
sudo mount /dev/sdd1 /LOGS || true
lsblk