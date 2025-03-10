#!/bin/bash
read -p "What is the IP address of the controller node? " controller
sudo mkdir -p /WRF /GEOG /LOGS
sudo mount $controller:/WRF /WRF || echo "Failed to mount /WRF"
sudo mount $controller:/GEOG /GEOG || echo "Failed to mount /GEOG"
sudo mount $controller:/LOGS /LOGS || echo "Failed to mount /GEOG"
echo "Disks mounted."