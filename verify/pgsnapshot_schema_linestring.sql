-- Verify osm_load:pgsnapshot_schema_linestring on pg

BEGIN;

select id,version,user_id,tstamp,changeset_id,tags,nodes,bbox,linestring
from osm.ways
where false;


ROLLBACK;
