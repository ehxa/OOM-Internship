export DIR=$HOME/wrf/libs
export CFLAGS="-march=armv8-a"
export CC="gcc $CFLAGS"
export CXX="g++ $CFLAGS"
export FC=gfortran
export FCFLAGS="-march=armv8-a -m64"
export F77=gfortran
export FFLAGS="-march=armv8-a -m64"
export HDF5=$DIR
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/include
export LDFLAGS=-L$DIR/lib
export PATH=$DIR/bin:$PATH
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export NETCDF=$DIR