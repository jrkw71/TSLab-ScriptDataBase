SELECT 
  p.id
  ,p.parent_id
  ,p.representante_legal_id
  ,p.padre_id
  ,p.direccion_a_copiar_id
  ,p.commercial_partner_id
  ,p.cliente_id
FROM res_partner p 
-------------------------------------------------------------------------------------------------------
--  REGLAS de Filtrado de Registros
-------------------------------------------------------------------------------------------------------
  LEFT JOIN res_partner_tipo_de_direccion_rel ptd ON p.id = ptd.res_partner_id
WHERE
  1 = 1
  AND ptd.res_partner_id IS NULL  -- Excluir Direcciones 
  AND NOT p.name LIKE '%(salesforce)%' -- Regla Exclusion: Dirección por defecto (salesforce)

;