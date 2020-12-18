SELECT
  INITCAP(cl.display_name)::VARCHAR(255)      AS oportunidad_display_name -- AS "Tema"
  , cl.name                                   AS oportunidad_name -- AS  "Asunto"
  , cl.id                                     AS oportunidad_id -- AS "Código Oportunidad"
  , cl.sequence                               AS oportunidad_sequence -- AS "Referencia"
  , UPPER(rp.name)::VARCHAR(255)              AS oportunidad_partner_name -- AS "Cuenta"
  , cl.partner_id                             AS oportunidad_partner_id -- AS "ID (Cuenta) (Cuenta)"
  , INITCAP(cc.contactonombre)::VARCHAR(255)  AS oportunidad_contactonombre -- AS "Contacto"
  , cc.contactoid                             AS oportunidad_contactoid -- AS "Código (Contacto) (Contacto)"
  , ct.tipo::VARCHAR(255)                     AS oportunidad_tipo -- AS "tipo"
  , cl.create_date                            AS oportunidad_create_date -- AS "Fecha de creación"
  -- cl.priority Values(0:Muy baja 1:Bajo 2:Normal 3:Alto 4:Muy alta)
  , cl.priority                               AS oportunidad_probabilidad -- AS "Probabilidad"
  , cl.probability                            AS oportunidad_probability -- AS "Probabilidad o porcentaje de negociación"
  , cl.origen_field::VARCHAR(255)             AS oportunidad_Origen -- AS "Origen"
  , cl.title_action::VARCHAR(255)             AS oportunidad_title_action -- AS "Motivo detallado"  C
  , null                                      AS oportunidad_situacionactual -- AS "Situación actual" 
  , null                                      AS oportunidad_necesidadcliente -- AS "Necesidad del cliente"
  , null                                      AS oportunidad_solucionpropuesta -- AS "Solución propuesta"
  , NULL                                      AS oportunidad_importepresupuesto -- AS "Importe de presupuesto"
  , 'Desconocido'                             AS oportunidad_periodocompra -- AS "Período de tiempo de compra" 
  , 'Desconocido'                             AS oportunidad_procesocompra -- AS "Proceso de compra"
  , cl.planned_revenue                        AS oportunidad_importeestimado -- AS "Ingresos est."
  , cl.date_deadline                          AS oportunidad_date_deadline -- AS "Cierre previsto"
  , cs.etapa                                  AS oportunidad_estado -- AS "Estado"
  , mo.motivo_oportunidades::VARCHAR(255)     AS oportunidad_razonestado -- AS "Razón para el estado"
  , null                                      AS oportunidad_precios -- AS "Lista de precios"
  , 'Euro'                                    AS oportunidad_divisa -- AS "Divisa"
  , 'Proporcionado por el usuario'            AS oportunidad_ingreso -- AS Ingreso
  , null                                      AS oportunidad_descuento -- AS "Importe de descuento de oportunidad"
  , null                                      AS oportunidad_descuento_porcentaje -- AS "Descuento de oportunidad (%)"
  , null                                      AS oportunidad_importedetalle -- AS "Importe detallado total"
  , null                                      AS oportunidad_importetotal -- AS "Importe total"
  , null                                      AS oportunidad_canalizacion -- AS "Fase de canalización"
  , ml.mlcuentaid                             AS oportunidad_musicam_cuentaid
  , UPPER(ml.mlcuenta)::VARCHAR(255)          AS oportunidad_musicam_cuenta
  , ml.mlcontactoid                           AS oportunidad_musicam_contactoid
  , INITCAP(ml.mlcontacto)::VARCHAR(255)      AS oportunidad_musicam_contacto
  , ml.mlcalificacion::VARCHAR(50)            AS oportunidad_musicam_calificacion
  , rp.cif::VARCHAR(50)                       AS oportunidad_cif
FROM public.crm_lead cl
INNER JOIN public.res_partner rp ON cl.partner_id = rp.id
LEFT JOIN LATERAL (
    SELECT 
      ml.partner_id     AS mlcuentaid 
      , cuenta.name     AS mlcuenta
      , ml.contacto_id  AS mlcontactoid
      , contacto.name   AS mlcontacto
      , ml.calificacion AS mlcalificacion
    FROM
      public.musicam_lead ml 
      INNER JOIN public.res_partner cuenta ON ml.partner_id = cuenta.id
      INNER JOIN public.res_partner contacto ON ml.contacto_id = contacto.id
    WHERE
      1 = 1
      AND ml.lead_id = cl.id
  ) ml ON TRUE 
LEFT JOIN LATERAL (     -- Contacto Res_Partner
    SELECT 
      contacto.id           AS contactoid 
      , contacto.name       AS contactonombre
    FROM
      public.res_partner contacto 
    WHERE
      1 = 1
      --AND cm.partner_id = cl.partner_id
      AND contacto.cliente_id = cl.partner_id
    ORDER BY 
      contacto.create_date DESC
    LIMIT 1
  ) cc ON TRUE
LEFT JOIN LATERAL (     -- Tipo
  SELECT 
    string_agg(ct.name, '; ') AS "tipo"
  FROM 
    public.crm_tipo_musicam  ct
    INNER JOIN  public.crm_lead_crm_tipo_musicam_rel ctr ON ct.id = ctr.crm_tipo_musicam_id
  WHERE
    ctr.crm_lead_id = cl.id
  ) ct ON true
LEFT JOIN LATERAL (     -- **
  SELECT 
    --mo.id::varchar(2) || ': ' || mo.name AS motivo_oportunidades 
    mo.name AS motivo_oportunidades 
  FROM 
    motivo_oportunidades mo
  WHERE
    mo.id = cl.motivo_oportunidades_id
  ) mo ON true
LEFT JOIN LATERAL (     -- **
  SELECT
    cs.id AS "etapa_id"
    , cs.name AS "etapa"
  FROM
    crm_case_stage cs
  WHERE
    cs.id = cl.stage_aux2_id 
  ) cs ON true
LEFT JOIN LATERAL (     -- ** Presupuesto
  SELECT
    SUM(so.amount_total) AS "so_amount_total"
  FROM
    sale_order so
  WHERE
    so.lead_id = cl.id
  GROUP BY
    so.lead_id
  ) so ON true
WHERE 
   1 = 1
  AND NOT cl.partner_id IS NULL
  AND cl.stage_aux2_id IN (9)
  --AND cl.sequence = '202003111239'
;
