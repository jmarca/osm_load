-- Verify osm_load:pgsnapshot_schema_bbox on pg

BEGIN;

-- ways

select id,version,user_id,tstamp,changeset_id,tags,nodes,bbox
from osm.ways
where false;

SELECT pg_catalog.has_function_privilege('osm.first_agg(anyelement,anyelement)','execute');

SELECT pg_catalog.has_function_privilege('osm.first(anyelement)','execute');


ROLLBACK;
