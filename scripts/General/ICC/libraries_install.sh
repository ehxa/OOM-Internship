#Credits: Han Soo Lee, Coastal Hazards and Energy System Science (CHESS) Lab 
#(広島大学大学院先進理工系科学研究科 理工学融合プログラム 沿岸災害・エネルギーシステム科学研究室)
#https://home.hiroshima-u.ac.jp/~leehs/?page_id=5612
#https://home.hiroshima-u.ac.jp/~leehs/?page_id=5645

DIR="/home/ubuntu/wrf/libs"

#Intel oneAPI variables
. /home/ubuntu/intel/oneapi/setvars.sh
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

#Install required libraries
sudo apt-get install libexpat1-dev

#Create directories
mkdir wrf
mkdir wrf/libs
cd $DIR

#CUnit
version_cunit="2.1-2"
wget -O CUnit-${version_cunit}-src.tar.bz2 "https://master.dl.sourceforge.net/project/cunit/CUnit/$version_cunit/CUnit-$version_cunit-src.tar.bz2?viasf=1"
tar xf CUnit-${version_cunit}-src.tar.bz2
cd CUnit-${version_cunit}
./configure --prefix=${DIR}/CUnit/${version_cunit}
make
make install
export LD_LIBRARY_PATH="$DIR/CUnit/2.1-2/lib:$LD_LIBRARY_PATH"
cd $DIR

#UDUNITS
version_udunits="2.2.28"
wget https://downloads.unidata.ucar.edu/udunits/${version_udunits}/udunits-${version_udunits}.tar.gz
tar xf udunits-${version_udunits}.tar.gz
cd udunits-${version_udunits}
./configure --prefix="${DIR}/udunits/${version_udunits}"
make
make check
make install
make clean
export UDUNITS2_XML_PATH="$DIR/udunits/2.2.28/share/udunits/udunits2.xml"
export PATH="$DIR/udunits/2.2.28/bin:$PATH"
cd $DIR

#SZIP
version_szip="2.1.1"
wget https://support.hdfgroup.org/ftp/lib-external/szip/${version_szip}/src/szip-${version_szip}.tar.gz
tar xf szip-${version_szip}.tar.gz
cd szip-${version_szip}
./configure --prefix=${DIR}/szip/${version_szip}
make
make check
make install
cd $DIR

#zlib
version_zlib="1.3.1"
wget https://zlib.net/zlib-${version_zlib}.tar.gz
tar xf zlib-${version_zlib}.tar.gz
cd zlib-${version_zlib}
./configure --prefix=${DIR}/zlib/${version_zlib}
make
make install
cd $DIR

#HDF5
version_hdf5="1.12.0"
version_zlib="1.3.1"
version_szip="2.1.1"
tar xf hdf5-${version_hdf5}.tar.gz
cd hdf5-${version_hdf5}
./configure --prefix=${DIR}/hdf5/${version_hdf5} --with-zlib=${DIR}/zlib/${version_zlib}/include,${DIR}/zlib/${version_zlib}/lib --with-szlib=${DIR}/szip/${version_szip}/lib --enable-hl --enable-fortran --with-default-api-version=v18
make
make check
make install
make check-install
cd $DIR

#Curl
version_curl="7.76.1"
wget https://curl.se/download/curl-${version_curl}.tar.gz
tar xf curl-${version_curl}.tar.gz
cd curl-${version_curl}/
export OPTIM="-O3 -mcmodel=large -fPIC" # "-mcmodel=large" option is necessary
export CC=icc
export CXX=icpc
export CPP="icc -E -mcmodel=large"
export CXXCPP="icpc -E -mcmodel=large"
export CFLAGS="${OPTIM}"
export CXXFLAGS="${OPTIM}"
./configure --prefix=${DIR}/curl/${version_curl}
make
make install
cd $DIR

#Netcdf4-C
version_netcdf4="4.8.1"
wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v${version_netcdf4}.tar.gz
tar xf v${version_netcdf4}.tar.gz
cd netcdf-c-${version_netcdf4}/
export LDFLAGS="-L${DIR}/hdf5/${version_hdf5}/lib -L${DIR}/zlib/${version_zlib}/lib -L${DIR}/curl/${version_curl}/lib"
export CPPFLAGS="-I${DIR}/hdf5/${version_hdf5}/include -I${DIR}/zlib/${version_zlib}/include ${LDFLAGS} -I${DIR}/curl/${version_curl}/include"
export OPTIM="-O3 -mcmodel=large -fPIC ${LDFLAGS}"
export CC=icc
export CXX=icpc
export CPP="icc -E -mcmodel=large"
export CXXCPP="icpc -E -mcmodel=large"
export CFLAGS="${OPTIM}"
export CXXFLAGS="${OPTIM}"
./configure --prefix=${DIR}/netcdf4-intel --enable-large-file-tests --with-pic
make
make check
make install
cd $DIR

#Netcdf4-Fortran
version_netcdf4_fortran="4.6.1"
wget https://downloads.unidata.ucar.edu/netcdf-fortran/${version_netcdf4_fortran}/netcdf-fortran-${version_netcdf4_fortran}.tar.gz
tar xf netcdf-fortran-${version_netcdf4_fortran}.tar.gz
cd netcdf-fortran-${version_netcdf4_fortran}
export NCDIR="${DIR}/netcdf4-intel"
export LD_LIBRARY_PATH="${NCDIR}/lib:${LD_LIBRARY_PATH}"
export NFDIR="${DIR}/netcdf4-intel"
export CPPFLAGS="-I${NCDIR}/include"
export LDFLAGS="-L${NCDIR}/lib"
export OPTIM="-O3 -mcmodel=large -fPIC ${LDFLAGS}"
export CC=icc
export FC=ifort
export F77=ifort
export F90=ifort
export CPP="icc -E -mcmodel=large"
export CXXCPP="icpc -E -mcmodel=large"
export CPPFLAGS="-DNDEBUG -DpgiFortran ${LDFLAGS} $CPPFLAGS"
export CFLAGS="${OPTIM}"
export FCFLAGS="${OPTIM}"
export F77FLAGS="${OPTIM}"
export F90FLAGS="${OPTIM}"
./configure --prefix=${NFDIR} --enable-large-file-tests --with-pic
make
make check
make install
export PATH="$DIR/netcdf4-intel/bin:$PATH"
export LD_LIBRARY_PATH="$DIR/netcdf4-intel/lib:$LD_LIBRARY_PATH"
cd $DIR

#libpng
version_libpng="1.6.43"
wget http://prdownloads.sourceforge.net/libpng/libpng-${version_libpng}.tar.gz
tar xvf libpng-${version_libpng}.tar.gz
cd libpng-${version_libpng}/
./configure --prefix=${HOME}/libpng/${version_libpng}
make
make install
cd $DIR

#Jasper
version_jasper="1.900.29"
wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-${version_jasper}.tar.gz
tar xvf jasper-${version_jasper}.tar.gz
cd jasper-${version_jasper}/
./configure --prefix=${HOME}/jasper/${version_jasper}
make
make install
export JASPERLIB="-L$DIR/jasper/1.900.29/lib"
export JASPERINC="-I$DIR/jasper/1.900.29/include"
cd $DIR

export UDUNITS2_XML_PATH="$DIR/udunits/2.2.28/share/udunits/udunits2.xml"
export PATH="$DIR/udunits/2.2.28/bin:$PATH"