#!/bin/sh
/opt/calibre/calibredb add $CALIBREDB_IMPORT_DIRECTORY -r --with-library $CALIBRE_LIBRARY_DIRECTORY && rm $CALIBREDB_IMPORT_DIRECTORY/* >> /var/log/cron.log 2>&1