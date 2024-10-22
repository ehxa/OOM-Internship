#!/bin/bash
. /opt/intel/oneapi/setvars.sh
export CC=gcc
export CXX=g++
export FCFLAGS="-m64"
export FFLAGS="-m64"
export HDF5=/opt/hdf5
export JASPERLIB=/opt/jasper/lib
export JASPERINC=/opt/jasper/include
export NETCDF=/opt/netcdf
export LD_LIBRARY_PATH=/opt:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/hdf5/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/jasper/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/libpng/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/szip/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/udunits/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/zlib/lib:$LD_LIBRARY_PATH