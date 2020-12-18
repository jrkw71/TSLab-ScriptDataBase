SELECT
  tdd.id
  , INITCAP(tdd.name)::VARCHAR(255)           AS name
  , tdd.create_date
  , tdd.direccion_facturacion::VARCHAR(5)     AS direccion_facturacion
  , tdd.direccion_instalacion::VARCHAR(5)     AS direccion_instalacion
  , rptddr.res_partner_id
  , rp.commercial_partner_id
	, INITCAP(rp.name)::VARCHAR(255)            AS direction_name
	, rp.state_id                               AS direction_state_id
	, UPPER(s.nameCountryState)::VARCHAR(255)   AS direction_nameCountryState
	, rp.is_company                             AS direction_is_company
	, INITCAP(rp.city)::VARCHAR(255)            AS direction_city
	, INITCAP(rp.street)::VARCHAR(255)          AS direction_street
	, INITCAP(rp.street2)::VARCHAR(255)         AS direction_street2
	, rp.country_id                             AS direction_country_id    --FK Definir Default Value
	, UPPER(c.nameCountry)::VARCHAR(255)        AS direction_nameCountry
	, rp.type                                   AS direction_type
	, rp.zip                                    AS direction_zip
	, rp.zip_id                                 AS direction_zip_id        -- FK
	, rp.estado                                 AS direction_estado
	, r.nameZip                                 AS direction_nameZip
FROM
  res_partner_tipo_de_direccion_rel rptddr
  INNER JOIN tipo_de_direccion tdd ON rptddr.tipo_de_direccion_id = tdd.id
  INNER JOIN res_partner rp ON rptddr.res_partner_id = rp.id
  LEFT JOIN LATERAL (
      SELECT  
      --  c.name AS nameCountry
          c.code AS nameCountry
      FROM res_country AS c
      WHERE 
        c.id = rp.country_id -- Only allowed because of lateral
  ) c ON true
  LEFT JOIN LATERAL (
      SELECT  
        s.name AS nameCountryState
      FROM res_country_state AS s
      WHERE 
        s.id = rp.state_id -- Only allowed because of lateral
  ) s ON true 
  LEFT JOIN LATERAL (
      SELECT  
        r.name AS nameZip
        , r.display_name
      FROM  res_better_zip AS r
      WHERE 
        r.id = rp.zip_id -- Only allowed because of lateral
  ) r ON true 
WHERE
  1 = 1
;