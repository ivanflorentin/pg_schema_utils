## Basic implementation of Postgres internal catalogs 
## https://www.postgresql.org/docs/11/catalogs.html

type
  PG_class* = ref object
    ## https://www.postgresql.org/docs/11/catalog-pg-class.html
    oid*: int32
    relname*: string
    relnamespace*: int32
    reltype*: int32
    reloftype*: int32
    relowner*: int32
    relam*: int32
    relfilenode*: int32
    reltablespace*: int32
    relpages*: int
    reltuples*: float64
    relallvisible*: int 
    reltoastrelid*: int32
    relhasindex*: bool
    relisshared*: bool 
    relpersistence*: char
    relkind*: char
    relnatts*: int
    relchecks*: int
    relhasoids*: bool
    relhasrules*: bool
    relhastriggers*: bool
    relhassubclass*: bool
    relrowsecurity*: bool
    relforcerowsecurity*: bool
    relispopulated*: bool
    relreplident*: char 
    relispartition*: bool
    relrewrite*: int32
    relfrozenxid*: int32
    relminmxid*: int32
    relacl*: seq[string]
    reloptions*: seq[string]

  PG_type* = ref object
    ## https://www.postgresql.org/docs/11/catalog-pg-type.html
    oid*: int32 
    typname*: string
    typnamespace*: int32
    typowner*: int32
    typlen*: int
    typbyval*: bool
    typtype*: char
    typcategory*: char
    typispreferred*: bool
    typisdefined*: bool
    typdelim*: char
    typrelid*: int32
    typelem*: int32
    typarray*: int32
    typinput*: int32
    typoutput*: int32
    typreceive*: int32
    typsend*: int32
    typmodin*: int32
    typmodout*: int32
    typanalyze*: int32
    typalign*: char
    typnotnull*: bool
    typbasetype*: int32
    typtypmod*: int
    typndims*: int
    typcollation*: int32
    typdefaultbin*: string
    typdefault*: string
    typacl*: seq[string]

  PG_constraint* = ref object
    ## https://www.postgresql.org/docs/11/catalog-pg-constraint.html
    oid*: int32
    conname*: string
    connamespace*: int32
    contype*: char
    condeferrable*: bool
    condeferred*: bool
    convalidated*: bool
    conrelid*: int32
    contypid*: int32
    conindid*: int32
    conparentid*: int32
    confrelid*: int32
    confupdtype*: char
    confdeltype*: char
    confmatchtype*: char
    conislocal*: bool
    coninhcount*: int
    connoinherit*: bool
    conkey*: int
    confkey*: int
    conpfeqop*: seq[int32]
    conppeqop*: seq[int32]
    conffeqop*: seq[int32]
    conexclop*: seq[int32]
    conbin*: string
    consrc*: string

  PG_column* = ref object
    ## From information_schema
    ## https://www.postgresql.org/docs/current/infoschema-columns.html
    table_catalog*: string
    table_schema*: string
    table_name*: string
    column_name*: string
    ordinal_position*: int
    column_default*: string
    is_nullable*: string
    data_type*: string
    character_maximum_length*: int
    character_octet_length*: int 
    numeric_precision*: int
    numeric_precision_radix*: int 
    numeric_scale*: int 
    datetime_precision*: int 
    interval_type*: string
    interval_precision*: int
    character_set_catalog*: string
    character_set_schema*: string
    character_set_name*: string
    collation_catalog*: string
    collation_schema*: string
    collation_name*: string
    domain_catalog*: string
    domain_schema*: string
    domain_name*: string
    udt_catalog*: string
    udt_schema*: string
    udt_name*: string
    scope_catalog*: string
    scope_schema*: string 
    scope_name*: string
    maximum_cardinality*: int
    dtd_identifier*: string
    is_self_referencing*: string 
    is_identity*: string
    identity_generation*: string
    identity_start*: string
    identity_increment*: string
    identity_maximum*: string
    identity_minimum*: string
    identity_cycle*: string
    is_generated*: string
    generation_expression*: string
    is_updatable*: string

  PG_table* = ref object
    ## https://www.postgresql.org/docs/current/infoschema-tables.html
    oid*: int32 #this field is extracted from pg_class
    table_catalog*: string
    table_schema*: string
    table_name*: string
    table_type*: string
    self_referencing_column_name*: string
    reference_generation*: string
    user_defined_type_catalog*: string
    user_defined_type_schema*: string
    user_defined_type_name*: string
    is_insertable_into*: string
    is_typed*: string
    commit_action*: string


  Column_Comment* = ref object
    table_name*: string
    column_name*: string
    comment*: string

  Table_Comment* = ref object
    table_name*: string
    comment*: string

