#!/bin/bash
#AOCC Installation Guide (amd64)

#docker run -d --name ubuntu24.04-wrf-aocc ehxa/oom:ubuntu24.04-aocc-v0.1 tail -f /dev/null
export SPACK_ROOT=$HOME/spack
git clone -c feature.manyFiles=true https://github.com/spack/spack.git ${SPACK_ROOT}
. ${SPACK_ROOT}/share/spack/setup-env.sh
spack install aocc +license-agreed
spack cd -i aocc
spack compiler add $PWD
spack load aocc
spack install wrf %aocc@4.4.2 build_type=dmpar #^openmpi fabrics=cma,ucx