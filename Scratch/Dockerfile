FROM scratch

ENV DIR=/wrf/libs
ENV HDF5=$DIR
ENV LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
ENV CPPFLAGS=-I$DIR/include
ENV LDFLAGS=-L$DIR/lib
ENV PATH=$DIR/bin:$PATH
ENV JASPERLIB=$DIR/lib
ENV JASPERINC=$DIR/include
ENV NETCDF=$DIR

COPY /WRF /wrf/WRF
COPY /libs /wrf/libs

WORKDIR /wrf/WRF/WRF/test/em_real

RUN ln -sf /wrf/libs/bin/mpiexec.hydra /wrf/libs/bin/mpirun

CMD ["mpirun", "-np", "1", "./wrf.exe"]