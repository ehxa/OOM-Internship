#!/bin/bash
#WRF Installation Guide (amd64)
#Author: Diogo Gouveia (ehxa)
#Version: 20250102 (WIP)
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

#Create Directories
mkdir $HOME/wrf && mkdir $HOME/wrf/libs && mkdir $HOME/wrf/Downloads && mkdir $HOME/wrf/WRF && mkdir $HOME/wrf/DATA

#gcc 9.5 and g++
sudo apt-get update && \
sudo apt-get -y install gcc-9 g++-9 gfortran-9 && \
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9 && \
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9 && \
sudo update-alternatives --set gcc /usr/bin/gcc-9 && \
sudo update-alternatives --set g++ /usr/bin/g++-9 && \
sudo ln -s /usr/bin/gfortran-9 /usr/bin/gfortran
gcc --version
g++ --version
gfortran --version

#Install packages
sudo apt install -y make libxml2-dev m4 libcurl4-openssl-dev libtool csh

#Download Libraries
cd $HOME/wrf/libs
wget -c https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/zlib-1.2.11.tar.gz && wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz && wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz && wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && wget -c http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz && wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz && wget -c https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz 

#Extract Libraries
tar -xvzf zlib-1.2.11.tar.gz && tar -xvzf hdf5-1.10.5.tar.gz && tar -xvzf v4.9.2.tar.gz && tar -xvzf v4.6.1.tar.gz && tar -xvzf mpich-3.3.1.tar.gz && tar -xvzf libpng-1.6.37.tar.gz && tar -xvzf jasper-1.900.1.tar.gz

#Download WRF & WPS
cd $HOME/wrf/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz && wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.2.tar.gz

#Extract WRF & WPS
tar -xvzf v4.4.2.tar.gz -C $HOME/wrf/WRF && tar -xvzf v4.2.tar.gz -C $HOME/wrf/WRF && mv $HOME/wrf/WRF/WPS-4.2 $HOME/wrf/WRF/WPS

#Set environment variables
cd $HOME/wrf
wget -O $HOME/wrf/gccvars.sh https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/General/gccvars.sh
. $HOME/wrf/gccvars.sh

#Install zlib
cd $HOME/wrf/libs/zlib-1.2.11 && ./configure --prefix=$DIR
make -j$(nproc)
make install

#Install hdf5
cd $HOME/wrf/libs/hdf5-1.10.5 && ./configure --prefix=$DIR --with-zlib=$DIR --enable-fortran --enable-shared
make -j$(nproc)
make install

#Install netcdf-c
cd $HOME/wrf/libs/netcdf-c-4.9.2 && ./configure --prefix=$DIR --enable-netcdf-4
make -j$(nproc)
make install

#Install netcdf-fortran
cd $HOME/wrf/libs/netcdf-fortran-4.6.1 && export HDF5_PLUGIN_PATH=$DIR && export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" && ./configure --prefix=$DIR
make -j$(nproc)
make install

#Install mpich
cd $HOME/wrf/libs/mpich-3.3.1 && ./configure --prefix=$DIR 
make -j$(nproc) 
make install

#Install libpng
cd $HOME/wrf/libs/libpng-1.6.37 && ./configure --prefix=$DIR
make -j$(nproc)
make install

#Install jasper
cd $HOME/wrf/libs/jasper-1.900.1
autoreconf -i && ./configure --prefix=$DIR
make -j$(nproc)
make install

#Install WRF
cd $HOME/wrf/WRF/WRF && export LDFLAGS="-L$HOME/wrf/libs/lib -lhdf5 -lhdf5_hl -lhdf5_fortran -lhdf5hl_fortran -lnetcdf -lnetcdff -lmpi -lmpifort -lmpich -lmpicxx -ljasper -lpng16 -lz"
sed -i '919s/==/=/g' "configure"
./clean -a && echo -e "34\n1\n" | ./configure
cp share/landread.c share/landread.backup && cp share/landread.c.dist share/landread.c
./compile em_real | tee wrf_compilation.log

#Install WPS
export WRF_DIR=$HOME/wrf/WRF/WRF && cd $HOME/wrf/WRF/WPS && ./clean -a && echo -e "3\n" | ./configure
./compile | tee wps_compilation.log

#Remove unneccssary files
cd $HOME/wrf/Downloads && rm -rf *
cd $HOME/wrf/libs && rm -rf hdf5-1.10.5.tar.gz jasper-1.900.1.tar.gz libpng-1.6.37.tar.gz mpich-3.3.1.tar.gz v4.6.1.tar.gz v4.9.2.tar.gz zlib-1.2.11.tar.gz