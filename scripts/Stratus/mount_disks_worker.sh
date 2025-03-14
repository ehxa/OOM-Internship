#!/bin/bash
read -p "What is the IP address of the controller node? " controller
sudo mkdir -p /WRF /GEOG /LOGS
sudo mount $controller:/WRF /WRF || echo "Failed to mount /WRF"
echo "WRF:"
ls /WRF
echo ""
sudo mount $controller:/GEOG /GEOG || echo "Failed to mount /GEOG"
echo "GEOG:"
ls /GEOG
sudo mount $controller:/LOGS /LOGS || echo "Failed to mount /GEOG"
echo "LOGS:"
ls /LOGS
lsblk
echo "Disks mounted."