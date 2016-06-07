# OSM load

A repository holding my method for loading California OpenStreetMap
(OSM) data into a database via the program osmosis.

Using osmosis is required because all my geometry code expects those
tables to be there.

# Get a pbf file

In order to download the latest pbf file for california, run the npm
run script called build

```
npm run build
```

If that works, then it will download the latest california snapshot
from the excellent geofabrik.de OSM server.

If it appears to do nothing, it could be the case that you already
have a recent file.  It will only download a new file if the current
one is older than 30 days old.

Alternately, you can manually download the file by running:

```
curl \
http://download.geofabrik.de/north-america/us/california-latest.osm.pbf \
-o binaries/osm/california-latest.osm.pbf
```

# Nota Bene: Don't use ogr2ogr

Don't use ogr2ogr.  Well, you can use it, but it doesn't make all of
the tables that I need.

If you insist, then you can use ogr2ogr, by doing something like:

```
ogr2ogr -f PostgreSQL PG:'dbname=hpms_geocode user=${PG_USER}' \
        -overwrite --oo MAX_TMPFILE_SIZE=1000 california-latest.osm.pbf \
        -lco COLUMN_TYPES=other_tags=hstore PG_USE_COPY=YES SCHEMA=osm
```

# Use Osmosis


Download osmosis and install it.  That is beyond the scope of this
write up.

## Create a db

```
export PSQL_USER='your user name'
export OSMOSIS_DIR='/path/to/osmosis/dir'
createdb -U ${PSQL_USER} osm
```

## Configure sqitch

This project and its dependencies use sqitch.

Configure sqitch as follows.  Note that you may have to specify a full
db URI as described [here](https://github.com/theory/uri-db/):

```
sqitch target add osm db:pg:osm
sqitch engine add pg osmt
```

Then export the local sqitch file for use in dependencies:


```
export SQITCH_CONFIG=~+/sqitch.conf
```

## Geo stuff

Then use sqitch to add the geo stuff.


```
npm install calvad_db_geoextensions

```

## Deploy Osmosis

Then load up the databse rules and regs.  This can now be done using
sqitch via npm run scripts.

```
npm deploy:schema
```


That takes the place of the following:

```

psql -U ${PSQL_USER} osm

create schema osm;
SET search_path TO osm,public;
\i /home/james/repos/OSM_related/osmosis/package/script/pgsnapshot_schema_0.6.sql
\i /home/james/repos/OSM_related/osmosis/package/script/pgsnapshot_schema_0.6_action.sql
\i /home/james/repos/OSM_related/osmosis/package/script/pgsnapshot_schema_0.6_bbox.sql
\i /home/james/repos/OSM_related/osmosis/package/script/pgsnapshot_schema_0.6_linestring.sql
```


## Parse and process the OSM snapshot with osmosis

Next parse the osm.pbf file

I like to use a directory with lots of space to store temp files and
such.

The output directory is set with the package.json file variable
npm_package_config_output_dir: or else will default to
"/tmp/omosis_output".

```
npm run load:osmosis
```

That will download the OSM California snapshot if necessary, and then
process the pbf file using osmosis to make a series of PostgreSQL copy
statements to load the data.


```

export JAVACMD_OPTIONS="-Xmx2G -Djava.io.tmpdir=/var/tmp/osmosis_data"
export OSMOSIS_DATA=/var/tmp/osmosis_data

/home/james/bin/osmosis \
      -v 100 \
  --read-pbf file=${OSMOSIS_FILE} \
      --buffer bufferCapacity=10000 \
  --write-pgsql-dump-0.6 directory=${OSMOSIS_DATA} \
  			    enableBboxBuilder=true \
 		    enableLinestringBuilder=true \
 		    nodeLocationStoreType=CompactTempFile
```

You will see a lot of dumping output, and then a big pause after the
message

```
FINE: Waiting for task 1-read-pbf to complete.
```

The osmosis run will crash if you don't have enough space on your
drive.  I had 7GB and it crashed, so I upped it to 50GB and it worked
okay.  Your mileage may vary.

Have another cup of coffee.  Go for a bike ride.

## Load OSM data into postgresql

Once the OSM pbf file has been broken into sql statements, you can
then read it into your prepared database.

Load the data into your osm database using a modified version of the
script provided in the `sql` directory of this repo.

```
export CWD=`pwd`
cd ${OSMOSIS_DATA}  # the directory with the dump files
psql -U ${PSQL_USER} osm -f ${CWD}/sql/pgsnapshot_load_0.6.sql
```

This takes a while, but if all goes well you should have an OSM dataset
consistent with whatever the date was from the original download.

## Clean up

Finally get rid of the temporary files in the ${OSMOSIS_DATA}
directory.

# Prepping OSM for VDS work

Now you can run the sqitch code to deploy the scripts to set up for
segmentizing the VDS and WIM sites.
