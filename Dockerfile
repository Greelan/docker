FROM cubecoders/ampbase

RUN apt-get update &&\
 apt-get install -y winbind &&\
 apt-get clean && rm -rf /var/lib/apt/lists/*
 
RUN mkdir -pm755 /etc/apt/keyrings &&\
 wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key &&\
 wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources &&\
 apt-get update &&\
 apt-get install -y --install-recommends winehq-stable &&\
 apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ampstart.sh"]
CMD []
