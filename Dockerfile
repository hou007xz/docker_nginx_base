FROM nickhx/docker_ubuntu_base

# warning: apt-get install should run with apt-get update, if not, we'll find docker error code 100.
RUN apt-get update && \
    apt-get install -y nginx
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

#daemontools, auto start nginx process
RUN mkdir -p /etc/bootservices/nginx
RUN echo "#!/bin/bash\n exec /usr/sbin/nginx" > /etc/bootservices/nginx/run
RUN chmod +x /etc/bootservices/nginx/run

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/svscan", "/etc/bootservices/"]