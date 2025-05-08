FROM ehxa/oom:ubuntu24.04-gcc-20250130-1250-configured
LABEL version="0.5"

RUN sudo apt update && \
    sudo apt install -y openssh-server && \
    sudo mkdir -p /var/run/sshd

CMD ["/usr/sbin/sshd", "-D", "-e"]