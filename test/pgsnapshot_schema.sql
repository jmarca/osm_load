SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
-- SELECT plan(1);

SELECT pass('Test pgsnapshot_schema!');

SELECT is(
    (SELECT version
          FROM osm.schema_info
    )::integer,
    6,
    'The version is properly set'
);

SELECT finish();
ROLLBACK;
