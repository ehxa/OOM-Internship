#!/bin/bash
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/hdf5/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/libpng/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/netcdf/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/szip/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/udunitslib/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:/opt/zlib/lib:$LD_LIBRARY_PATH
. /opt/intel/oneapi/setvars.sh