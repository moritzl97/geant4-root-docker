#!/bin/bash
set -e
source /usr/local/geant4/bin/geant4.sh
source /usr/local/geant4/share/Geant4-10.5.1/geant4make/geant4make.sh
exec "$@"
