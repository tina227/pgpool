FROM centos:8

ENV PG_VER 13
ENV PGPOOL_VER 4.2
ENV PGPOOL_CONF_DIR /etc/pgpool-II
ENV PGPOOLCONF ${PGPOOL_CONF_DIR}/pgpool.conf
ENV POOL_HBA_CONF ${PGPOOL_CONF_DIR}/pool_hba.conf
ENV PCP_CONF ${PGPOOL_CONF_DIR}/pcp.conf
ENV PGPOOL_BINARY_DIR /usr/bin
ENV PGPOOL_SERVICE_PORT 9999

RUN dnf update -y
#RUN yum install -y dnf-plugin-ovl sudo vim iproute openssh openssh-server openssh-clients net-tools
RUN dnf install -y sudo vim iproute openssh openssh-server openssh-clients net-tools
RUN dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN dnf -qy module disable postgresql
RUN dnf install -y postgresql${PG_VER}-server
RUN dnf install -y http://www.pgpool.net/yum/rpms/${PGPOOL_VER}/redhat/rhel-8-x86_64/pgpool-II-release-${PGPOOL_VER}-1.noarch.rpm
RUN dnf install -y pgpool-II-pg${PG_VER} pgpool-II-pg${PG_VER}-extensions

RUN echo 'root:root' | chpasswd

RUN cp -p ${PGPOOL_CONF_DIR}/pgpool.conf.sample-stream ${PGPOOLCONF}

COPY start.sh /tmp

ENTRYPOINT ["/tmp/start.sh"]

EXPOSE ${PGPOOL_SERVICE_PORT}

