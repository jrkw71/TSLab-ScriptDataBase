SELECT 
  ROW_NUMBER() OVER() AS Registro   -- Conteo Global de Datos
  , ROW_NUMBER() OVER(PARTITION BY rs.GroupCuenta) AS RM8 -- Conteo de RM8 por Clientes
  , rs.GroupCuenta AS Cliente  -- Cliente 
  , COUNT(DISTINCT rs.ChannelName) AS Canales -- Canales configurados RM8
FROM (

SELECT 
  dev.serial_number
  ,chn.name AS ChannelName
  ,dev.GroupName
  ,dev.GroupId
  ,dev.GroupCuenta
  ,dev.GroupNamePath
  ,dev.GroupEstadistica
FROM public.channels_in_devices chd
  INNER JOIN LATERAL (
      SELECT 
        dev.last_modification
        ,dev.last_seen
        ,dev.hw_model
        ,dev.sw_version
        ,dev.serial_number
        ,sta.number_of_channels
        ,sta.date
        ,sta.activity
        ,sts.name AS StateName
        ,grp.name AS GroupName
        ,grp.id AS GroupId
        ,grp.Cuentas AS GroupCuenta
        ,grp.name_path AS GroupNamePath
        ,grp.GrupoEstadistica AS GroupEstadistica
        ,sts.id AS StateId
      FROM public.devices dev
      INNER JOIN LATERAL (
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
              WHEN rs1.name_path LIKE '%NH>%' THEN 'NH'
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
              --WHEN rs1.name_path LIKE '%>PELUQUERIA%' THEN 'PELUQUERIAS'
              --WHEN rs1.name_path LIKE '%>SUPERMERCADOS%' THEN 'SUPERMERCADOS'
              WHEN rs1.name_path LIKE '%>ZT HOTELS>%' THEN 'ZT HOTELS'
              WHEN rs1.name_path LIKE '%>ULLOA ÓPTICO%' THEN 'ULLOA ÓPTICO'
              WHEN rs1.name_path LIKE '%>TONY ROMAS>%' THEN 'TONY ROMAS'
              WHEN rs1.name_path LIKE '%>TOMMY MEL%' THEN 'TOMMY MEL''S'
              WHEN rs1.name_path LIKE '%>THE STYLE OUTLETS>%' THEN 'THE STYLE OUTLETS'
              WHEN rs1.name_path LIKE '%>PURO EGO%' THEN 'PURO EGO'
              --WHEN rs1.name_path LIKE '%>PASTELERIA>%' THEN 'PASTELERIAS'
              WHEN rs1.name_path LIKE '%>BOTTICELLI%' THEN 'BOTTICELLI'
              WHEN rs1.name_path LIKE '%>NH%' THEN 'NH'
              WHEN rs1.name_path LIKE '%>BONAREA (CUÑAS)%' THEN 'BON AREA'
              WHEN rs1.name_path LIKE '%>LLAOLLAO%' THEN 'LLAOLLAO'
              WHEN rs1.name_path LIKE '%>DREAMFIT%' THEN 'DREAMFIT'
              WHEN rs1.name_path LIKE '%DESNUDOS>%' THEN 'DESNUDOS'
              WHEN rs1.name_path LIKE '%>NESPRESSO%' THEN 'NESPRESSO'
              --WHEN rs1.name_path LIKE '%FARMACIA%' THEN 'FARMACIAS'
              --WHEN rs1.name_path LIKE '%HOTEL%' THEN 'HOTELES'
              --WHEN rs1.name_path LIKE '%>RESTAURANTE%' THEN 'RESTAURANTES'
              --WHEN rs1.name_path LIKE '%>GIMNASI%' THEN 'GIMNASIOS'
              WHEN rs1.name_path LIKE '%>ALDI%' THEN 'ALDI'
              WHEN rs1.name_path LIKE '%>ALIMENTACIÓN LOS MARES%' THEN 'ALIMENTACIÓN LOS MARES'
              WHEN rs1.name_path LIKE '%>ASADOR DE ARANDA%' THEN 'ASADOR DE ARANDA'
              WHEN rs1.name_path LIKE '%>BE ONE (%' THEN 'BE ONE'
              WHEN rs1.name_path LIKE '%BMW%' THEN 'BMW'
              WHEN rs1.name_path LIKE '%BOUTIQUE POETE%' THEN 'BOUTIQUE POETE'
              WHEN rs1.name_path LIKE '%BRICORAMA%' THEN 'BRICORAMA'
              WHEN rs1.name_path LIKE '%BUFALLO GRILL%' THEN 'BUFALLO GRILL'
              WHEN rs1.name_path LIKE '%CAIXA POPULAR%' THEN 'CAIXA POPULAR'
              WHEN rs1.name_path LIKE '%CALZADOS GAYPER%' THEN 'CALZADOS GAYPER'
              WHEN rs1.name_path LIKE '%CALZEDONIA FRANQUICIA ALGECIRAS%' THEN 'CALZEDONIA FRANQUICIA ALGECIRAS'
              WHEN rs1.name_path LIKE '%>CAMINO A CASA%' THEN 'CAMINO A CASA'
              WHEN rs1.name_path LIKE '%>CAMPING LES MEDES%' THEN 'CAMPING LES MEDES'
              WHEN rs1.name_path LIKE '%GEOX>%' THEN 'GEOX'
              WHEN rs1.name_path LIKE '%LUJANS>%' THEN 'LUJANS'
              WHEN rs1.name_path LIKE '%CAROLINA BOIX (BAJA)%' THEN 'CAROLINA BOIX'
              WHEN rs1.name_path LIKE '%>CELICIOSO%' THEN 'CELICIOSO'
              WHEN rs1.name_path LIKE '%>CENTRO COMERCIAL NARON%' THEN 'CENTRO COMERCIAL NARON'
              WHEN rs1.name_path LIKE '%>CLINICA MARIBEL PASCUAL%' THEN 'CLINICA MARIBEL PASCUAL'
              WHEN rs1.name_path LIKE '%CLÍNICA UROLOGÍA DR. BUSTO%' THEN 'CLÍNICA UROLOGÍA DR. BUSTO'
              WHEN rs1.name_path LIKE '%CMB BRICOLAGE%' THEN 'CMB BRICOLAGE'
              WHEN rs1.name_path LIKE '%>COMERCIAL LEGENDRE%' THEN 'COMERCIAL LEGENDRE'
              WHEN rs1.name_path LIKE '%COREN GRILL%' THEN 'COREN GRILL'
              WHEN rs1.name_path LIKE '%>COSENTINO NETWORKING%' THEN 'COSENTINO NETWORKING'
              WHEN rs1.name_path LIKE '%>DISCESUR%' THEN 'DISCESUR'
              WHEN rs1.name_path LIKE '%>DOMINO''S PIZZA%' THEN 'DOMINO''S PIZZA'
              WHEN rs1.name_path LIKE '%>DORADO VINTAGE%' THEN 'DORADO VINTAGE'
              WHEN rs1.name_path LIKE '%EL GUINDILLA POETA BOSCA%' THEN 'EL GUINDILLA POETA BOSCA'
              WHEN rs1.name_path LIKE '%>FABRICA DE LA CERVEZA%' THEN 'FABRICA DE LA CERVEZA'
              WHEN rs1.name_path LIKE '%>FES MES%' THEN 'FES MES'
              WHEN rs1.name_path LIKE '%>FORECAST%' THEN 'FORECAST'
              WHEN rs1.name_path LIKE '%>FOSTERS HOLLYWOOD%' THEN 'FOSTERS HOLLYWOOD'
              WHEN rs1.name_path LIKE '%>FRIGOLA DURAN%' THEN 'FRIGOLA DURAN'
              WHEN rs1.name_path LIKE '%>GASTON Y DANIELA%' THEN 'GASTON Y DANIELA'
              WHEN rs1.name_path LIKE '%>GRUPO AUTOPODIUM%' THEN 'GRUPO AUTOPODIUM'
              WHEN rs1.name_path LIKE '%>GRUPO F. TOME-VOLKSWAGEN%' THEN 'VOLKSWAGEN'
              WHEN rs1.name_path LIKE '%>GRUPO GAFT%' THEN 'GRUPO GAFT'
              WHEN rs1.name_path LIKE '%>GRUPO LOIDA%' THEN 'GRUPO LOIDA'
              WHEN rs1.name_path LIKE '%>GRUPO NUMERO 1%' THEN 'GRUPO NUMERO 1'
              WHEN rs1.name_path LIKE '%>GRUPO ORENES%' THEN 'GRUPO ORENES'
              WHEN rs1.name_path LIKE '%>GRUPO OTER%' THEN 'GRUPO OTER'
              WHEN rs1.name_path LIKE '%>GRUPO RAZA NOSTRA%' THEN 'GRUPO RAZA NOSTRA'
              WHEN rs1.name_path LIKE '%>HARDWARE AND PARTS%' THEN 'HARDWARE AND PARTS'
              WHEN rs1.name_path LIKE '%>IKEA%' THEN 'IKEA'
              WHEN rs1.name_path LIKE '%>INGAPAN>%' THEN 'INGAPAN'
              WHEN rs1.name_path LIKE '%>JUGUETERIAS POLY%' THEN 'JUGUETERIAS POLY'
              WHEN rs1.name_path LIKE '%>LUSH%' THEN 'LUSH'
              WHEN rs1.name_path LIKE '%>M AUTOMOCION%' THEN 'M AUTOMOCION'
              WHEN rs1.name_path LIKE '%>MARCIAL SUPERMERCADOS SPAR%' THEN 'MARCIAL SUPERMERCADOS SPAR'
              WHEN rs1.name_path LIKE '%>MOVILNORTE>%' THEN 'MOVILNORTE'
              WHEN rs1.name_path LIKE '%>MY PHONE>%' THEN 'MY PHONE'
              WHEN rs1.name_path LIKE '%>NUÑEZ Y NAVARRO>%' THEN 'NUÑEZ Y NAVARRO'
              WHEN rs1.name_path LIKE '%>OPTICA ROMA>%' THEN 'OPTICA ROMA'
              WHEN rs1.name_path LIKE '%>PASTELERIA MALLORCA>%' THEN 'PASTELERIA MALLORCA'
              WHEN rs1.name_path LIKE '%>SUSHICATESSEN%' THEN 'SUSHICATESSEN'
              WHEN rs1.name_path LIKE '%>SYSTEM ACTION>%' THEN 'SYSTEM ACTION'
              WHEN rs1.name_path LIKE '%>VILLEMON%' THEN 'VILLEMON '
              WHEN rs1.name_path LIKE '%>GRUPO ABRASADOR%' THEN 'GRUPO ABRASADOR'
              WHEN rs1.name_path LIKE '%>LA MISION%' THEN 'LA MISION'
              WHEN rs1.name_path LIKE '%>RESTAURANTE LAS PALMERAS%' THEN 'RESTAURANTE LAS PALMERAS'
              WHEN rs1.name_path LIKE '%>RESTAURANTE ONDARRETA%' THEN 'RESTAURANTE ONDARRETA'
              WHEN rs1.name_path LIKE '%>RESTAURANTE ST. JAMES ORTEGA Y GASSET%' THEN 'RESTAURANTE ST. JAMES ORTEGA Y GASSET'
              WHEN rs1.name_path LIKE '%>RESTAURANTES DE MARIA%' THEN 'RESTAURANTES DE MARIA'
              WHEN rs1.name_path LIKE '%>RESTAURANTES FRESCO%' THEN 'RESTAURANTES FRESCO'
              WHEN rs1.name_path LIKE '%>ALAIN AFFLELOU%' THEN 'ALAIN AFFLELOU'
              WHEN rs1.name_path LIKE '%>CAMBRILS COMPLEJO%' THEN 'CAMBRILS COMPLEJO HOTELERO'
              WHEN rs1.name_path LIKE '%>GIMNASIOS FORUS%' THEN 'GIMNASIOS FORUS'
              WHEN rs1.name_path LIKE '%>GIMNASIOS VIDING%' THEN 'GIMNASIOS VIDING'
              WHEN rs1.name_path LIKE '%>HOTELES BE LIVE %' THEN 'HOTELES BE LIVE '

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
          WHERE
            1 = 1
            AND rs1.id = dev.group_id
          LIMIT 1
      ) grp ON TRUE
      WHERE dev.mac = chd.mac
      LIMIT 1
  ) dev ON TRUE
  INNER JOIN LATERAL (
    SELECT 
      chn.*
    FROM public.channels chn
    WHERE chn.id = chd.channel_id
    LIMIT 1
  ) chn ON TRUE
) AS rs
WHERE
   1 = 1
   AND rs.GroupEstadistica IN ('BON AREA', 'NH', 'NESPRESSO', 'GENERICO')
   AND NOT rs.GroupCuenta IN ('OTRAS CUENTAS')
GROUP BY
  rs.GroupCuenta
  , rs.serial_number
;