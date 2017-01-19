# LIFE708
Course materials for LIFE708

-----------

## Outline

This repo contains the course materials for the LIFE708 Masters module at the University of Liverpool.

This includes a Dockerfile for the [life708 container](https://hub.docker.com/r/wpmr/life708/) that is designed to help run the practical sessions - an automated build can be found on the Docker Hub.

Please refer [here](https://will-rowe.github.io/running-Docker) or Liverpool Vital for full instructions on accessing and setting up the course materials. The rest of this readme will describe how to run the life708 container.




## Contact
### Will Rowe

* Website: [Will Rowe](https://will-rowe.github.io)
* Lab website: [hintonlab.com](http://www.hintonlab.com)
* Email: [Will Rowe @ Liverpool](will.rowe@liverpool.ac.uk)




## Running the Docker container

  If you are on a Mac, start your Docker machine:

  `docker-machine start MACHINE-NAME`

  `eval "$(docker-machine env MACHINE-NAME)"`


  Pull the container image from Docker Hub:

  `docker pull wpmr/life708:latest`


  Alternatively, clone this git and build the biodock image from the Dockerfile:

  `git clone https://github.com/will-rowe/LIFE708.git`

  `cd LIFE708`

  `docker build -t wpmr/life708:latest .`


  Launch the Docker container, making sure to mount a volume (allowing you to transfer data in and out of the container):

  `docker run -itP -m 2g --name life708-$USER -v ~/Desktop/LIFE708-WORKSHOP/:/MOUNTED-VOLUME-LIFE708 wpmr/life708:latest`

  + -i = keep STDIN open even if not attached

  + -t = allocate a pseudo-tty

  + -P = publish all exposed ports to the host interfaces

  + -m = memory limit (8gb)

  + --name = name for container at runtime (easy to use for later exec commands)

  + -v = bind mount a volume (for data transfer etc. between container and host machine). Usage-> [host-src:]container-dest[:<options>]. The comma-delimited `options` are [rw|ro], [z|Z], [[r]shared|[r]slave|[r]private], and [nocopy].

  + --rm = makes container ephemeral




## Usage

  This Docker container (and git repo) is intended to provide a standardised environment for running bioinformatics pipelines, scripts and software.


  The container will launch bash by default, all software is in the path and scripts from the git repo are in /opt/scripts (also in path)


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
