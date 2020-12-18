SELECT
	p.id                                      AS partner_id
	, p.create_date                           AS partner_create_date
	, p.cif                                   AS partner_cif
	, INITCAP(p.name)::VARCHAR(255)           AS partner_name
	, p.state_id                              AS partner_state_id
	, s.nameCountryState                      AS partner_nameCountryState
  , split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 1)::VARCHAR(255) AS partner_email
	, p.is_company                            AS partner_is_company
	, LOWER(p.website)::VARCHAR(512)          AS partner_website
	, p.customer                              AS partner_customer      -- Identifica si es información de cliente el registro.  NO QUE ES CLIENTE
	, p.city::VARCHAR(255)                    AS partner_city
	, p.street::VARCHAR(255)                  AS partner_street
	, p.street2::VARCHAR(255)                 AS partner_street2
	, p.fax                                   AS partner_fax
	, p.phone                                 AS partner_phone
	, p.mobile                                AS partner_mobile
	, p.skype                                 AS partner_skype
	, p.country_id                            AS partner_country_id    --FK Definir Default Value
	, c.nameCountry                           AS partner_nameCountry
	, p.type                                  AS partner_type
	, p.notify_email                          AS partner_notify_email
	, p.zip                                   AS partner_zip
	, p.zip_id                                AS partner_zip_id        -- FK
	, UPPER(TRIM(LEADING ' ' FROM p.razon_social))::VARCHAR(255) AS partner_razon_social
	, p.estado                                AS partner_estado
	, r.nameZip                               AS partner_nameZip
	, INITCAP(r.display_name)::VARCHAR(512)   AS partner_display_name
	, p.tipo_de_categoria_id                  AS partner_tipo_de_categoria_id
	, INITCAP(tca.nameTipoCategoria)::VARCHAR(255) AS partner_nameTipoCategoria
	, p.tipo_de_cliente_id                    AS partner_tipo_de_cliente_id
	, INITCAP(tc.nameTipoCliente)::VARCHAR(255) AS partner_nameTipoCliente
	, p.informe_city  AS partner_informe_city
	, INITCAP(p.estado_admin)::VARCHAR(255)   AS partner_estado_admin
	, INITCAP(p.busqueda_direccion)::VARCHAR(255) AS partner_busqueda_direccion
	, p.update_res_better_zip_status          AS partner_update_res_better_zip_status
	, p.cliente_id                            AS partner_cliente_id
	, p.es_objetivo                           AS partner_objetivo
	, p.salesforce_puntos_propios             AS partner_puntos_propios
	, p.direccion_a_copiar_id                 AS partner_direccion_id
	, p.forma_de_pago_id                      AS partner_forma_pago_id
	, UPPER(fp.name_forma_pago)::VARCHAR(255) AS partner_nameFormaPago
	, fp.necesita_cuenta_bancaria             AS partner_cuentaFormaPago
	, p.competencia                           AS partner_compentencia
	, p.user_id                               AS partner_user_id
  , p.parent_id                             AS partner_parent_id
--  -------------------------------------------------------------------
  , p.comment::VARCHAR(255)                 AS parent_comment
  , INITCAP(p.function)::VARCHAR(255)       AS parent_function
  , p.supplier                              AS parent_supplier
  , p.is_company                            AS parent_is_company
  , p.customer                              AS parent_customer 
  , p.write_date                            AS parent_write_date
  , p.active                                AS parent_active
  , p.tz                                    AS parent_timezone
  , p.lang                                  AS parent_lang
  --, p.write_uid AS parent_write_uid
  --, p.create_uid AS parent_create_uid
  , us.name                                 AS parent_create_uid  -- Se Remplaza por el Valor de Name Ver INNER JOIN 
  , p.commercial_partner_id                 AS parent_commercial_partner_id
  , p.notify_email                          AS parent_notify_email
  , p.copiar_direccion_en_hijos             AS parent_direccion 
  , p.rel_tipo_de_categoria_id              AS parent_rel_tipo_de_categoria_id
  , p.rel_tipo_de_cliente_id                AS parent_rel_tipo_de_cliente_id
  , p.rel_tipo_de_etapa_id                  AS parent_rel_tipo_de_etapa_id  
  , p.instalador_musicam                    AS parent_instalador_musicam
  , p.mensajeria_musicam                    AS parent_mensajeria_musicam
  , p.distribuidor_musicam                  AS parent_distribuidor_musicam
  , p.proveedor_musicam                     AS parent_proveedor_musicam
  , p.salesforce_altas                      AS parent_altas
  , split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 2)::VARCHAR(255) AS Email2
  , split_part(REPLACE(REPLACE(LOWER(p.email), '/', ';'), ',', ';'), ';', 3)::VARCHAR(255) AS Email3
FROM
  res_partner AS p
  LEFT JOIN LATERAL (
      SELECT  
        -- c.name AS nameCountry 
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
  LEFT JOIN LATERAL (
      SELECT  
        tc.name AS nameTipoCliente
      FROM  tipo_de_cliente AS tc
      WHERE 
        tc.id = p.tipo_de_cliente_id -- Only allowed because of lateral
  ) tc ON true 
  LEFT JOIN LATERAL (
      SELECT  
        tca.name AS nameTipoCategoria
      FROM  tipo_de_categoria AS tca
      WHERE 
        tca.id = p.tipo_de_categoria_id -- Only allowed because of lateral
  ) tca ON true 
  LEFT JOIN LATERAL (
      SELECT  
        r.name AS nameZip
        , r.display_name
      FROM  res_better_zip AS r
      WHERE 
        r.id = p.zip_id -- Only allowed because of lateral
  ) r ON true 
  LEFT JOIN LATERAL (
      SELECT  
        fp.name AS name_forma_pago
        , fp.necesita_cuenta_bancaria
      FROM  forma_de_pago AS fp
      WHERE 
        fp.id = p.forma_de_pago_id -- Only allowed because of lateral
  ) fp ON TRUE 
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
  LEFT JOIN LATERAL (
    SELECT ptd.res_partner_id FROM res_partner_tipo_de_direccion_rel ptd WHERE p.id = ptd.res_partner_id LIMIT 1 ) ptd ON TRUE
WHERE
  1 = 1
  AND ptd.res_partner_id IS NULL  -- Excluir Direcciones 
  AND NOT p.name LIKE '%(salesforce)%' -- Regla Exclusion: Dirección por defecto (salesforce)