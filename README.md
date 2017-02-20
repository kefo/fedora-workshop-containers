# Docker Dev Containers, plus Chef scripts

These can be used to generate various development containers that can be run
simultaneously to mimic the multi-server environment that is our reality.

The Docker containers are actually themselves very simple.  The base container 
image is the Centos system, on top of which chef-client has been installed.  Then,
the docker build script invokes a Chef cookbook, which has a number of recipes.  It 
is Chef that really does the work of creating the container contents.

This design, while somewhat convoluted (one could have just written everything in Docker
and dispensed with the Chef stuff) is done with the hope that Chef can be employed
within the walls of AIC to assist with server configuration management.  In this 
way, ideally, the Chef scripts are transferrable.  (Not without significant additions
to match the actual environment the way Rafe and Mike want things done.)

## Helpful commands

See README files that are part of each 'box' for specifics on building and running 
those containers.

### Running docker

```bash
docker-machine restart
docker-machine env
eval $(docker-machine env)
```

### Keeping things clean

Remove unused containers and images:

```bash
docker rm `docker ps --no-trunc -aq`
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi
```

The second command may require modification to run on Linux.


  