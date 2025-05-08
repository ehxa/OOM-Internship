# Containerizing and Evaluating the WRF model for Cloud-Based HPC

This work is part of the Master of Science Degree for Informatics Engineering with the aim of studying the WRF (Weather Research & Forecasting) model on multiple platforms and environments, while leveraging native, Docker, Slurm and Kubernetes technologies.
As such, we aim to ease the use of WRF with Docker images on HPC clusters and Cloud environments, while evaluating its performance.

## You can find this work divided in 5 directories:
1. Docker: Docker files
2. Kubernetes: Deployments for using WRF with Kubernetes
3. Slurm: How to configure and use WRF using Slurm. 
4. logs: Test results using sample data from NCEP (National Centers for Environment Prediction (NCEP).
5. scripts: Scripts for General and CSP (Cloud Service Provider) specific (CNCA's (National Center for Advanced Computing) Stratus cloud platform) configuration and WRF execution.

### The developed Docker images can be found on the following Docker Hub repository: 
- https://hub.docker.com/repository/docker/ehxa/oom/general

### The most recent working image (linux/amd64) is: 
- _ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured_
- <ins>Note:</ins> Other images are kept for record or further development/analysis and are provided as is. This includes images with newer dates. As such, please refer always to the image pointed above.

### Credits: 
- OOM (Observatório Oceânico da Madeira)
- NCAR (National Center for Atmospheric Research)
- FCT (Fundação para a Ciência e a Tecnologia)
