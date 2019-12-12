FROM python:3.7.4-buster

MAINTAINER LSST SQuaRE <sqre-admin@lists.lsst.org>
LABEL description="Kubernetes operator that deploys the Confluent Schema Registry in a Strimzi-based Kafka cluster where TLS authentication and authorization is enabled." \
      name="lsstsqre/strimzi-registry-operator"

# Need the JRE for keytool
RUN apt-get update && apt-get install -y --no-install-recommends \
        default-jre \
    && rm -rf /var/lib/apt/lists/*

ENV APPDIR /app
RUN mkdir $APPDIR
WORKDIR $APPDIR

# Supply on CL as --build-arg VERSION=<version> (or run `make image`).
ARG VERSION
LABEL version="$VERSION"

# Must run python setup.py sdist first before building the Docker image.

COPY dist/strimzi-registry-operator-$VERSION.tar.gz .
COPY bin/run.sh .
RUN pip install strimzi-registry-operator-$VERSION.tar.gz && \
    rm strimzi-registry-operator-$VERSION.tar.gz && \
    chmod u+x $APPDIR/run.sh && \
    useradd -g root app && \
    chown -R app:root $APPDIR && \
    chmod g+w /etc/passwd

USER app

# TODO: refactor "namespace" argument into an environment variable for
# configurability.
CMD ["/app/run.sh"]
