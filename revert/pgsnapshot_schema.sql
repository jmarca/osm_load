-- Revert osm_load:pgsnapshot_schema from pg

BEGIN;

SET search_path to osm,public;

drop function osmosisUpdate();
drop function unnest_bbox_way_nodes();
drop table relation_members cascade;
drop table relations cascade;
drop table way_nodes cascade;
drop table ways cascade;
drop table nodes cascade;
drop table users cascade;
drop table schema_info cascade;


COMMIT;
