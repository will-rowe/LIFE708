# LIFE708 --- BioDock
Course materials for LIFE708

-----------

## Intro

Please refer [here](https://will-rowe.github.io) or Liverpool Vital for full instructions on accessing and setting up the course materials.

This repo contains the course materials for the LIFE708 Masters module at the University of Liverpool.

This includes a Docker container that is designed to run the practical sessions.

This Docker container is a stripped down version of [BioDock](https://github.com/will-rowe/biodock).

The rest of this readme will describe how to run the BioDock container.


## Contact
### Will Rowe

* Website: [Will Rowe](https://will-rowe.github.io)
* Lab website: [hintonlab.com](http://www.hintonlab.com)
* Email: [Will Rowe @ Liverpool](will.rowe@liverpool.ac.uk)




## Running the Docker container

  If you are on a Mac, start your Docker machine:

  `docker-machine start MACHINE-NAME`

  `eval "$(docker-machine env MACHINE-NAME)"`


  Pull the biodock image from Docker Hub:

  `docker pull wpmr/biodock:latest`


  Alternatively, clone this git and build the biodock image from the Dockerfile:

  `git clone https://gitlab.com/will_rowe/biodock.git`

  `cd biodock`

  `docker build -t wpmr/biodock:latest .`


  Launch the Docker container, making sure to mount a volume (allowing you to transfer data in and out of the container):

  `docker run -itP --rm  -m 8g --name biodock -v ~/Desktop/SCRATCH/:/SCRATCH wpmr/biodock:latest`

  + -i = keep STDIN open even if not attached

  + -t = allocate a pseudo-tty

  + -P = publish all exposed ports to the host interfaces

  + --rm = makes container emphemeral

  + -m = memory limit (8gb)

  + --name = name for container at runtime (easy to use for later exec commands)

  + -v = bind mount a volume (for data transfer etc. between container and host machine). Usage-> [host-src:]container-dest[:<options>]. The comma-delimited `options` are [rw|ro], [z|Z], [[r]shared|[r]slave|[r]private], and [nocopy].




## Usage

  This Docker container (and git repo) is intended to provide a standardised environment for running bioinformatics pipelines, scripts and software.


  The container will launch bash by default, all software is in the path and scripts from the git repo are in /opt/SCRIPT_bin (also in path)


  A few helpful commands for managing the container:

  + Once exited, you can re-enter the container using the exec command:

  `docker exec -it [CONTAINER ID] bash`

  + View all containers (both running and stopped) using:

  `docker ps -a`

  + Stop or remove all containers

  `docker stop $(docker ps -aq)`

  `docker rm $(docker ps -aq)`




## Notes

  + The CPUs available to Docker are limited by the host machine running docker, so set the virtual machine to have the required number before running Docker.

  + The Kernel scheduler will handle the resource contention in the case of multiple containers requiring multiple cores.
