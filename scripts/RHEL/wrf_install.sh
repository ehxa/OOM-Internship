#!/bin/bash
#WRF Installation Script
#Author: Diogo Gouveia (ehxa)
#Version: 20241114
#For the most recent updates check the repository: https://github.com/ehxa/OOM-Internship

#Create Directories
mkdir $HOME/wrf && mkdir $HOME/wrf/libs && mkdir $HOME/wrf/Downloads && mkdir $HOME/wrf/WRF && mkdir $HOME/wrf/DATA && mkdir $HOME/wrf/logs

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
wget https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/General/gccvars.sh 
source $HOME/wrf/gccvars.sh 

#Install zlib
cd $HOME/wrf/libs/zlib-1.2.11 && ./configure --prefix=$DIR
make
make install

#Install hdf5
cd $HOME/wrf/libs/hdf5-1.10.5 && ./configure --prefix=$DIR --with-zlib=$DIR --enable-fortran --enable-shared
make
make install

#Install netcdf-c
cd $HOME/wrf/libs/netcdf-c-4.9.2 && ./configure --prefix=$DIR --enable-netcdf-4
make 
make install

#Install netcdf-fortran
cd $HOME/wrf/libs/netcdf-fortran-4.6.1 && export HDF5_PLUGIN_PATH=$DIR && export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" && ./configure --prefix=$DIR
make
make install

#Install mpich
cd $HOME/wrf/libs/mpich-3.3.1 && ./configure --prefix=$DIR 
make -j 4
make install

#Install libpng
cd $HOME/wrf/libs/libpng-1.6.37 && ./configure --prefix=$DIR
make
make install

#Install jasper
cd $HOME/wrf/libs/jasper-1.900.1
autoreconf -i && ./configure --prefix=$DIR
make
make install

#Install WRF
cd $HOME/wrf/WRF/WRF && export LDFLAGS="-L$HOME/wrf/libs/lib -lhdf5 -lhdf5_hl -lhdf5_fortran -lhdf5hl_fortran -lnetcdf -lnetcdff -lmpi -lmpifort -lmpich -lmpicxx -ljasper -lpng16 -lz"
./clean -a && ./configure  #options 34 and 1 with gcc

cp share/landread.c share/landread.backup && cp share/landread.c.dist share/landread.c
./compile em_real

#Install WPS
export WRF_DIR=$HOME/wrf/WRF/WRF && cd $HOME/wrf/WRF/WPS && ./clean -a && ./configure #option 3
./compile

#Remove used tar.gz files
cd $HOME/wrf/libs
rm -rf hdf5-1.10.5.tar.gz jasper-1.900.1.tar.gz libpng-1.6.37.tar.gz mpich-3.3.1.tar.gz v4.6.1.tar.gz v4.9.2.tar.gz zlib-1.2.11.tar.gz
cd $HOME/wrf/Downloads
rm -rf v4.2.tar.gz v4.4.2.tar.gz

#Prepare WPS
cd $HOME/wrf/DATA && wget "https://testuma-my.sharepoint.com/:u:/g/personal/2042918_student_uma_pt/ESWwLZ2x3txNt4jCHJlc6PYBy1hmiqv6AadP2ZfcDv6C9Q?e=3ouLNW&download=1"
mv 'ESWwLZ2x3txNt4jCHJlc6PYBy1hmiqv6AadP2ZfcDv6C9Q?e=3ouLNW&download=1' usa.zip
unzip usa.zip
rm -rf usa.zip

cd $HOME/wrf/WRF/WPS && mv namelist.wps namelist.wps.backup
mv $HOME/wrf/DATA/usa/wps/namelist.wps namelist.wps
./geogrid.exe
ls -ls geo_em*
 ./link_grib.csh $HOME/wrf/DATA/usa/wps/gfs/gfs*
ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable
./ungrib.exe
ls -ls FILE*
./metgrid.exe
ls -ls met_em*

#Test
cd $HOME/wrf/WRF/WRF/test/em_real
ln -sf $HOME/wrf/WRF/WPS/met_em* .
mv namelist.input namelist.input.backup
mv $HOME/wrf/DATA/usa/wrf/namelist.input namelist.input
mpirun -np 1 ./real.exe
tail rsl.error.0000
ls -ls wrf*

#Add WRF Running script
cd $HOME/wrf
wget https://raw.githubusercontent.com/ehxa/OOM-Internship/refs/heads/main/scripts/General/wrf_run.sh
chmod u+x $HOME/wrf/OOM-Internship/scripts/wrf_run.sh #Add run permissions to the user