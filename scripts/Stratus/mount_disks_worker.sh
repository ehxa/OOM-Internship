#!/bin/bash
read -p "What is the IP address of the controller node? " controller
sudo mount $controller:/WRF /WRF || true
sudo mount $controller:/GEOG /GEOG || true
sudo mount $controller:/LOGS /LOGS || true
lsblk
echo "Disks mounted."