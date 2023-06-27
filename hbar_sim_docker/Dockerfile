FROM  ubuntu:18.04


ARG GEANT_ARCHIVE_URL="https://gitlab.cern.ch/geant4/geant4/-/archive"
ARG GEANT_VERSION="10.5.1"
ARG ROOT_BIN="root_v6.13.08.Linux-ubuntu18-x86_64-gcc7.3.tar.gz"
ARG ROOT_ARCHIVE_URL="https://root.cern/download/"

#Geant installation

#Geant packages
RUN apt-get update -qq && apt-get install -y -qq\
    qt4-default \
    libglu1-mesa-dev \
    freeglut3-dev \
    mesa-common-dev \
    && rm -rf /var/lib/apt/lists/*

# Get a build chain for Geant4 and some extra dependencies
RUN apt update -y -qq                                                       && \
    apt install --no-install-recommends -qq -y                                 \
        wget cmake g++ ninja-build libxerces-c-dev                         && \
    apt autoremove -y -qq                                                   && \
    apt clean -y -qq                                                        && \
    rm -rf /var/lib/apt/lists/*

# Fetch the Geant4 source, build, install and clean
WORKDIR /tmp
RUN wget -q $GEANT_ARCHIVE_URL/v$GEANT_VERSION/geant4-v$GEANT_VERSION.tar.gz --no-check-certificate                       && \
    tar -xzf "geant4-v$GEANT_VERSION.tar.gz"                                    && \
    mv "geant4-v$GEANT_VERSION" geant4                                          && \
    mkdir geant4-build                                                      && \
    cd geant4-build                                                         && \
    cmake -GNinja                                                              \
          -DCMAKE_BUILD_TYPE=Release                                           \
          -DCMAKE_INSTALL_PREFIX=/usr/local/geant4                             \
          -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu                        \
          -DGEANT4_INSTALL_DATA=ON                                             \
          -DGEANT4_USE_QT=ON                                                   \
          -DGEANT4_USE_SYSTEM_CLHEP=OFF                                        \
          -DGEANT4_BUILD_CXXSTD=11                                             \
          -DGEANT4_USE_SYSTEM_EXPAT=OFF                                        \
          -DGEANT4_USE_GDML=ON                                                 \
          ../geant4                                                         && \
    ninja                                                                   && \
    ninja install                                                           && \
    cd ..                                                                   && \
    rm -rf geant4 geant4-build "geant4-v$GEANT_VERSION.tar.gz"


#Root installation
ENV LANG=C.UTF-8

WORKDIR /opt

COPY packages packages

RUN apt-get update -qq \
 && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
 && apt-get -y install $(cat packages) wget\
 && rm -rf /var/lib/apt/lists/*\
 && wget $ROOT_ARCHIVE_URL${ROOT_BIN} \
 && tar -xzvf ${ROOT_BIN} \
 && rm -f ${ROOT_BIN} \
 && echo /opt/root/lib >> /etc/ld.so.conf \
 && ldconfig
#RUN yes
# | unminimize

ENV ROOTSYS /opt/root
ENV PATH $ROOTSYS/bin:$PATH
ENV PYTHONPATH $ROOTSYS/lib:$PYTHONPATH
ENV CLING_STANDARD_PCH none

#Other installs
RUN apt-get update -qq && apt-get install -y -qq\
    nano \
    gedit \
    git \
    && rm -rf /var/lib/apt/lists/*

#Setup workdir
WORKDIR /home/hbar
RUN mkdir output

#Downloads random byte form the internet such that the following git command always gets downloaded and not loaded from the docker cache
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN rm skipcache

#Download hbar sim code hbar
ARG branch
RUN git clone https://gitlab.cern.ch/ASACUSA-CUSP/hbar-g4-gshfs.git
WORKDIR /home/hbar/hbar-g4-gshfs
#If argument --build-arg branch=true is not empty while building image checkout detector branch
RUN if [ "$branch"="true" ] ; then git checkout detector-upgrade; fi
#RUN git checkout detector-upgrade
#Copy fields form docker git
COPY fields /home/hbar/hbar-g4-gshfs/hbar_gshfs_FTF/fields

#################################################################################
#Sourcing doesnt work in docker because Path variables arent updated. Tried to run
#RUN ["/bin/bash", "-c", "source /usr/local/geant4/bin/geant4.sh"]
#RUN ["/bin/bash", "-c", "source /usr/local/geant4/share/Geant4-10.5.1/geant4make/geant4make.sh"]
#Therefore here are all the varible form those two sh files so geant4 code can be compiled:

#From /usr/local/geant4/share/Geant4-10.5.1/geant4make/geant4make.sh
ENV G4SYSTEM=Linux-g++
ENV G4INSTALL=/usr/local/geant4/share/Geant4-10.5.1/geant4make
ENV G4INCLUDE=/usr/local/geant4/include/Geant4
ENV G4LIB=/usr/local/geant4/lib/Geant4-10.5.1
ENV LD_LIBRARY_PATH = /usr/lib/x86_64-linux-gnu:/usr/local/geant4/lib:/usr/local/geant4/lib:/usr/lib/x86_64-linux-gnu
ENV G4WORKDIR=/root/geant4_workdir
ENV G4LIB_BUILD_SHARED=1
ENV G4LIB_USE_EXPAT=1
ENV G4LIB_USE_ZLIB=1
ENV G4LIB_USE_GDML=1
ENV XERCESCROOT=/usr

ENV G4UI_USE_TCSH=1
ENV QTHOME=/usr
ENV QTLIBPATH=/usr/lib/x86_64-linux-gnu
ENV G4UI_USE_QT=1
ENV G4VIS_USE_OPENGLQT=1

#From /usr/local/geant4/bin/geant4.sh
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/geant4/lib:/usr/local/geant4/lib:/usr/lib/x86_64-linux-gnu
ENV PATH=/root/geant4_workdir/bin/Linux-g++:/usr/local/geant4/bin:/usr/local/geant4/bin:/opt/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV G4NEUTRONHPDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4NDL4.5
ENV G4LEDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4EMLOW7.7
ENV G4LEVELGAMMADATA=/usr/local/geant4/share/Geant4-10.5.1/data/PhotonEvaporation5.3
ENV G4RADIOACTIVEDATA=/usr/local/geant4/share/Geant4-10.5.1/data/RadioactiveDecay5.3
ENV G4PARTICLEXSDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4PARTICLEXS1.1
ENV G4PIIDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4PII1.3
ENV G4REALSURFACEDATA=/usr/local/geant4/share/Geant4-10.5.1/data/RealSurface2.1.1
ENV G4SAIDXSDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4SAIDDATA2.0
ENV G4ABLADATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4ABLA3.1
ENV G4INCLDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4INCL1.0
ENV G4ENSDFSTATEDATA=/usr/local/geant4/share/Geant4-10.5.1/data/G4ENSDFSTATE2.2
#################################################################################


#Compile gshfs
WORKDIR /home/hbar/hbar-g4-gshfs
RUN chmod +x ./autoinstall.sh
RUN ./autoinstall.sh

#Entrypoint sources geant4
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#Start dir when running docker
WORKDIR /home/hbar

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "/bin/bash" ]