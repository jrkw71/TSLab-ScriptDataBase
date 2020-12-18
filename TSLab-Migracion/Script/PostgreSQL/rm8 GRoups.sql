SELECT 
    rs1.id
    , rs1.name
    , rs1.parent_id
    , rs1.name_path
    , rs1.level 
    , CASE 
      WHEN rs1.name_path LIKE '%STOCK%' THEN 'STOCK'
      WHEN rs1.name_path LIKE '%DEMO%' THEN 'DEMO'
      WHEN rs1.name_path LIKE '%WEBSTREAMING%' THEN 'WEBSTREAMING'
      WHEN rs1.name_path LIKE '%OFICINA%' THEN 'OFICINA'
      WHEN rs1.name_path LIKE '%NESPRESSO>%' THEN 'NESPRESSO'
      WHEN rs1.name_path LIKE '%NH>%' THEN 'NH>'
      WHEN rs1.name_path LIKE '%BONAREA (CUÑAS)>%' THEN 'BON AREA'
      WHEN rs1.name_path LIKE '%MUSICAM - THE BLOOP (PROVE.ECUADOR)>%' THEN 'THE BLOOP (ECUADOR)'
      WHEN rs1.name_path LIKE '%MUSICAM - COINDAGRO S.A.S%' THEN 'COINDAGRO (COLOMBIA)'
      WHEN rs1.name_path LIKE '%PARADORES>%' THEN 'PARADORES'
      WHEN rs1.name_path LIKE '%MUSICAM>%' THEN 'GENERICO'
      WHEN rs1.name_path LIKE '%THE SENSORY LAB - MEXICO>%' THEN 'TSLAB MEXICO'
      ELSE 'OTROS'
      END AS GrupoEstadistica
    , CASE
      WHEN rs1.name_path LIKE '%>SALSA JEANS%' THEN 'SALSA JEANS'
      WHEN rs1.name_path LIKE '%BURGER KING (%' THEN 'BURGER KING'
      WHEN rs1.name_path LIKE '%GRUPO CORTEFIEL>%' THEN 'GRUPO CORTEFIEL FRANQUISIA'
      WHEN rs1.name_path LIKE '%CARREFOUR>%' THEN 'CARREFOUR'
      WHEN rs1.name_path LIKE '%PUNT ROMA %' THEN 'PUNT ROMA'
      WHEN rs1.name_path LIKE '%CONFORAMA %' THEN 'CONFORAMA'
      WHEN rs1.name_path LIKE '%DOUGLAS>%' THEN 'DOUGLAS'
      WHEN rs1.name_path LIKE '%KFC %' THEN 'KFC'
      WHEN rs1.name_path LIKE '%MEDIA MARKT %' THEN 'MEDIA MARKT'
      WHEN rs1.name_path LIKE '%GRUPO JAVIER SIMORRA>%' THEN 'SIMORRA'
      WHEN rs1.name_path LIKE '%GRUPO JAVIER GRUPO OTER %' THEN 'GRUPO OTER'
      ELSE 'PEQUEÑAS'
      END AS GrandesCuentas
    , CASE
      WHEN rs1.name_path LIKE '%>SALSA JEANS%' THEN 'SALSA JEANS'
      WHEN rs1.name_path LIKE '%BURGER KING%' THEN 'BURGER KING'
      WHEN rs1.name_path LIKE '%GRUPO CORTEFIEL>%' THEN 'GRUPO CORTEFIEL FRANQUISIA'
      WHEN rs1.name_path LIKE '%>CARREFOUR%' THEN 'CARREFOUR'
      WHEN rs1.name_path LIKE '%PUNT ROMA %' THEN 'PUNT ROMA'
      WHEN rs1.name_path LIKE '%CONFORAMA %' THEN 'CONFORAMA'
      WHEN rs1.name_path LIKE '%>DOUGLAS%' THEN 'DOUGLAS'
      WHEN rs1.name_path LIKE '%KFC%' THEN 'KFC'
      WHEN rs1.name_path LIKE '%MEDIA MARKT %' THEN 'MEDIA MARKT'
      WHEN rs1.name_path LIKE '%GRUPO JAVIER SIMORRA>%' THEN 'SIMORRA'
      WHEN rs1.name_path LIKE '%GRUPO JAVIER GRUPO OTER %' THEN 'GRUPO OTER'
      WHEN rs1.name_path LIKE '%CLAIRES ESPAÑA>%' THEN 'CLAIRES ESPAÑA'
      WHEN rs1.name_path LIKE '%>ORANGE%' THEN 'ORANGE'
      WHEN rs1.name_path LIKE '%>HESPERIA%' THEN 'HESPERIA'
      WHEN rs1.name_path LIKE '%- BASHA%' THEN 'BASHA MEXICO'
      WHEN rs1.name_path LIKE '%MUSICAM OFICINA>%' THEN 'MUSICAM OFICINA'
      WHEN rs1.name_path LIKE '%MUSICAM DEMO>%' THEN 'MUSICAM DEMO'
      WHEN rs1.name_path LIKE '%>PELUQUERIA%' THEN 'PELUQUERIAS'
      WHEN rs1.name_path LIKE '%>SUPERMERCADOS%' THEN 'SUPERMERCADOS'
      WHEN rs1.name_path LIKE '%>ZT HOTELS>%' THEN 'ZT HOTELS'
      WHEN rs1.name_path LIKE '%>ULLOA ÓPTICO%' THEN 'ULLOA ÓPTICO'
      WHEN rs1.name_path LIKE '%>TONY ROMAS>%' THEN 'TONY ROMAS'
      WHEN rs1.name_path LIKE '%>TOMMY MEL%' THEN 'TOMMY MEL''S'
      WHEN rs1.name_path LIKE '%>THE STYLE OUTLETS>%' THEN 'THE STYLE OUTLETS'
      WHEN rs1.name_path LIKE '%>PURO EGO%' THEN 'PURO EGO'
      WHEN rs1.name_path LIKE '%>PASTELERIA>%' THEN 'PASTELERIAS'
      WHEN rs1.name_path LIKE '%>BOTTICELLI%' THEN 'BOTTICELLI'
      WHEN rs1.name_path LIKE '%>NH%' THEN 'NH'
      WHEN rs1.name_path LIKE '%>BONAREA (CUÑAS)%' THEN 'BON AREA'
      WHEN rs1.name_path LIKE '%>LLAOLLAO%' THEN 'LLAOLLAO'
      WHEN rs1.name_path LIKE '%>DREAMFIT%' THEN 'DREAMFIT'
      WHEN rs1.name_path LIKE '%DESNUDOS>%' THEN 'DESNUDOS'
      WHEN rs1.name_path LIKE '%>NESPRESSO%' THEN 'NESPRESSO'
      WHEN rs1.name_path LIKE '%FARMACIA%' THEN 'FARMACIAS'
      WHEN rs1.name_path LIKE '%HOTEL%' THEN 'HOTELES'
      WHEN rs1.name_path LIKE '%>RESTAURANTE%' THEN 'RESTAURANTES'
      WHEN rs1.name_path LIKE '%>GIMNASI%' THEN 'GIMNASIOS'

    
      ELSE 'OTRAS CUENTAS'
      END AS Cuentas
  FROM (
    SELECT 
      rs.id
      , rs.name
      , rs.parent_id
      , UPPER(rs.name_path) AS name_path
      , rs.level
    FROM (
      WITH RECURSIVE subordinates_groups (id, level, parent_id, name, name_path) AS (
            SELECT  
              id
              , 0
              , parent_id
              , name 
              , ARRAY[name]
            FROM groups  
           UNION
            SELECT
              g.id
              , s.level + 1
              , g.parent_id
              , g.name 
              , ARRAY_APPEND(s.name_path, g.name)
            FROM groups g
              INNER JOIN subordinates_groups s ON s.id = g.parent_id
        ) 
        SELECT 
          id
          , level
          , parent_id
          , name
          , ARRAY_TO_STRING(name_path, '>') AS name_path
        FROM
          subordinates_groups
    ) rs
  ) rs1 INNER JOIN (    
    SELECT 
      rs.id
      ,MAX(rs.level) AS level
    FROM (
      WITH RECURSIVE subordinates_groups (id, level, parent_id, name, name_path) AS (
            SELECT  
              id
              ,0
              ,parent_id
              ,name 
              ,ARRAY[name]
            FROM groups  
           UNION
            SELECT
              g.id
              ,s.level + 1
              ,g.parent_id
              ,g.name 
              ,ARRAY_APPEND(s.name_path, g.name)
            FROM groups g
              INNER JOIN subordinates_groups s ON s.id = g.parent_id
        ) 
        SELECT 
          id
          ,level
          ,parent_id
          ,name
          ,ARRAY_TO_STRING(name_path, '>') AS name_path
        FROM
          subordinates_groups
    ) rs
    GROUP BY 
      rs.id
  ) rs2  ON rs1.id = rs2.id AND rs1.level = rs2.level
;