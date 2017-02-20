# https://github.com/zuazo/chef-local-docker
FROM zuazo/chef-local:centos-6

# Install postgres using Docker and not Chef.  There were issues.  Lots and lots of issues.
RUN rpm -Uvh https://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
RUN yum -y install postgresql94-server postgresql94

RUN service postgresql-9.4 initdb

RUN echo "local all postgres trust" > /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "listen_addresses='*'" >> /var/lib/pgsql/9.4/data/postgresql.conf

RUN service postgresql-9.4 start && su postgres -c "psql -U postgres -c \"alter user postgres with password 'rootpass';\""

USER root
RUN echo "local all postgres md5" > /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "local all all ident" >> /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "host all all 127.0.0.1/32 md5" >> /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "host all all ::1/128 md5" >> /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "host all all 192.168.99.0/24 md5" >> /var/lib/pgsql/9.4/data/pg_hba.conf
RUN echo "host all all 0.0.0.0/24 md5" >> /var/lib/pgsql/9.4/data/pg_hba.conf

RUN mkdir -p /tmp/chef/cookbooks/fedora-box

# Copy the cookbook from the current working directory:
COPY . /tmp/chef/cookbooks/fedora-box

RUN echo "environment_path '/tmp/chef/cookbooks/fedora-box/environments'" >> /etc/chef/client.rb
RUN more /etc/chef/client.rb

# Download and install the cookbook and its dependencies in the cookbook path:
RUN berks vendor -b /tmp/chef/cookbooks/fedora-box/Berksfile /tmp/chef/cookbooks

RUN ls -l /tmp/chef/cookbooks/

RUN chef-client --local-mode -c /etc/chef/client.rb -j /tmp/chef/cookbooks/fedora-box/attributes/docker.json

EXPOSE 8080 5432 61616

# The below starts whatever runs on this server and pipes out a relevant logfile.
CMD /tmp/start.sh
