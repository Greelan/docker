FROM cubecoders/ampbase

RUN mkdir -pm755 /etc/apt/keyrings &&\
 wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key &&\
 wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources &&\
 apt-get update &&\
 apt-get install -y --install-recommends winehq-stable winbind xvfb &&\
 apt-get clean && rm -rf /var/lib/apt/lists/* &&\
 mkdir -pm755 /usr/share/wine/mono/wine-mono-7.0.0 &&\
 wget -O - https://dl.winehq.org/wine/wine-mono/7.0.0/wine-mono-7.0.0-x86.tar.xz | tar -Jxv -C /usr/share/wine/mono/wine-mono-7.0.0
 
ENTRYPOINT ["/ampstart.sh"]
CMD []
