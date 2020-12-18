DECLARE @mm_id INT 

SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC

IF @mm_id IS NULL 
BEGIN
	SELECT @mm_id =	CAST([dbo].[Split_Position](MAX(ID), '-', 2) AS INT) + 1 
	FROM [TheSensoryLab_Migration].[source].[xlsCuentas_BC]

	INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id ,GETDATE(), 'cerrada ganada, sin cuenta Business Central')
END

PRINT @mm_id
--TRUNCATE TABLE dbo.Control_Tables_Ids
TRUNCATE TABLE [source].[xlsCuentas_NEW]

/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [source].[xlsCuentas_NEW] (
	 [(No modificar) Cuenta]
	,[(No modificar) Suma de comprobación de fila]
	,[(No modificar) Fecha de modificación]
	,ID
	,[ID GMX]
	,[Nº Cuenta BC]
	,Nombre
	,[Empresa padre]
	,[ID (Empresa padre) (Cuenta)]
	,[ID GMX (Empresa padre) (Cuenta)]
	,[Tipo de relación]
	,[Tipo de cuenta]
	,[Es centro]
	,CIF
	,[Razón social]
	,Objetivo
	,[Marca comercial]
	,[Forma de pago]
	,[Plazo de pago]
	,[Puntos propios]
	,[Clase de cliente]
	,Sector
	,[Sitio web]
	,[Fecha de apertura]
	,[Horario del centro]
	,[Fecha inicio baja temporal]
	,[Fecha fin baja temporal]
	,[Motivo baja temporal]
	,[Teléfono general o central]
	,[Otro teléfono]
	,[Email general]
	,Fax
	,[Contacto principal]
	,[Código (Contacto principal) (Contacto)]
	,[Formato factura preferido]
	,[Sede (form# web)]
	,[Tipo de dirección]
	,Calle
	,[Código Postal]
	,[Código (Código Postal) (Código Postal)]
	,Ciudad
	,[Código (Ciudad) (Ciudad)]
	,Provincia
	,[Código (Provincia) (Provincia)]
	,País
	,[Código (País) (País)]
	,Descripción
	,Divisa
	,Propietario
	,[Razón para el estado]
	,Estado
	,[Fecha de creación]
	,[Enviar materiales de marketing]
	,[No permitir correo elec# en masa]
	,[No permitir correo electrónico]
	,Altas
	,[Dirección de correo electrónico 2]
	,[Dirección de correo electrónico 3]
)
SELECT 
	NULL												AS [(No modificar) Cuenta]
    ,NULL												AS [(No modificar) Suma de comprobación de fila]
    ,NULL												AS [(No modificar) Fecha de modificación]
    ,CONCAT('C-', ROW_NUMBER() OVER(ORDER BY sp.[partner_id]) + @mm_id - 1 )	AS [ID]
    ,sp.[partner_id]									AS [ID GMX]
    ,NULL												AS [Nº Cuenta BC]
    ,sp.[partner_name]									AS [Nombre]
    ,NULL												AS [Empresa padre]
    ,NULL												AS [ID (Empresa padre) (Cuenta)]
    ,sp.[partner_parent_id]								AS [ID GMX (Empresa padre) (Cuenta)]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'cadena' THEN 'Cliente'
		ELSE sp.[partner_nametipocliente]
	END													AS [Tipo de relación]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'distribuidor' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] = 'Distribuidor Potencial' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] IS NULL THEN sp.[partner_nametipocliente]
		ELSE 'Razón social'					
	END													AS [Tipo de cuenta]
    ,'No'												AS [Es centro]
    ,sp.[partner_cif]									AS [CIF]
    ,sp.[partner_razon_social]							AS [Razón social]
    ,CASE 
		WHEN TRIM(sp.[partner_objetivo]) = '1'	THEN 'Sí'
		ELSE 'No'						
	END													AS [Objetivo]
    ,NULL												AS [Marca comercial]
    ,CASE 
		WHEN TRIM(sp.[partner_nameformapago]) = 'SEGÚN CONTRATO CADENA' THEN NULL
		WHEN TRIM(sp.[partner_nameformapago]) = 'STRIPE' THEN NULL
		ELSE TRIM(sp.[partner_nameformapago])
	END													AS [Forma de pago]
    ,NULL												AS [Plazo de pago]
    ,sp.[partner_puntos_propios]						AS [Puntos propios]
    ,NULL												AS [Clase de cliente]
    ,hs.[SectorDynamics365]								AS [Sector]
    ,sp.[partner_website]								AS [Sitio web]
    ,NULL												AS [Fecha de apertura]
    ,NULL												AS [Horario del centro]
    ,NULL												AS [Fecha inicio baja temporal]
    ,NULL												AS [Fecha fin baja temporal]
    ,NULL												AS [Motivo baja temporal]
    ,sp.[partner_phone]									AS [Teléfono general o central]
    ,sp.[partner_mobile]								AS [Otro teléfono]
    ,CASE 
		WHEN sp.[partner_email] LIKE '%<%' THEN NULL
		WHEN sp.[partner_email] LIKE '%,%' THEN NULL
		WHEN sp.[partner_email] LIKE '%"%' THEN NULL
		WHEN sp.[partner_email] LIKE '%[%' THEN NULL
		WHEN sp.[partner_email] LIKE '%|%' THEN NULL
		WHEN PATINDEX('%@%', sp.[partner_email]) > 0 THEN sp.[partner_email]
		ELSE NULL
	END													AS [Email general]
    ,sp.[partner_fax]									AS [Fax]
    ,sc.[contact_name]									AS [Contacto principal]
    ,sc.[contact_id]									AS [Código (Contacto principal) (Contacto)]
    ,NULL												AS [Formato factura preferido]
    ,'ESP'												AS [Sede (form# web)]
    ,NULL												AS [Tipo de dirección]
    ,IIF(sp.[partner_street] IS NULL, NULL, CONCAT(CONCAT(TRIM(sp.[partner_street]), ' '), COALESCE(TRIM(sp.[partner_street2]), ''))) AS [Calle]
    ,IIF(sp.[partner_zip] IS NULL,[partner_namezip], sp.[partner_zip])	AS [Código Postal]
    ,NULL												AS [Código (Código Postal) (Código Postal)]
    ,TRIM(sp.[partner_city])							AS [Ciudad]
    ,NULL												AS [Código (Ciudad) (Ciudad)]
    ,TRIM(sp.[partner_namecountrystate])				AS [Provincia]
    ,NULL												AS [Código (Provincia) (Provincia)]
    ,NULL												AS [País]
    ,TRIM(sp.[partner_namecountry])						AS [Código (País) (País)]
    ,NULL												AS [Descripción]
    ,'Euro'												AS [Divisa]
    ,hu.[UsuarioDynamics365]							AS [Propietario]
    ,CASE
		WHEN sp.[partner_estado] = 'activo' THEN 'Activo'
		ELSE 'Baja'
	END													AS [Razón para el estado]
    ,[dbo].[CapitalizeFirstLetter](sp.[partner_estado])	AS [Estado]
    ,FORMAT(sp.[partner_create_date], 'MM/dd/yyyy')		AS [Fecha de creación]
    ,'No enviar'										AS [Enviar materiales de marketing]
    ,'No permitir'										AS [No permitir correo elec# en masa]
    ,CASE 
		WHEN TRIM(sp.[partner_notify_email]) = 'always' THEN 'Permitir'
		WHEN TRIM(sp.[partner_notify_email]) = 'none' THEN 'No permitir'
		ELSE NULL 
	END													AS [No permitir correo electrónico]
    ,CAST(
		IIF(PATINDEX('%[^ 0-9]%', sp.[parent_altas])>0,
		NULL,sp.[parent_altas])
		AS INT)											AS [Altas]
    ,sp.[partner_email2]								AS [Dirección de correo electrónico 2]
    ,sp.[partner_email3]								AS [Dirección de correo electrónico 3]
FROM [postgreSQL].[src_Partner] sp
OUTER APPLY (
	SELECT [UsuarioDynamics365]
	FROM [dbo].[Homologacion_Usuarios] 
	WHERE
		[Active] = 1
		AND [UsuarioGMX] = sp.[parent_create_uid]	
) hu
OUTER APPLY (
	SELECT [SectorDynamics365]
	FROM [dbo].[Homologacion_Sectores]
	WHERE 
		[Active] = 1
		AND [SectorGMX] = sp.[partner_nametipocategoria]
) hs
OUTER APPLY (
	SELECT TOP 1
		sc.[contact_id]
		,sc.[contact_name]
	FROM [postgreSQL].[src_contact]	sc
	WHERE
		sc.[contact_cliente_id] = sp.[partner_id]
) sc
WHERE
	1 = 1
	AND sp.[partner_id] IN (
		SELECT
			sho.oportunidad_partner_id 
		FROM 
		  [postgreSQL].[src_header_opportunities] sho
		  OUTER APPLY (
		    SELECT TOP 1
		       xbc.ID
		      ,xbc.[Nº Cuenta BC]
		    FROM [source].[xlsCuentas_BC] xbc
		    WHERE
		      1 = 1
		      AND xbc.[Es centro] = 'No' 
		      AND xbc.CIF = sho.oportunidad_cif 
		  ) xbc 
		WHERE
			1 = 1
			AND sho.oportunidad_estado = 'cerrada ganada'  
			AND xbc.id IS NULL 
		GROUP BY
			sho.oportunidad_partner_id 
	)

INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'cerrada perdida, sin cuenta Business Central')

SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC

/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [source].[xlsCuentas_NEW] (
	 [(No modificar) Cuenta]
	,[(No modificar) Suma de comprobación de fila]
	,[(No modificar) Fecha de modificación]
	,ID
	,[ID GMX]
	,[Nº Cuenta BC]
	,Nombre
	,[Empresa padre]
	,[ID (Empresa padre) (Cuenta)]
	,[ID GMX (Empresa padre) (Cuenta)]
	,[Tipo de relación]
	,[Tipo de cuenta]
	,[Es centro]
	,CIF
	,[Razón social]
	,Objetivo
	,[Marca comercial]
	,[Forma de pago]
	,[Plazo de pago]
	,[Puntos propios]
	,[Clase de cliente]
	,Sector
	,[Sitio web]
	,[Fecha de apertura]
	,[Horario del centro]
	,[Fecha inicio baja temporal]
	,[Fecha fin baja temporal]
	,[Motivo baja temporal]
	,[Teléfono general o central]
	,[Otro teléfono]
	,[Email general]
	,Fax
	,[Contacto principal]
	,[Código (Contacto principal) (Contacto)]
	,[Formato factura preferido]
	,[Sede (form# web)]
	,[Tipo de dirección]
	,Calle
	,[Código Postal]
	,[Código (Código Postal) (Código Postal)]
	,Ciudad
	,[Código (Ciudad) (Ciudad)]
	,Provincia
	,[Código (Provincia) (Provincia)]
	,País
	,[Código (País) (País)]
	,Descripción
	,Divisa
	,Propietario
	,[Razón para el estado]
	,Estado
	,[Fecha de creación]
	,[Enviar materiales de marketing]
	,[No permitir correo elec# en masa]
	,[No permitir correo electrónico]
	,Altas
	,[Dirección de correo electrónico 2]
	,[Dirección de correo electrónico 3]
)
SELECT 
	NULL												AS [(No modificar) Cuenta]
    ,NULL												AS [(No modificar) Suma de comprobación de fila]
    ,NULL												AS [(No modificar) Fecha de modificación]
    ,CONCAT('C-', ROW_NUMBER() OVER(ORDER BY sp.[partner_id]) + @mm_id - 1 )	AS [ID]
    ,sp.[partner_id]									AS [ID GMX]
    ,NULL												AS [Nº Cuenta BC]
    ,sp.[partner_name]									AS [Nombre]
    ,NULL												AS [Empresa padre]
    ,NULL												AS [ID (Empresa padre) (Cuenta)]
    ,sp.[partner_parent_id]								AS [ID GMX (Empresa padre) (Cuenta)]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'cadena' THEN 'Cliente'
		ELSE sp.[partner_nametipocliente]
	END													AS [Tipo de relación]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'distribuidor' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] = 'Distribuidor Potencial' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] IS NULL THEN sp.[partner_nametipocliente]
		ELSE 'Razón social'					
	END													AS [Tipo de cuenta]
    ,'No'												AS [Es centro]
    ,sp.[partner_cif]									AS [CIF]
    ,sp.[partner_razon_social]							AS [Razón social]
    ,CASE 
		WHEN TRIM(sp.[partner_objetivo]) = '1'	THEN 'Sí'
		ELSE 'No'						
	END													AS [Objetivo]
    ,NULL												AS [Marca comercial]
    ,CASE 
		WHEN TRIM(sp.[partner_nameformapago]) = 'SEGÚN CONTRATO CADENA' THEN NULL
		WHEN TRIM(sp.[partner_nameformapago]) = 'STRIPE' THEN NULL
		ELSE TRIM(sp.[partner_nameformapago])
	END													AS [Forma de pago]
    ,NULL												AS [Plazo de pago]
    ,sp.[partner_puntos_propios]						AS [Puntos propios]
    ,NULL												AS [Clase de cliente]
    ,hs.[SectorDynamics365]								AS [Sector]
    ,sp.[partner_website]								AS [Sitio web]
    ,NULL												AS [Fecha de apertura]
    ,NULL												AS [Horario del centro]
    ,NULL												AS [Fecha inicio baja temporal]
    ,NULL												AS [Fecha fin baja temporal]
    ,NULL												AS [Motivo baja temporal]
    ,sp.[partner_phone]									AS [Teléfono general o central]
    ,sp.[partner_mobile]								AS [Otro teléfono]
    ,CASE 
		WHEN sp.[partner_email] LIKE '%<%' THEN NULL
		WHEN sp.[partner_email] LIKE '%,%' THEN NULL
		WHEN sp.[partner_email] LIKE '%"%' THEN NULL
		WHEN sp.[partner_email] LIKE '%[%' THEN NULL
		WHEN sp.[partner_email] LIKE '%|%' THEN NULL
		WHEN PATINDEX('%@%', sp.[partner_email]) > 0 THEN sp.[partner_email]
		ELSE NULL
	END													AS [Email general]
    ,sp.[partner_fax]									AS [Fax]
    ,sc.[contact_name]									AS [Contacto principal]
    ,sc.[contact_id]									AS [Código (Contacto principal) (Contacto)]
    ,NULL												AS [Formato factura preferido]
    ,'ESP'												AS [Sede (form# web)]
    ,NULL												AS [Tipo de dirección]
    ,IIF(sp.[partner_street] IS NULL, NULL, CONCAT(CONCAT(TRIM(sp.[partner_street]), ' '), COALESCE(TRIM(sp.[partner_street2]), ''))) AS [Calle]
    ,IIF(sp.[partner_zip] IS NULL,[partner_namezip], sp.[partner_zip])	AS [Código Postal]
    ,NULL												AS [Código (Código Postal) (Código Postal)]
    ,TRIM(sp.[partner_city])							AS [Ciudad]
    ,NULL												AS [Código (Ciudad) (Ciudad)]
    ,TRIM(sp.[partner_namecountrystate])				AS [Provincia]
    ,NULL												AS [Código (Provincia) (Provincia)]
    ,NULL												AS [País]
    ,TRIM(sp.[partner_namecountry])						AS [Código (País) (País)]
    ,NULL												AS [Descripción]
    ,'Euro'												AS [Divisa]
    ,hu.[UsuarioDynamics365]							AS [Propietario]
    ,CASE
		WHEN sp.[partner_estado] = 'activo' THEN 'Activo'
		ELSE 'Baja'
	END													AS [Razón para el estado]
    ,[dbo].[CapitalizeFirstLetter](sp.[partner_estado])	AS [Estado]
    ,FORMAT(sp.[partner_create_date], 'MM/dd/yyyy')		AS [Fecha de creación]
    ,'No enviar'										AS [Enviar materiales de marketing]
    ,'No permitir'										AS [No permitir correo elec# en masa]
    ,CASE 
		WHEN TRIM(sp.[partner_notify_email]) = 'always' THEN 'Permitir'
		WHEN TRIM(sp.[partner_notify_email]) = 'none' THEN 'No permitir'
		ELSE NULL 
	END													AS [No permitir correo electrónico]
    ,CAST(
		IIF(PATINDEX('%[^ 0-9]%', sp.[parent_altas])>0,
		NULL,sp.[parent_altas])
		AS INT)											AS [Altas]
    ,sp.[partner_email2]								AS [Dirección de correo electrónico 2]
    ,sp.[partner_email3]								AS [Dirección de correo electrónico 3]
FROM [postgreSQL].[src_Partner] sp
OUTER APPLY (
	SELECT [UsuarioDynamics365]
	FROM [dbo].[Homologacion_Usuarios] 
	WHERE
		[Active] = 1
		AND [UsuarioGMX] = sp.[parent_create_uid]	
) hu
OUTER APPLY (
	SELECT [SectorDynamics365]
	FROM [dbo].[Homologacion_Sectores]
	WHERE 
		[Active] = 1
		AND [SectorGMX] = sp.[partner_nametipocategoria]
) hs
OUTER APPLY (
	SELECT TOP 1
		sc.[contact_id]
		,sc.[contact_name]
	FROM [postgreSQL].[src_contact]	sc
	WHERE
		sc.[contact_cliente_id] = sp.[partner_id]
) sc
WHERE
	1 = 1
	AND sp.[partner_id] IN (
		SELECT
			sho.oportunidad_partner_id 
		FROM 
		  [postgreSQL].[src_header_opportunities] sho
		  OUTER APPLY (
		    SELECT TOP 1
		       xbc.ID
		      ,xbc.[Nº Cuenta BC]
		    FROM [source].[xlsCuentas_BC] xbc
		    WHERE
		      1 = 1
		      AND xbc.[Es centro] = 'No' 
		      AND xbc.CIF = sho.oportunidad_cif 
		  ) xbc 
		WHERE
			1 = 1
			AND sho.oportunidad_estado = 'cerrada perdida'  
			AND xbc.id IS NULL 
		GROUP BY
			sho.oportunidad_partner_id 
	)


INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'nuevas cuentas Business Central, agregar cuentas padres')

SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC

/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [source].[xlsCuentas_NEW] (
	 [(No modificar) Cuenta]
	,[(No modificar) Suma de comprobación de fila]
	,[(No modificar) Fecha de modificación]
	,ID
	,[ID GMX]
	,[Nº Cuenta BC]
	,Nombre
	,[Empresa padre]
	,[ID (Empresa padre) (Cuenta)]
	,[ID GMX (Empresa padre) (Cuenta)]
	,[Tipo de relación]
	,[Tipo de cuenta]
	,[Es centro]
	,CIF
	,[Razón social]
	,Objetivo
	,[Marca comercial]
	,[Forma de pago]
	,[Plazo de pago]
	,[Puntos propios]
	,[Clase de cliente]
	,Sector
	,[Sitio web]
	,[Fecha de apertura]
	,[Horario del centro]
	,[Fecha inicio baja temporal]
	,[Fecha fin baja temporal]
	,[Motivo baja temporal]
	,[Teléfono general o central]
	,[Otro teléfono]
	,[Email general]
	,Fax
	,[Contacto principal]
	,[Código (Contacto principal) (Contacto)]
	,[Formato factura preferido]
	,[Sede (form# web)]
	,[Tipo de dirección]
	,Calle
	,[Código Postal]
	,[Código (Código Postal) (Código Postal)]
	,Ciudad
	,[Código (Ciudad) (Ciudad)]
	,Provincia
	,[Código (Provincia) (Provincia)]
	,País
	,[Código (País) (País)]
	,Descripción
	,Divisa
	,Propietario
	,[Razón para el estado]
	,Estado
	,[Fecha de creación]
	,[Enviar materiales de marketing]
	,[No permitir correo elec# en masa]
	,[No permitir correo electrónico]
	,Altas
	,[Dirección de correo electrónico 2]
	,[Dirección de correo electrónico 3]
)
SELECT 
	NULL												AS [(No modificar) Cuenta]
    ,NULL												AS [(No modificar) Suma de comprobación de fila]
    ,NULL												AS [(No modificar) Fecha de modificación]
    ,CONCAT('C-', ROW_NUMBER() OVER(ORDER BY sp.[partner_id]) + @mm_id - 1 )	AS [ID]
    ,sp.[partner_id]									AS [ID GMX]
    ,NULL												AS [Nº Cuenta BC]
    ,sp.[partner_name]									AS [Nombre]
    ,NULL												AS [Empresa padre]
    ,NULL												AS [ID (Empresa padre) (Cuenta)]
    ,sp.[partner_parent_id]								AS [ID GMX (Empresa padre) (Cuenta)]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'cadena' THEN 'Cliente'
		ELSE sp.[partner_nametipocliente]
	END													AS [Tipo de relación]
    ,CASE 
		WHEN sp.[partner_nametipocliente] = 'distribuidor' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] = 'Distribuidor Potencial' THEN 'Distribuidor'
		WHEN sp.[partner_nametipocliente] IS NULL THEN sp.[partner_nametipocliente]
		ELSE 'Razón social'					
	END													AS [Tipo de cuenta]
    ,'No'												AS [Es centro]
    ,sp.[partner_cif]									AS [CIF]
    ,sp.[partner_razon_social]							AS [Razón social]
    ,CASE 
		WHEN TRIM(sp.[partner_objetivo]) = '1'	THEN 'Sí'
		ELSE 'No'						
	END													AS [Objetivo]
    ,NULL												AS [Marca comercial]
    ,CASE 
		WHEN TRIM(sp.[partner_nameformapago]) = 'SEGÚN CONTRATO CADENA' THEN NULL
		WHEN TRIM(sp.[partner_nameformapago]) = 'STRIPE' THEN NULL
		ELSE TRIM(sp.[partner_nameformapago])
	END													AS [Forma de pago]
    ,NULL												AS [Plazo de pago]
    ,sp.[partner_puntos_propios]						AS [Puntos propios]
    ,NULL												AS [Clase de cliente]
    ,hs.[SectorDynamics365]								AS [Sector]
    ,sp.[partner_website]								AS [Sitio web]
    ,NULL												AS [Fecha de apertura]
    ,NULL												AS [Horario del centro]
    ,NULL												AS [Fecha inicio baja temporal]
    ,NULL												AS [Fecha fin baja temporal]
    ,NULL												AS [Motivo baja temporal]
    ,sp.[partner_phone]									AS [Teléfono general o central]
    ,sp.[partner_mobile]								AS [Otro teléfono]
    ,CASE 
		WHEN sp.[partner_email] LIKE '%<%' THEN NULL
		WHEN sp.[partner_email] LIKE '%,%' THEN NULL
		WHEN sp.[partner_email] LIKE '%"%' THEN NULL
		WHEN sp.[partner_email] LIKE '%[%' THEN NULL
		WHEN sp.[partner_email] LIKE '%|%' THEN NULL
		WHEN PATINDEX('%@%', sp.[partner_email]) > 0 THEN sp.[partner_email]
		ELSE NULL
	END													AS [Email general]
    ,sp.[partner_fax]									AS [Fax]
    ,sc.[contact_name]									AS [Contacto principal]
    ,sc.[contact_id]									AS [Código (Contacto principal) (Contacto)]
    ,NULL												AS [Formato factura preferido]
    ,'ESP'												AS [Sede (form# web)]
    ,NULL												AS [Tipo de dirección]
    ,IIF(sp.[partner_street] IS NULL, NULL, CONCAT(CONCAT(TRIM(sp.[partner_street]), ' '), COALESCE(TRIM(sp.[partner_street2]), ''))) AS [Calle]
    ,IIF(sp.[partner_zip] IS NULL,[partner_namezip], sp.[partner_zip])	AS [Código Postal]
    ,NULL												AS [Código (Código Postal) (Código Postal)]
    ,TRIM(sp.[partner_city])							AS [Ciudad]
    ,NULL												AS [Código (Ciudad) (Ciudad)]
    ,TRIM(sp.[partner_namecountrystate])				AS [Provincia]
    ,NULL												AS [Código (Provincia) (Provincia)]
    ,NULL												AS [País]
    ,TRIM(sp.[partner_namecountry])						AS [Código (País) (País)]
    ,NULL												AS [Descripción]
    ,'Euro'												AS [Divisa]
    ,hu.[UsuarioDynamics365]							AS [Propietario]
    ,CASE
		WHEN sp.[partner_estado] = 'activo' THEN 'Activo'
		ELSE 'Baja'
	END													AS [Razón para el estado]
    ,[dbo].[CapitalizeFirstLetter](sp.[partner_estado])	AS [Estado]
    ,FORMAT(sp.[partner_create_date], 'MM/dd/yyyy')		AS [Fecha de creación]
    ,'No enviar'										AS [Enviar materiales de marketing]
    ,'No permitir'										AS [No permitir correo elec# en masa]
    ,CASE 
		WHEN TRIM(sp.[partner_notify_email]) = 'always' THEN 'Permitir'
		WHEN TRIM(sp.[partner_notify_email]) = 'none' THEN 'No permitir'
		ELSE NULL 
	END													AS [No permitir correo electrónico]
    ,CAST(
		IIF(PATINDEX('%[^ 0-9]%', sp.[parent_altas])>0,
		NULL,sp.[parent_altas])
		AS INT)											AS [Altas]
    ,sp.[partner_email2]								AS [Dirección de correo electrónico 2]
    ,sp.[partner_email3]								AS [Dirección de correo electrónico 3]
FROM [postgreSQL].[src_Partner] sp
OUTER APPLY (
	SELECT [UsuarioDynamics365]
	FROM [dbo].[Homologacion_Usuarios] 
	WHERE
		[Active] = 1
		AND [UsuarioGMX] = sp.[parent_create_uid]	
) hu
OUTER APPLY (
	SELECT [SectorDynamics365]
	FROM [dbo].[Homologacion_Sectores]
	WHERE 
		[Active] = 1
		AND [SectorGMX] = sp.[partner_nametipocategoria]
) hs
OUTER APPLY (
	SELECT TOP 1
		sc.[contact_id]
		,sc.[contact_name]
	FROM [postgreSQL].[src_contact]	sc
	WHERE
		sc.[contact_cliente_id] = sp.[partner_id]
) sc
WHERE
	1 = 1
	AND sp.[partner_id] IN (
		SELECT 
	       xbc.[ID GMX (Empresa padre) (Cuenta)]
		FROM
			[source].[xlsCuentas_NEW] xbc
		WHERE
			NOT xbc.[ID GMX (Empresa padre) (Cuenta)] IS NULL 
	)


INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'cierre cuentas Business Central')

UPDATE xbc SET
    	xbc.[ID (Empresa padre) (Cuenta)] = xbcf.[ID] --SELECT DISTINCT xbc.[ID (Empresa padre) (Cuenta)], xbcf.[ID]
	FROM
		[source].[xlsCuentas_NEW] xbc
		INNER JOIN [source].[xlsCuentas_NEW] xbcf ON xbc.[ID GMX (Empresa padre) (Cuenta)] = xbcf.[ID GMX]
	WHERE
		NOT xbc.[ID GMX (Empresa padre) (Cuenta)] IS NULL 


