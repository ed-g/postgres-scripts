#!/bin/bash

dbname=YOUR_DB_HERE
date=$(date '+%Y-%m-%d')
my_dir=$(readlink -f $(dirname $0))/backups
output_file=$my_dir/pg-dump-gtfs-api-$date.sql.gz
clean_output_file=$my_dir/pg-dump-gtfs-api-danger-will-drop-then-restore-$date.sql.gz

if [ X$1 = X--clean ]; then
  echo "Dumping $dbname Postgres database (CLEAN) to $clean_output_file"
  pg_dump $dbname --create --clean | gzip > "$clean_output_file"
else
  echo "Dumping $dbname Postgres database to $output_file"
  pg_dump $dbname | gzip > $output_file
fi

