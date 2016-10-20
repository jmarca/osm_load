-- Revert osm_load:pgsnapshot_schema_linestring from pg

BEGIN;

SET search_path to osm,public;

drop index idx_ways_linestring;
alter table ways drop column linestring;

COMMIT;
