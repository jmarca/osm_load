-- Verify osm_load:pgsnapshot_schema_action on pg

BEGIN;

-- actions
select data_type,action,id
from osm.actions
where false;


ROLLBACK;
