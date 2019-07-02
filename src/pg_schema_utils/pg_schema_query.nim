import
  db_postgres
  pgschema
  parseutils
  strformat

template tooid(s: string): int32 =
  var id: int
  discard parseInt(s, id)
  int32(id)

proc get_pgclass*(conn: DBConn, relname: string): PG_class =
  # select * from pg_catalog.pg_class where relname = ? ;
  let rows = conn.getAllRows(sql"""SELECT oid
        FROM pg_catalog.pg_class WHERE relname = ?""", relname)
  result = PG_class()
  var oid: int
  oid = parseInt(rows[0][0], oid)
  echo oid
  result.oid = int32(oid)
  result.relname = rows[0][1]

proc get_pgtables*(conn: DBConn, schema: string = "public"): seq[PG_table] =
  #select * from information_schema.tables where table_schema = 'public';
  result = @[]
  let rows = conn.getAllRows(sql(fmt"""SELECT * FROM information_schema.tables 
                                    WHERE table_schema = '{schema}'"""))
  for r in rows:
    var t = PG_table()
    t.table_catalog = r[0]
    t.table_schema = r[1]
    t.table_name = r[2]
    t.table_type = r[3]
    t.is_insertable_into = r[9]
    t.is_typed = r[10]
    let classes = conn.getAllRows(sql"""SELECT oid
        FROM pg_catalog.pg_class WHERE relname = ?""", t.table_name)
    t.oid = tooid(classes[0][0])
    result.add(t)
    
  
  
proc get_pgcolumns*(conn: DBConn, schema: string = "public",
                    table: string = "*"): seq[PG_column] =
  #select * from information_schema.columns where table_schema = 'public';
  var stat = fmt"""SELECT * FROM information_schema.columns 
               WHERE table_schema = '{schema}' """
  if table != "*":
    stat = stat & fmt" AND table_name = '{table}'"
  result = @[]
  let rows = conn.getAllRows(sql stat)
  for r in rows:
    #echo r
    var l: int
    var c = PG_column()
    c.table_catalog = r[0]
    c.table_schema = r[1]
    c.table_name = r[2]
    c.column_name = r[3]
    discard parseint(r[4], c.ordinal_position)
    c.column_default = r[5]
    c.is_nullable = r[6]
    c. data_type = r[7]
    discard parseInt(r[8], c.character_maximum_length)
    discard parseInt(r[9], c.character_octet_length)
    discard parseInt(r[10], c.numeric_precision)
    discard parseInt(r[11], c.numeric_precision_radix)
    discard parseInt(r[12], c.numeric_scale)
    discard parseInt(r[13], c.datetime_precision)
    c.interval_type = r[14]
    discard parseInt(r[15], c.interval_precision)    
    result.add(c)
   
proc get_pgconstraints*(conn: DBConn, toid:
                        int32, ct: char = '*'):
                          seq[PG_constraint] =
  result = @[]
  var contype = 'f'
  if ct == '*':
    contype = 'f'
  var stmnt = fmt """ SELECT 
             conname, conrelid, confrelid, 
             conkey, confkey, contype
             FROM   pg_catalog.pg_constraint 
             WHERE conrelid = {toid} """
  if ct != '*':
    stmnt = fmt"""{stmnt} AND contype = '{ct}' """
  let rows = conn.getAllRows(sql stmnt)
  for r in rows:
    var c = PG_constraint()
    c.conname = r[0]
    c.conrelid = tooid(r[1])
    c.confrelid = tooid(r[2])
    c.contype = r[5][0]
    var col:int
    discard parseInt($r[3][1], c.conkey)
    if c.contype == 'f':
       discard parseInt($r[4][1], c.confkey)
    #for i in r[3]:
      #echo $i[1] #r[3]
      #parseInt($i[1], col)
      #c.conkey.add(col)
    #for i in r[4]:
      #echo r[4]
      #parseInt(string(i), col)
      #c.confkey.add(col)  
    result.add(c)


proc get_column_comments*(conn: DBConn): seq[Column_Comment] =
  let query = """
     SELECT cols.table_name, cols.column_name, (
        SELECT
            pg_catalog.col_description(c.oid, cols.ordinal_position::int)
            FROM pg_catalog.pg_class c
            WHERE  c.oid = (SELECT cols.table_name::regclass::oid) AND
               c.relname = cols.table_name) as column_comment
         FROM information_schema.columns cols
         WHERE
           cols.table_catalog = current_database() AND
           cols.table_schema  = current_schema() """
  result = @[]
  let rows = conn.getAllRows(sql query)
  for r in rows:
    var com = Column_Comment()
    com.table_name = $r[0]
    com.column_name = $r[1]
    com.comment = $r[2]
    result.add(com)

proc get_table_comments*(conn: DBConn): seq[Table_Comment] =
  let query = """SELECT t. relname, obj_description(t.oid) FROM (
       SELECT relname, oid FROM pg_catalog.pg_class
         WHERE relname IN (
           SELECT table_name FROM information_schema.tables
            WHERE table_schema = current_schema() 
               AND table_catalog = current_database() ) ) t """
  result = @[]
  let rows = conn.getAllRows(sql query)
  for r in rows:
    var com = Table_Comment()
    com.table_name = $r[0]
    com.comment = $r[1]
    result.add(com)
