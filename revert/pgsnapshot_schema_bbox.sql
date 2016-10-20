-- Revert osm_load:pgsnapshot_schema_bbox from pg

BEGIN;

SET search_path to osm,public;

-- not sure what to do for a rollback here
-- seems if it fails, it is failed.

drop aggregate osm.first(anyelement);
drop function osm.first_agg(anyelement,anyelement);
drop index idx_ways_bbox;
alter table ways drop column bbox;


COMMIT;
