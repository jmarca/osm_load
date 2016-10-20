-- Revert osm_load:appschema from pg

BEGIN;

DROP schema osm cascade;

COMMIT;
