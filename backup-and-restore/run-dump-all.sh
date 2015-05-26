#!/bin/bash

date=$(date '+%Y-%m-%d')
my_dir=$(readlink -f $(dirname $0))/backups
# output_file=$my_dir/pg-dumpall-$date.sql.bz2
output_file=$my_dir/pg-dumpall-$date.sql.gz
clean_output_file=$my_dir/pg-dumpall-danger-will-drop-then-restore-$date.sql.gz

if [ X$1 = X--clean ]; then
  echo "Dumping all Postgres databases (CLEAN) to $clean_output_file"
  pg_dumpall --clean | gzip > "$clean_output_file"
else
  echo "Dumping all Postgres databases to $output_file"
  pg_dumpall | gzip > $output_file
fi

