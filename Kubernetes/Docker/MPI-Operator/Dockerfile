FROM debian:latest

RUN apt-get update && apt-get install -y bash coreutils file

COPY --from=mpioperator/mpi-operator:master / / 

CMD ["/bin/bash"]
