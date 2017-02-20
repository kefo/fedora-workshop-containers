FROM zuazo/chef-local:centos-6

# For some reason TAR is not on centos-6
# Need to install it.
RUN yum -y install tar.x86_64

RUN mkdir -p /tmp/chef/cookbooks/solr-box

# Copy the cookbook from the current working directory:
COPY . /tmp/chef/cookbooks/solr-box

RUN echo "environment_path '/tmp/chef/cookbooks/solr-box/environments'" >> /etc/chef/client.rb
RUN more /etc/chef/client.rb

# Download and install the cookbook and its dependencies in the cookbook path:
RUN berks vendor -b /tmp/chef/cookbooks/solr-box/Berksfile /tmp/chef/cookbooks

RUN ls -l /tmp/chef/cookbooks/

RUN chef-client --local-mode -c /etc/chef/client.rb -j /tmp/chef/cookbooks/solr-box/attributes/docker.json

EXPOSE 8983

# The below starts whatever runs on this server and pipes out a relevant logfile.
CMD /tmp/start.sh
