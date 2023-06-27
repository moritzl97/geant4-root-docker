# geant4-root-docker
Dockerfiles to build dockerimages to run geant4 and root. Also contains hbar simulation code.

### Build
To build image go into respective folder and execute build
For hbar simulation choose branch or main
```
docker build -t moritzl97/hbar-sim-geant:latest .
docker build -t moritzl97/hbar-sim-geant:branch . --build-arg branch=true
```
Clean docker image
```
docker build -t moritzl97/hbar-sim-geant:clean .
```

### Run image
Run containter with
```
docker run -it --rm -e DISPLAY=$DISPLAY --network host --privileged --env QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix moritzl97/hbar-sim-geant bash
```
add ` :<tag_name> ` for different tags than latest
add ` -v path_to_your_directory:/home/hbar/output ` to link a local folder to the output folder in the docker

See also Dockerhub page for this project https://hub.docker.com/repository/docker/moritzl97/hbar-sim-geant/general
