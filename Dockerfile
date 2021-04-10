FROM mariadb:10.4

# Supress debconf warnings
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update -qq && apt-get install -yqq \
    mariadb-plugin-spider \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# TODO: Fix the error caused by `apt-get install -yaqq mariadb-plugin-spider`
# ERROR 2002 (HY000): Can't connect to local MySQL server through socket ...

# Install Spider storage engine
RUN cp /usr/share/mysql/install_spider.sql docker-entrypoint-initdb.d/
