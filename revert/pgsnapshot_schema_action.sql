-- Revert osm_load:pgsnapshot_schema_action from pg

BEGIN;

drop table osm.actions;

COMMIT;
