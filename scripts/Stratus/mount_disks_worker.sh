#!/bin/bash
read -p "What is the IP address of the controller node? " controller
sudo mkdir -p /WRF
sudo mkdir -p /GEOG
sudo mkdir -p /LOGS
sudo mount $controller:/WRF /WRF || true
sudo mount $controller:/GEOG /GEOG || true
sudo mount $controller:/LOGS /LOGS || true
echo "Disks mounted."