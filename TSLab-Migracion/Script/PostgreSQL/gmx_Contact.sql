
SELECT 
    p.id                                AS contact_id
    , INITCAP(p.name)::VARCHAR(255)     AS contact_name
    , p.create_date                     AS contact_create_date
    , INITCAP(p.street)::VARCHAR(255)   AS contact_street
    , INITCAP(p.city)::VARCHAR(255)     AS contact_city
    , p.zip                             AS contact_zip
    , INITCAP(p.function)               AS contact_function
    , p.country_id                      AS contact_country_id
    , split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 1)::VARCHAR(255) AS contact_email
    , p.fax                             AS contact_fax
    , INITCAP(p.street2)::VARCHAR(255)  AS contact_street2
    , p.employee                        AS contact_employee
    , p.active                          AS contact_active
    , p.tz                              AS contact_tz
    , p.lang                            AS contact_lang
    , p.phone                           AS contact_phone
    , p.mobile                          AS contact_mobile
    , p.skype                           AS contact_skype
    , p.type                            AS contact_type
    , p.state_id                        AS contact_state_id
    , p.commercial_partner_id           AS contact_commercial_partner_id
    , p.estado                          AS contact_estado
    , p.cliente_id                      AS contact_cliente_id
    , p.cif_estado                      AS contact_cif_estado
    , p.rel_tipo_de_categoria_id        AS contact_rel_tipo_de_categoria_id
    , p.rel_tipo_de_cliente_id          AS contact_rel_tipo_de_cliente_id
    , p.rel_tipo_de_etapa_id            AS contact_rel_tipo_de_etapa_id
    , p.codigo_barra                    AS contact_codigo_barra
    , INITCAP(p.display_name)           AS contact_display_name
    --, p.r_tipo_de_cliente_id            AS contact_r_tipo_de_cliente_id
    --, p.r_tipo_de_categoria_id          AS contact_r_tipo_de_categoria_id
    --, p.r_tipo_de_etapa_id              AS contact_r_tipo_de_etapa_id
    , INITCAP(p.informe_city)::VARCHAR(255) AS contact_informe_city
    , p.informe_country_id              AS contact_informe_country_id
    , p.informe_state_id                AS contact_informe_state_id
    , INITCAP(p.busqueda_direccion)::VARCHAR(255) AS contact_busqueda_direccion
    , p.estado_admin                    AS contact_estado_admin
    , p.origen_field                    AS contact_origen_field
    , p.notify_email                    AS contact_notify_email
    --, p.user_id                         AS contact_uid
    , INITCAP(us.name)::VARCHAR(255)    AS contact_uid
    , UPPER(c.nameCountry)::VARCHAR(2)  AS contact_nameCountry
    , UPPER(s.nameCountryState)::VARCHAR(255) AS contact_nameCountryState
    ,split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 2)::VARCHAR(255) AS contact_Email2
    ,split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 3)::VARCHAR(255) AS contact_Email3
  FROM res_partner p 
  LEFT JOIN LATERAL (
      SELECT  
      --  c.name AS nameCountry
          c.code AS nameCountry
      FROM res_country AS c
      WHERE 
        c.id = p.country_id -- Only allowed because of lateral
  ) c ON true
  LEFT JOIN LATERAL (
      SELECT  
        s.name AS nameCountryState
      FROM res_country_state AS s
      WHERE 
        s.id = p.state_id -- Only allowed because of lateral
  ) s ON true 
  INNER JOIN (
    SELECT
      us.id
      , rp.name
    FROM res_users us
      INNER JOIN res_partner rp ON us.partner_id = rp.id
  ) us ON p.create_uid = us.id
-------------------------------------------------------------------------------------------------------
--  REGLAS de Filtrado de Registros
-------------------------------------------------------------------------------------------------------
  WHERE  
    1 = 1 
    AND NOT p.cliente_id IS NULL
    AND NOT p.name LIKE '%(salesforce)%' -- Regla Exclusion: Dirección por defecto (salesforce)
    --AND LENGTH(p.street) > 200
    --AND LENGTH(split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 1)) > 200
    --AND LENGTH(p.busqueda_direccion) > 255
    --AND NOT p.user_id is NULL
  ;