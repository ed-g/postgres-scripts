#!/bin/bash
# sanity check restore from pg_dump files
# Ed Groth 2015-05-08

if (( $# < 1 )) ; then
  echo 'Usage: restore-from-sql.sh file-to-restore-from.sql [--drop-ok]'
  exit 1;
else
  file=$1
  option=$2
fi

function find_unzip_command_for_file () {
  unzip_command=cat
  # echo "find_unzip_command_for_file arg: $1"
  if [[ $1 =~ \.gz$ ]]; then
    echo 'Found gzip file.';
    unzip_command=gunzip
  elif [[ $1 =~ \.bz2$ ]]; then
    echo 'Found bzip2 file.';
    unzip_command=bunzip2
  elif [[ $1 =~ \.lz$ ]]; then
    echo 'Found lzip file.';
    unzip_command=lunzip
  elif [[ $1 =~ \.sql$ ]]; then
    echo 'Found SQL file.';
    unzip_command=cat
  else
    echo 'Cannot determine file type, assuming it is SQL.';
    unzip_command=/bin/cat
  fi
}

find_unzip_command_for_file $file

drop_found=$($unzip_command < $file |grep "^DROP" |head -1)

if [[ $option != "--drop-ok" && $drop_found =~ ^DROP ]]; then
  echo "WARNING: this sql file wil DROP you tables! Are you cool with that???"
  echo "If so, please use 'restore-from-sql.sh $file --drop-ok'"
  exit 2;
fi

echo "Restoring Postgres from file $file"
$unzip_command < $file |psql --file -

echo "Vacuuming databases and building new statistics."
vacuumdb --all --analyze
