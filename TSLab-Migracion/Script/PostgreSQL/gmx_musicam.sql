SELECT 
  m.id
  , m.write_uid
  , m.create_date
  , m.create_uid
  , m.razon_social 
  , m.message_last_post
  , m.centro_parent_id
  , m.write_date
  , m.partner_id
  , m.denominacion
  , m.estado_centro
  , m.phonecall_count_centro
  , m.matriz_id
  , m.cambio_equipo_count
  , m.cambio_canal_count
  , m.horario
  , m.fecha_apertura
  , INITCAP(m.nombre_del_centro)::VARCHAR(255) AS nombre_del_centro
  , m.representante_legal
  , m.contrato_fecha
  , m.product_count
  , m.fecha_baja
  , INITCAP(m.busqueda_direccion)::VARCHAR(255) AS busqueda_direccion
  , m.estado_admin
  , m.reforma_fin
  , m.reforma_inicio
  , m.motivo_baja
  , m.id_murano
FROM 
  centro_musicam m
WHERE
  1 = 1
  --AND NOT m.nombre_del_centro LIKE '%salesforce%'
;