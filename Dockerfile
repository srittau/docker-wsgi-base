FROM debian:jessie

# Install packages
RUN apt-get -yqq update && \
    apt-get -yqq install apache2 python3.4 python3.4-venv \
        libapache2-mod-wsgi-py3 \
        locales && \
    apt-get clean

# Install locale
COPY locale.gen /etc/locale.gen
RUN locale-gen

# Copy startup script
COPY start-apache.sh /root/

# Configure Apache
ONBUILD COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Prepare virtualenv
RUN mkdir /app
WORKDIR /app
RUN python3.4 -m venv ./virtualenv
RUN ./virtualenv/bin/pip install --upgrade pip setuptools
ONBUILD ADD requirements.txt /app

# Install app
RUN mkdir ./pylibs

# Start Apache
EXPOSE 80
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/root/start-apache.sh"]
