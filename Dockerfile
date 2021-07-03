ARG  IMAGE_TAG
FROM mariadb:$IMAGE_TAG

# This duplication is intentional. See "Understand how ARG and FROM interact".
ARG  IMAGE_TAG

# Suppress debconf warnings
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && apt-get install -y \
    mariadb-plugin-spider \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# TODO: Fix the error caused by `apt-get install -yaqq mariadb-plugin-spider`
# ERROR 2002 (HY000): Can't connect to local MySQL server through socket ...

# Install Spider storage engine (only needed for < 10.5)
RUN if [ "$IMAGE_TAG" \< "10.5" ]; then \
        cp /usr/share/mysql/install_spider.sql docker-entrypoint-initdb.d/; \
    fi

# Register data nodes
COPY create_server.sql docker-entrypoint-initdb.d/
