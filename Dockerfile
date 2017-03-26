FROM python:3.6

# Install packages
RUN apt-get -yqq update && \
    apt-get -yqq install apache2 apache2-dev locales && \
    apt-get clean

# Install locale
COPY ./locale.gen /etc/locale.gen
RUN locale-gen

# Prepare virtualenv
RUN mkdir /app
WORKDIR /app
RUN python3.6 -m venv ./virtualenv
RUN ./virtualenv/bin/pip install --upgrade pip setuptools

# Install mod_wsgi
RUN ./virtualenv/bin/pip install mod_wsgi

# Remove development packages
RUN dpkg --purge apache2-dev
RUN apt-get autoremove -y

# Prepare app directory
RUN mkdir ./pylibs

# Configure Apache
COPY ./wsgi.conf /etc/apache2/mods-enabled/wsgi.conf
ONBUILD COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Start Apache
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
