-- Verify osm_load:pgsnapshot_schema on pg

BEGIN;

-- make sure functions don't puke

SELECT pg_catalog.has_function_privilege('osm.osmosisUpdate()','execute');


-- users

select id, name
from osm.users
where false;

select 1/count(*)
from osm.users
;

-- nodes

select id, version, user_id, tstamp, changeset_id, hstore, geom
from osm.nodes
where false;

select 1/count(*)
from osm.nodes
;

-- ways

select id,version,user_id,tstamp,changeset_id,tags,nodes
from osm.ways
where false;

select 1/count(*)
from osm.ways
;

-- way_nodes

select wa_id,node_id,sequence_id
from osm.way_nodes
where false;

select 1/count(*)
from osm.way_nodes
;

-- relations

select id,version,user_id,tstamp,changeset_id,tags
from osm.relations
where false;

select 1/count(*)
from osm.relations
;

-- relation_members

select relation_id,member_id,member_type,member_role,sequence_id
from osm.relation_members
where false;

select 1/count(*)
from osm.relation_members
;

-- schema_info
select version
from osm.schema_info
where false;




ROLLBACK;
