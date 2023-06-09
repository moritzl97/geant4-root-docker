FROM  ubuntu:18.04

# Image meta data
ARG GEANT_ARCHIVE_URL="https://gitlab.cern.ch/geant4/geant4/-/archive"
ARG GEANT_VERSION="10.5.1"
ARG ROOT_BIN="root_v6.13.08.Linux-ubuntu18-x86_64-gcc7.3.tar.gz"
ARG ROOT_ARCHIVE_URL="https://root.cern/download/"

#Geant installation

#Geant packages
RUN apt-get update -qq && apt-get install -y -qq\
    qt5-default \
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
    git \
    && rm -rf /var/lib/apt/lists/*

#Install hbar

WORKDIR /home/hbar
RUN mkdir output
RUN git clone https://gitlab.cern.ch/ASACUSA-CUSP/hbar-g4-gshfs.git
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN /usr/local/bin/docker-entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "/bin/bash" ]