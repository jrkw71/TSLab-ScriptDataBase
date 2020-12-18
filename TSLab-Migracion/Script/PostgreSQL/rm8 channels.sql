SELECT 
  dev.serial_number
  ,chd.*
  ,chn.name AS ChannelName
  ,CASE 
    WHEN chn.id > 1000 THEN 'Canal Programado'
    ELSE 'Canal'
  END AS TipoCanal
  ,CASE 
    WHEN LEFT(chn.name,1) = '*' THEN 'Canal Cliente'
    ELSE 'Musicam'
  END AS CanalCliente
  ,DATE_PART('day', chd.available_until - NOW()) AS DiasRestantes
  ,CASE  
      WHEN DATE_PART('day', chd.available_until - NOW()) > 365 THEN '4: Mayor a un año'
      WHEN DATE_PART('day', chd.available_until - NOW()) > 180 THEN '3: Entre 6 a 12 meses'
      WHEN DATE_PART('day', chd.available_until - NOW()) > 120 THEN '2: Entre 3 a 6 meses'
      WHEN DATE_PART('day', chd.available_until - NOW()) > 30 THEN '1: Entre 1 a 3 meses'
      WHEN DATE_PART('day', chd.available_until - NOW()) > 0 THEN '0: Entre 1 a 30 dias'
      ELSE 'Vencido!!!'
  END AS RangosChannels
  ,dev.activity
  ,dev.StateName
  ,TO_TIMESTAMP(TO_CHAR(dev.date, 'YYYY-MM-DD HH24:MI:SS.MS'), 'YYYY-MM-DD HH24:MI:SS.MS') AS LastDateActive
  ,dev.date
  ,DATE_PART('day', dev.date - NOW()) AS DiasOff
  ,CASE 
      WHEN DATE_PART('day', dev.date - NOW()) > -1 THEN '0: Conectado'
      WHEN DATE_PART('day', dev.date - NOW()) > -11 THEN '1: Entre 1 a 10 dias'
      WHEN DATE_PART('day', dev.date - NOW()) > -21 THEN '2: Entre 11 a 20 dias'
      WHEN DATE_PART('day', dev.date - NOW()) > -31 THEN '3: Entre 21 a 30 dias'
      WHEN DATE_PART('day', dev.date - NOW()) > -41 THEN '4: Entre 31 a 40 dias'
      ELSE '5: Sin Conexion'
  END AS RangosUltimaConexion
  ,dev.GroupName
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
      FROM public.devices dev
      INNER JOIN LATERAL (
          SELECT 
            sta.*
          FROM public.device_statuses sta
          WHERE sta.mac = dev.mac
          ORDER BY sta.mac, sta.date DESC 
          LIMIT 1
      ) sta ON TRUE
      INNER JOIN LATERAL (
          SELECT 
            sts.*
          FROM public.devices_states sts
          WHERE sts.id = dev.state_id
          LIMIT 1
      ) sts ON TRUE
      INNER JOIN LATERAL (
          SELECT 
            grp.*
          FROM public.groups grp
          WHERE grp.id = dev.group_id
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
;
