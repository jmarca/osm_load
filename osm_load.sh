#!/bin/sh

set -x

E_BADARGS=65



osmosis_binary=${npm_package_config_osmosis_binary:-"/usr/bin/osmosis"}
output_dir=${npm_package_config_output_dir:-"/tmp/omosis_output"}

if [ ! -d $output_dir ]
then mkdir -p $output_dir;
fi


echo $osmosis_binary $output_dir $JAVACMD_OPTIONS

old_options=${JAVACMD_OPTIONS}
JAVACMD_OPTIONS=${JAVACMD_OPTIONS:-"-Xmx10G -Djava.io.tmpdir=$output_dir"}
export JAVACMD_OPTIONS=$JAVACMD_OPTIONS


$osmosis_binary  -v 100 \
                 --read-pbf \
                 file=./binaries/osm/california-latest.osm.pbf \
                 --buffer bufferCapacity=10000  \
                   --write-pgsql-dump-0.6 directory=$output_dir \
                 enableBboxBuilder=true \
                 enableLinestringBuilder=true \
                 nodeLocationStoreType=CompactTempFile

JAVACMD_OPTIONS=$old_options
export JAVACMD_OPTIONS=$JAVACMD_OPTIONS
