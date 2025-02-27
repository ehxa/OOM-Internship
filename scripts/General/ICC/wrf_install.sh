#WIP

$DIR="/home/ubuntu/wrf/libs"

#Start Intel oneAPI
. /home/ubuntu/intel/oneapi/setvars.sh

#Set Intel oneAPI variables
export OPTIM="-O3"
export CC=icc
export CXX=icpc
export CFLAGS=${OPTIM}
export CXXFLAGS=${OPTIM}
export F77=ifort
export FC=ifort
export F90=ifort
export FFLAGS=${OPTIM}
export CPP="icc -E"
export CXXCPP="icpc -E"

#Download libraries
wget -c https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/zlib-1.2.11.tar.gz && wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz && wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz && wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz && wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz && wget -c https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz 

#Extract libraries
tar -xvzf zlib-1.2.11.tar.gz && tar -xvzf hdf5-1.10.5.tar.gz && tar -xvzf v4.9.2.tar.gz && tar -xvzf v4.6.1.tar.gz && tar -xvzf libpng-1.6.37.tar.gz && tar -xvzf jasper-1.900.1.tar.gz

