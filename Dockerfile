FROM ubuntu:16.04

ENV USER root
ENV DEBIAN_FRONTEND noninteractive

# Install VNC server
RUN apt-get update && apt-get install -y tightvncserver xterm wget

# Install KeePassXC
RUN wget https://github.com/magkopian/keepassxc-debian/releases/download/2.1.3-1/keepassxc_2.1.3-1_amd64_stable.deb && dpkg -i *.deb || apt-get install -y -f

# Setup VNC
RUN echo "keepassxc\nkeepassxc\n\n" | vncpasswd
COPY xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# Setup KeePassXC
COPY keepassxc.ini /root/.config/keepassxc/keepassxc.ini
RUN mkdir /var/keepassxc && touch /var/keepassxc/db.kdbx && dd if=/dev/urandom of=/var/keepassxc/db.key bs=1 count=2048

# Create startup script
COPY keepassxc /opt/keepassxc
RUN chmod +x /opt/keepassxc

# Define entrypoint
ENTRYPOINT ["/opt/keepassxc"]

# Define volumes
VOLUME ["/var/keepassxc"]
