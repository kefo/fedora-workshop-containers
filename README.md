# Docker Dev Containers, plus Chef scripts

These can be used to generate various development containers that can be run
simultaneously to mimic a multi-server environment.

The Docker containers are actually themselves very simple.  The base container 
image is the Centos system, on top of which chef-client has been installed.  Then,
the docker build script invokes a Chef cookbook, which has a number of recipes.  It 
is Chef that really does the work of creating the container contents.

This design, while somewhat convoluted (one could have just written everything in Docker
and dispensed with the Chef stuff) is done with expectation that the Chef scripts 
will be used to assist with server configuration management.

A `docker-compose` file is included to simplify the use of these containers.

The `karaf` container provides a fresh installation of the Karaf software.  Any
changes to the container, such as adding an indexing application to Karaf, will
not be saved when you exit the container.

## Getting Started

See README files that are part of each 'box' for specifics on building and running 
those containers.

It will be necessary to make a change to your local `hosts` file.  On a Mac or Linux
machine, this file is located at `/etc/hosts/`.  Add the following lines:

```bash
127.0.0.1  fcrepobox
127.0.0.1  bgbox
127.0.0.1  solrbox
```

Then start the containers.  Running each of the following commands in its own terminal window will help
to visualize the event messaging and data flow.

```
docker-compose up fcrepo
docker-compose up triplestore
docker-compose up solr
docker-compose run karaf bash
```

### docker-machine

If you use docker-machine, you will need to use the docker-machine's IP address.  
This is probably 192.168.99.100, but it may be different.



  