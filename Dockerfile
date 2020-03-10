FROM postgres:latest
COPY init.sql /docker-entrypoint-initdb.d/
# Disable checking for known_hosts (maybe not working)
RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config
