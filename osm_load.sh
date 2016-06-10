#!/bin/sh

set -x

E_BADARGS=65



output_dir=${npm_package_config_output_dir:-"/tmp/omosis_output"}

echo "reading data from $output_dir"

ln -sf ${output_dir}/* ./binaries/osm/

SQITCH_DB_URI=${SQITCH_DB_URI:-`sqitch  config --local --get-regexp 'uri' 'pg' | cut -f 2 -d =`}

sqitch deploy --to-change pgsnapshot_load ${SQITCH_DB_URI}
