#!/bin/bash
export LD_LIBRARY_PATH=/opt/hdf5/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/libpng/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/netcdf/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/szip/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/udunitslib/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/zlib/lib:$LD_LIBRARY_PATH
. /opt/intel/oneapi/setvars.sh