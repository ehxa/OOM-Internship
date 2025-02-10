
export DIR=$HOME/wrf/libs
export CC=clang
export CXX=clang++
export FC=flang
export F77=flang
export FCFLAGS="-m64"
export FFLAGS="-m64"
export HDF5=$DIR
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/include
export LDFLAGS=-L$DIR/lib
export PATH=$DIR/bin:$PATH
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export NETCDF=$DIR
