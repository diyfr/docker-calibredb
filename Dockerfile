# Use an Alpine linux base image with GNU libc (aka glibc) pre-installed, courtesy of Vlad Frolov
FROM frolvlad/alpine-glibc

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################
# Calibre environment variables
ENV \
	CALIBRE_LIBRARY_DIRECTORY=/opt/calibredb/library \
	CALIBRE_CONFIG_DIRECTORY=/opt/calibredb/config \
	CALIBREDB_IMPORT_DIRECTORY=/opt/calibredb/import \
	AUTO_UPDATE=0

#########################################
##         DEPENDENCY INSTALL          ##
#########################################
RUN apk update && \
    apk add --no-cache --upgrade \
    bash \
    ca-certificates \
    python3 \
    wget \
    gcc \
    mesa-gl \
    imagemagick \
    qt5-qtbase-x11 \
    xdg-utils \
    xz && \
    update-ca-certificates 2>/dev/null || true && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    pip install --no-cache --upgrade pip setuptools wheel
#########################################
##            APP INSTALL              ##
#########################################

RUN wget -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
    rm -rf /tmp/calibre-installer-cache

#########################################
##            Script Setup             ##
#########################################
ADD run_auto_importer.sh /usr/bin/run_auto_importer.sh
RUN chmod a+x /usr/bin/run_auto_importer.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################
VOLUME /opt/calibredb/config
VOLUME /opt/calibredb/import
VOLUME /opt/calibredb/library

#########################################
##           Startup Command           ##
#########################################
CMD /usr/bin/run_auto_importer.sh
