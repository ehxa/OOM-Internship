#!/bin/bash
#VM instance Intel oneAPI preparation (Ubuntu)
#Author: Diogo Gouveia (ehxa)
#Version: 20250224 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

sudo mkdir -p $HOME/wrf
sudo mkdir -p /WRF
sudo mount /dev/sdb1 /WRF || true
sudo mkdir -p /GEOG
sudo mount /dev/sdc1 /GEOG || true
sudo mkdir -p /LOGS
sudo mount /dev/sdd1 /LOGS || true
sudo tar -xvzf /WRF/wrf_input.tar.gz -C /home/ubuntu/wrf/ARM/
sudo apt update
wget "https://www.dropbox.com/scl/fi/zsvu66rr2gn4cixrv0jv0/l_HPCKit_p_2021.4.0.3347_offline.sh?rlkey=r94kwgrnu85fp4seqzkbem50f&st=lx8fl8nl&dl=0"
mv 'l_HPCKit_p_2021.4.0.3347_offline.sh?rlkey=r94kwgrnu85fp4seqzkbem50f&st=lx8fl8nl&dl=0' l_HPCKit_p_2021.4.0.3347_offline.sh
chmod u+x l_HPCKit_p_2021.4.0.3347_offline.sh
./l_HPCKit_p_2021.4.0.3347_offline.sh
mkdir $HOME/wrf && mkdir $HOME/wrf/libs && mkdir $HOME/wrf/Downloads && mkdir $HOME/wrf/WRF && mkdir $HOME/wrf/DATA
cd $HOME/wrf/libs
wget -c https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/zlib-1.2.11.tar.gz && wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz && wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz && wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && wget -c http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz && wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz && wget -c https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz 
tar -xvzf zlib-1.2.11.tar.gz && tar -xvzf hdf5-1.10.5.tar.gz && tar -xvzf v4.9.2.tar.gz && tar -xvzf v4.6.1.tar.gz && tar -xvzf mpich-3.3.1.tar.gz && tar -xvzf libpng-1.6.37.tar.gz && tar -xvzf jasper-1.900.1.tar.gz
cd $HOME/wrf/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz && wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.2.tar.gz
tar -xvzf v4.4.2.tar.gz -C $HOME/wrf/WRF && tar -xvzf v4.2.tar.gz -C $HOME/wrf/WRF && mv $HOME/wrf/WRF/WPS-4.2 $HOME/wrf/WRF/WPS
cd $HOME/wrf
wget https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/ICC/iccvars.sh