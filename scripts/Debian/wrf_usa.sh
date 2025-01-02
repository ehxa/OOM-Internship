#Prepare WPS
cd $HOME/wrf/Downloads && wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz 
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/wrf/WRF
cd $HOME/wrf/WRF/WPS && vim namelist.wps #change geog_path
cd $HOME/wrf/DATA && wget https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.20240825/00/atmos/gfs.t00z.pgrb2.0p25.f000 && wget https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.20240825/00/atmos/gfs.t00z.pgrb2.0p25.f003 && wget https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.20240825/00/atmos/gfs.t00z.pgrb2.0p25.f006 
cd $HOME/wrf/WRF/WPS && ./geogrid.exe >& log.geogrid
ls -ls geo_em* #confirm that files were created successfully
./link_grib.csh $HOME/wrf/DATA/gfs*
ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable

#Install wgrib2
#cd $HOME/wrf && wget https://github.com/NOAA-EMC/wgrib2/archive/refs/tags/v3.3.0.tar.gz && tar -xzvf v3.3.0.tar.gz && cd wgrib2-3.3.0 && mkdir build && cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=install -DCMAKE_PREFIX_PATH=$DIR
#make
#make install
#export PATH=$HOME/wrf/wgrib2-3.3.0/build/install/bin:$PATH
#wgrib2 --version #verify that it is working

#Verify GFS files
cd $HOME/wrf/DATA
wgrib2 gfs.t00z.pgrb2.0p25.f000
wgrib2 gfs.t00z.pgrb2.0p25.f003
wgrib2 gfs.t00z.pgrb2.0p25.f006 

#Change interval in WPS
cd $HOME/wrf/WRF/WPS
vim namelist.wps #modify start_date, end_date, ann interval_seconds (10800)

#Run ungrib
./ungrib.exe
ls -ls FILE* #confirm that these files were created

#Run metgrid
./metgrid.exe |& tee log.metgrid
ls -ls met_em* #confirm that these files were created


#Prepare WRF
cd $HOME/wrf/WRF/WRF/test/em_real && ln -sf $HOME/wrf/WRF/WPS/met_em* .
ncdump -h met_em.d0x.2024-08-25_00:00:00.nc #do this to check all variables data and take notes #check all met_em* files
vim namelist.input
#modify run_hours, start_year, start_month, start_day, start_hour, end_year, end_month, end_day, end_hour
#e_sn(SOUTH-NORTH_GRID_DIMENSION), e_we(WEST-EAST_GRID_DIMENSION), dx, dy, j_parent_start
#in parentheses theres the corresponding variable name inside the met_em* files


#Run WRF test
mpirun -np 1 ./real.exe
#if any other parameters need to be changed, use cat rsl.error.0000 to check which ones
tail rsl.error.0000 #output shall print "SUCCESSFUL"
ls -ls wrf* #check if files wrfbdy_d01, and wrfinput_d0* were created

#Run WRF
mpirun -np 1 ./wrf.exe #use -np n according to the number of CPU cores
tail rsl.error.0000 #output shall print "SUCCESSFUL"
ls -ls wrf* #check if files wrfbdy_d01, wrfout_d0* were created

#Run WRF from script
chmod u+x $HOME/wrf/OOM-Internship/scripts/wrf_run.sh #Add run permissions to the user
$HOME/wrf/OOM-Internship/scripts/wrf_run.sh