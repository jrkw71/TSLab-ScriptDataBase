/*
https://sqlstudies.com/2015/03/25/clean-out-all-bad-characters-from-a-string/

DECLARE @Pattern varchar(50) = '%[^a-zA-Z0-9_''{}"() *&%$#@!?/\;:,.<>]%';
----------------------------------------------------------------------------------------------- 
PROCESO DE OPORTUNIDADES GMX
----------------------------------------------------------------------------------------------- 
1. Inicializar Tablas Proceso de Oportunidades
*/
TRUNCATE TABLE [source].[xlsCuentas_BC];			-- Tabla Business Central
TRUNCATE TABLE [source].[xlsCuentas_NEW];			-- Tabla Business Central Nuevas Cuentas
TRUNCATE TABLE [dbo].[Control_Tables_Ids];			-- Control de Ids Dinamics
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS dbo.BadStringList;				-- Tabla proceso limpieza Textos (Nombre, calle)
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Homologacion_Cuentas;			-- Tabla Homologacion Cuentas GMX - Business Central
----------------------------------------------------------------------------------------------- 
/*
2. Insertar Datos [source].[xlsCuentas_BC_BK] a [source].[xlsCuentas_BC]
-----------------------------------------------------------------------------------------------
	Nota: Datos Actualizados a 9-Nov-2020 Alicia
-----------------------------------------------------------------------------------------------
*/
INSERT INTO [source].[xlsCuentas_BC]
SELECT *
FROM [source].[xlsCuentas_BC_BK]
;
/*
3. Insertar Datos datos para el proceso de Homologación
-----------------------------------------------------------------------------------------------
	Nota: Los datos que se utilizan de GMX, son de la ultima fecha de proceso ETL Visual Studio 2017.
	Los datos actuales corresponden al 12-Dic-2020 
-----------------------------------------------------------------------------------------------
*/
SELECT 
	CAST(bc.[calle] AS VARCHAR(MAX)) AS txtLeftCalle 
	, CAST(rc.[calle] AS VARCHAR(MAX)) AS txtrightCalle
	, CAST(bc.[Nombre] AS VARCHAR(MAX)) AS txtLeftNombre
	, CAST(rc.[Nombre] AS VARCHAR(MAX)) AS txtrightNombre
	, bc.[id] AS [bcId]
	, rc.[id] AS [gmxId]
	, 0 AS [state] 
INTO BadStringList
FROM [source].[xlsCuentas_BC] bc
	CROSS APPLY(
		SELECT 
			rc.[id]
			, rc.[Calle]
			, rc.[Nombre]
		FROM [target].[rs_Cuentas] rc
		WHERE
			1 = 1
			AND TRIM(rc.[Codigo Postal]) = TRIM(bc.[Código Postal])
			AND TRIM(rc.[Ciudad]) = TRIM(bc.[Ciudad])
			AND TRIM(rc.[Provincia]) = TRIM(bc.[Provincia])
	) rc
;
-----------------------------------------------------------------------------------------------
ALTER TABLE BadStringList ADD Id INT NOT NULL IDENTITY (1,1) 
     CONSTRAINT pk_BadStringList PRIMARY KEY
;
/*
-----------------------------------------------------------------------------------------------
	Nota: Patron de Caracteres Aceptados en Proceso de Homologación
-----------------------------------------------------------------------------------------------
*/
DECLARE @Pattern varchar(50) = '%[^a-zA-Z0-9 ]%';
-----------------------------------------------------------------------------------------------
-- txtLeftCalle
-----------------------------------------------------------------------------------------------
WITH FixBadChars 
AS (
	SELECT 
		txtLeftCalle AS StringToFix
		, CAST(txtLeftCalle AS VARCHAR(MAX)) AS FixedString
		, 1 AS MyCounter
		, Id
    FROM 
		BadStringList
    UNION ALL
    SELECT 
		StringToFix
		, Stuff(FixedString, PatIndex(@Pattern, 
			FixedString COLLATE Latin1_General_BIN2), 1, ' ') AS FixedString
		, MyCounter + 1
		, Id
    FROM FixBadChars
    WHERE 
		FixedString COLLATE Latin1_General_BIN2 LIKE @Pattern
)
UPDATE bl
	SET txtLeftCalle = fx.FixedString
FROM BadStringList bl
	INNER JOIN  FixBadChars fx ON bl.Id = fx.Id
WHERE 
	fx.MyCounter = (
		SELECT MAX(MyCounter) 
        FROM FixBadChars Fixed
        WHERE 
			Fixed.Id = fx.Id
		)
-----------------------------------------------------------------------------------------------
OPTION (MAXRECURSION 1000);
-----------------------------------------------------------------------------------------------
;
-----------------------------------------------------------------------------------------------
-- txtrightCalle
-----------------------------------------------------------------------------------------------
WITH FixBadChars 
AS (
	SELECT 
		txtrightCalle AS StringToFix
		, CAST(txtrightCalle AS VARCHAR(MAX)) AS FixedString
		, 1 AS MyCounter
		, Id
    FROM 
		BadStringList
    UNION ALL
    SELECT 
		StringToFix
		, Stuff(FixedString, PatIndex(@Pattern, 
			FixedString COLLATE Latin1_General_BIN2), 1, ' ') AS FixedString
		, MyCounter + 1
		, Id
    FROM FixBadChars
    WHERE 
		FixedString COLLATE Latin1_General_BIN2 LIKE @Pattern
)
UPDATE bl
	SET txtrightCalle = fx.FixedString
FROM BadStringList bl
	INNER JOIN  FixBadChars fx ON bl.Id = fx.Id
WHERE 
	fx.MyCounter = (
		SELECT MAX(MyCounter) 
        FROM FixBadChars Fixed
        WHERE 
			Fixed.Id = fx.Id
		)
-----------------------------------------------------------------------------------------------
OPTION (MAXRECURSION 1000);
-----------------------------------------------------------------------------------------------
;
-----------------------------------------------------------------------------------------------
-- txtLeftNombre
-----------------------------------------------------------------------------------------------
WITH FixBadChars 
AS (
	SELECT 
		txtLeftNombre AS StringToFix
		, CAST(txtLeftNombre AS VARCHAR(MAX)) AS FixedString
		, 1 AS MyCounter
		, Id
    FROM 
		BadStringList
    UNION ALL
    SELECT 
		StringToFix
		, Stuff(FixedString, PatIndex(@Pattern, 
			FixedString COLLATE Latin1_General_BIN2), 1, ' ') AS FixedString
		, MyCounter + 1
		, Id
    FROM FixBadChars
    WHERE 
		FixedString COLLATE Latin1_General_BIN2 LIKE @Pattern
)
UPDATE bl
	SET txtLeftNombre = fx.FixedString
FROM BadStringList bl
	INNER JOIN  FixBadChars fx ON bl.Id = fx.Id
WHERE 
	fx.MyCounter = (
		SELECT MAX(MyCounter) 
        FROM FixBadChars Fixed
        WHERE 
			Fixed.Id = fx.Id
		)
-----------------------------------------------------------------------------------------------
OPTION (MAXRECURSION 1000);
-----------------------------------------------------------------------------------------------
;
-----------------------------------------------------------------------------------------------
-- txtrightNombre
-----------------------------------------------------------------------------------------------
WITH FixBadChars 
AS (
	SELECT 
		txtrightNombre AS StringToFix
		, CAST(txtrightNombre AS VARCHAR(MAX)) AS FixedString
		, 1 AS MyCounter
		, Id
    FROM 
		BadStringList
    UNION ALL
    SELECT 
		StringToFix
		, Stuff(FixedString, PatIndex(@Pattern, 
			FixedString COLLATE Latin1_General_BIN2), 1, ' ') AS FixedString
		, MyCounter + 1
		, Id
    FROM FixBadChars
    WHERE 
		FixedString COLLATE Latin1_General_BIN2 LIKE @Pattern
)
UPDATE bl
	SET txtrightNombre = fx.FixedString
FROM BadStringList bl
	INNER JOIN  FixBadChars fx ON bl.Id = fx.Id
WHERE 
	fx.MyCounter = (
		SELECT MAX(MyCounter) 
        FROM FixBadChars Fixed
        WHERE 
			Fixed.Id = fx.Id
		)
-----------------------------------------------------------------------------------------------
OPTION (MAXRECURSION 1000);
-----------------------------------------------------------------------------------------------
;
/*
4. Insertar Datos datos Homologados
-----------------------------------------------------------------------------------------------
	Nota: Los datos que se utilizan de GMX, son de la ultima fecha de proceso ETL Visual Studio 2017.
	Los datos actuales corresponden al 12-Dic-2020 
-----------------------------------------------------------------------------------------------
*/
WITH rsComparacion([txtLeftCalle], [txtrightCalle], [txtLeftNombre], [txtrightNombre], [bcId], [gmxId], [TestCalle], [TestNombre], [state])
AS (
SELECT  [txtLeftCalle]
	  , [txtrightCalle]
	  , [txtLeftNombre]
	  , [txtrightNombre]
      , [bcId]
	  , [gmxId]
	  , [dbo].[TextCompare]([txtLeftCalle] ,[txtrightCalle], 0.75, 1.34)  AS TestCalle
      , [dbo].[TextCompare]([txtLeftNombre] ,[txtrightNombre], 0.50, 1.50)  AS testNombre
      ,[state]
  FROM [dbo].[BadStringList]
)
SELECT
	rs.[txtLeftCalle]
	, rs.[txtrightCalle]
	, rs.[txtLeftNombre]
	, rs.[txtrightNombre]
    , rs.[bcId]
	, rs.[gmxId]
	, rs.[TestCalle]
    , rs.[testNombre]
    , CASE 
		WHEN agg.numreg = 1 THEN 1 
		WHEN agg.numgmxid = 2 AND rs.gmxid < 1000000 AND agg.numbcid = 1 THEN 1
		ELSE rs.[state]
		END	AS [state]
	, agg.numreg
	, agg.numbcId
	, agg.numgmxId
INTO
-----------------------------------------------------------------------------------------------
	Homologacion_Cuentas
-----------------------------------------------------------------------------------------------
FROM rsComparacion rs
CROSS APPLY(
	SELECT
		COUNT(1) AS numreg
		, COUNT(DISTINCT agg.bcid) AS numbcId
		, COUNT(DISTINCT agg.gmxid) AS numgmxId
	FROM rsComparacion agg
	WHERE
		agg.[txtLeftCalle] = rs.[txtLeftCalle]
		AND agg.[txtrightCalle] = rs.[txtrightCalle]
		AND agg.[txtLeftNombre] = rs.[txtLeftNombre]
		AND agg.[txtrightNombre] = rs.[txtrightNombre]
	GROUP BY
		agg.[txtLeftCalle]
	  , agg.[txtrightCalle]
	  , agg.[txtLeftNombre]
	  , agg.[txtrightNombre]
) agg
WHERE
	rs.[testCalle] BETWEEN 0.75 AND 1.34
	AND rs.[testNombre] BETWEEN 0.50 AND 1.5
Order By
	rs.[txtleftNombre]
;
/*
5. Actualización de Tabla [source].[xlsCuentas_BC] por la tabla [dbo].[Homologacion_Cuentas]
-----------------------------------------------------------------------------------------------
	Nota: Esta actualizacion permitira registrar cuentas existentes GMX en los datos de Business Central
	Los datos  importantes a actualziar :
		1: GMXID
		2: Razon social
		3: CIF
		4: Cuenta Padre (Cuando sea posible)

	NOTA: IMPORTANTE!!! Este proceso se cambiara por un MERGE, se realizara los INSERT en la tabla [source].[xlsCuentas_UPDATE]
	Para entregar Alicia Jara, solo los registros que se han actualizado.
*/

/*
5.1 Actualizacion Empresas y Centros [Nº Cuenta BC] = [CIF]
	Nota: Este proceso se hizo en el primer proceso de Homologacion con cuentas GMX, sin embargo 
		solo se actualizaron aquellas cuentas que tubieran una RELACION GMX-BC, en caso contrario
		Los datos se dejan como el ORIGEN. 
		En este PROCESO, se actualizaran e identificaran todas aquellas empresas, con sus centros 
		en base a los datos BC.

		Criterios:
			[Nº Cuenta BC] = [CIF]			-- Registro de la cuenta Empresa CIF
			[Nº Cuenta BC] <> [CIF]			-- Se identifican como CENTROS

		Excepción: Existira una restriccion cuando el CIF tenga una casa MATRIZ, en caso que no se logre identificar, 
			quedara identificada como centro. Y debera hacerse una actualizacion MANUAL.

		NOTA:
			AND bc.[ID GMX] IS NULL  // Solo Cuentas que no esten relacionadas con GMX
			AND bc.[Nº Cuenta BC] <> bc.[CIF]  // No se incluye la cuenta CIF
			AND bc.[ID] <> COALESCE(cif.[ID (Empresa padre) (Cuenta)], '**NA**')  // No incluir la cuenta padre del CIF

		NOTA:
			Las cuentas que se actualizaran se concideran centros, por tanto el campo [Es centro]
			se actualiza a 'Sí' 
-----------------------------------------------------------------------------------------------
*/

UPDATE bc
SET 
	bc.[ID (Empresa padre) (Cuenta)] = cif.[ID (Empresa padre) (Cuenta)] 
	, bc.[Es centro] = 'Sí'
FROM
	[source].[xlsCuentas_BC] bc
	CROSS APPLY(
		SELECT 
			cif.[ID]
			, cif.[ID (Empresa padre) (Cuenta)]
		FROM
			[source].[xlsCuentas_BC] cif
		WHERE
			1 = 1
			AND cif.[ID GMX] IS NULL
			AND cif.[Nº Cuenta BC] = cif.[CIF]
			AND cif.[CIF] = bc.[CIF]
	) cif
WHERE
	1 = 1
	AND bc.[ID GMX] IS NULL
	AND bc.[Nº Cuenta BC] <> bc.[CIF]
	AND bc.[ID] <> COALESCE(cif.[ID (Empresa padre) (Cuenta)], '**NA**')
;
/*
5.2 UPDATE GMX Homologación 

	NOTA:
		bc.[ID GMX] IS NULL       // Solo se Homologaran las cuentas que no tenga GMX
		AND COALESCE(bc.[ID GMX (Empresa padre) (Cuenta)], 0) <> sp.[ID GMX] 
		// Debe ser consistente los valores, ya que no puee ser padre e hijo, Esto puede suceder
		// Cuando, la direcciones coinciden las del padre e hijo
*/

--SELECT
--	bc.[ID]
--	, bc.[Nº Cuenta BC]
--	, bc.[ID GMX]
--	, bc.[ID (Empresa padre) (Cuenta)]
--	, bc.[ID GMX (Empresa padre) (Cuenta)]
--	, bc.[CIF]
--	, bc.[Razón social]
--	, bc.[Código (Contacto principal) (Contacto)]
--	, bc.[Contacto principal] 
--	, sp.[ID GMX]
--	, sp.[ID GMX (Empresa padre) (Cuenta)]
--	, sp.[CIF]
--	, sp.[Razón social]
--	, sp.[Código (Contacto principal) (Contacto)]
--	, sp.[Contacto principal] 
UPDATE bc
SET
	bc.[ID GMX] = sp.[ID GMX]
	, bc.[ID GMX (Empresa padre) (Cuenta)] = COALESCE(bc.[ID GMX (Empresa padre) (Cuenta)], sp.[ID GMX (Empresa padre) (Cuenta)])
	, bc.[Razón social] = COALESCE(bc.[Razón social], sp.[Razón social])
	, bc.[Código (Contacto principal) (Contacto)] = COALESCE(bc.[Código (Contacto principal) (Contacto)], sp.[Código (Contacto principal) (Contacto)])
	, bc.[Contacto principal] = COALESCE(bc.[Contacto principal], sp.[Contacto principal])
FROM
	[source].[xlsCuentas_BC] bc
	CROSS APPLY(
		SELECT
			hc.[gmxId]
		FROM [dbo].[Homologacion_Cuentas] hc
		WHERE
			hc.[state] = 1
			AND hc.[bcId] = bc.[ID]
	) hc
	CROSS APPLY (
		SELECT 
			sp.[partner_id]				AS [ID GMX]
			, sm.[centro_parent_id]		AS [ID GMX (Empresa padre) (Cuenta)]
			, sp.[partner_cif]			AS [CIF]
			, sp.[partner_razon_social]	AS [Razón social]
			, sc.[contact_id]			AS [Código (Contacto principal) (Contacto)]
			, sc.[contact_name]			AS [Contacto principal] 
		FROM [postgreSQL].[src_Partner] sp
		OUTER APPLY (
			SELECT
				IIF(sm.[matriz_id]=sm.[centro_parent_id], 1000000+sm.[matriz_id], sm.[matriz_id]) AS [matriz_id]
				, sm.[centro_parent_id]
				, sm.[nombre_del_centro]
			FROM [postgreSQL].[src_musicam] sm
			WHERE 
				sm.[partner_id] = sp.[partner_id]
		) sm
		OUTER APPLY (
			SELECT TOP 1
				COALESCE(xc.[Código], FORMAT(sc.[contact_id], 'CON-A0000000')) AS [contact_id]
				,sc.[contact_name]
			FROM [postgreSQL].[src_contact]	sc
			OUTER APPLY(
				SELECT 
					xc.[Código]
				FROM 
 					[source].[xlsContactos] xc
				WHERE
					xc.[Código GMX] = sc.[contact_id]
			) xc
			WHERE
				sc.[contact_cliente_id] = sp.[partner_id]
			ORDER BY 
				sc.[contact_create_date] ASC
		) sc
		WHERE
			sp.[partner_id] = hc.[gmxId]
	) sp
WHERE
	bc.[ID GMX] IS NULL
	AND COALESCE(bc.[ID GMX (Empresa padre) (Cuenta)], 0) <> sp.[ID GMX]
;

/*
5.3 UPDATE GMX Padre de Cuentas que se hallan modificado en Homologación. 
*/
UPDATE bc
	SET
	bc.[ID GMX] = bc1.[ID GMX (Empresa padre) (Cuenta)]
FROM
	[source].[xlsCuentas_BC] bc
	CROSS APPLY (
		SELECT
			bc1.*
		FROM
			[source].[xlsCuentas_BC] bc1 
		WHERE
			1 = 1
			AND NOT bc1.[ID (Empresa padre) (Cuenta)] IS NULL
			AND NOT [ID GMX (Empresa padre) (Cuenta)] IS NULL
			AND bc1.[ID (Empresa padre) (Cuenta)] = bc.[ID]
		) bc1
WHERE
	bc.[ID GMX] IS NULL
	
/*
6. Analisis de Oportunidades
-----------------------------------------------------------------------------------------------
	Nota: Los datos que se utilizan de GMX, son de la ultima fecha de proceso ETL Visual Studio 2017.
	Los datos actuales corresponden al 12-Dic-2020 
-----------------------------------------------------------------------------------------------
*/
DECLARE @mm_id INT 
-----------------------------------------------------------------------------------------------
SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC
-----------------------------------------------------------------------------------------------
IF @mm_id IS NULL 
BEGIN
	SELECT @mm_id =	CAST([dbo].[Split_Position](MAX(ID), '-', 2) AS INT) + 1 
	FROM [source].[xlsCuentas_BC]
END
-----------------------------------------------------------------------------------------------
INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		VALUES ('xlsCuentas_BC' ,@mm_id ,GETDATE(), 'cerrada ganada, sin cuenta Business Central')
-----------------------------------------------------------------------------------------------
/*
6.1 Analisis de Oportunidades - Buscar Cuentas de las Oportunidades Ganadas que No existan en Business Central
-----------------------------------------------------------------------------------------------
	Nota: Previo a esta busqueda se debe actualizar la tabla [source].[xlsCuentas_BC] en base a la Homologación de Cuentas
-----------------------------------------------------------------------------------------------
*/
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
;

/*
6.2 Analisis de Oportunidades - Buscar Cuentas de las Oportunidades Perdidas que No existan en Business Central
-----------------------------------------------------------------------------------------------
	Nota: Previo a esta busqueda se debe actualizar la tabla [source].[xlsCuentas_BC] en base a la Homologación de Cuentas
-----------------------------------------------------------------------------------------------
*/
-----------------------------------------------------------------------------------------------
INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'cerrada perdida, sin cuenta Business Central')
-----------------------------------------------------------------------------------------------
SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC
-----------------------------------------------------------------------------------------------
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
;
/*
6.3 Analisis de Oportunidades - Agregar Cuentas Padres
-----------------------------------------------------------------------------------------------
	Nota: Previo a esta busqueda se debe actualizar la tabla [source].[xlsCuentas_BC] en base a la Homologación de Cuentas
-----------------------------------------------------------------------------------------------
*/
-----------------------------------------------------------------------------------------------
INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'nuevas cuentas Business Central, agregar cuentas padres')
-----------------------------------------------------------------------------------------------
SELECT TOP 1 @mm_id = ct.[Id]
FROM [dbo].[Control_Tables_Ids] ct
WHERE ct.[Table] = 'xlsCuentas_BC'
ORDER BY ct.[created] DESC
-----------------------------------------------------------------------------------------------
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
;
/*
6.4 Analisis de Oportunidades - Cierre Proceso de Actualizacion de Cuentas
-----------------------------------------------------------------------------------------------
	Nota: Previo a esta busqueda se debe actualizar la tabla [source].[xlsCuentas_BC] en base a la Homologación de Cuentas
-----------------------------------------------------------------------------------------------
*/
-----------------------------------------------------------------------------------------------
INSERT INTO [dbo].[Control_Tables_Ids] ([Table] ,[Id] ,[created], [notes])
		 VALUES ('xlsCuentas_BC' ,@mm_id + @@ROWCOUNT ,GETDATE(), 'fin Proceso, cierre cuentas Business Central')
;
-----------------------------------------------------------------------------------------------
UPDATE xbc SET
    	xbc.[ID (Empresa padre) (Cuenta)] = xbcf.[ID] --SELECT DISTINCT xbc.[ID (Empresa padre) (Cuenta)], xbcf.[ID]
	FROM
		[source].[xlsCuentas_NEW] xbc
		INNER JOIN [source].[xlsCuentas_NEW] xbcf ON xbc.[ID GMX (Empresa padre) (Cuenta)] = xbcf.[ID GMX]
	WHERE
		NOT xbc.[ID GMX (Empresa padre) (Cuenta)] IS NULL 
;
-----------------------------------------------------------------------------------------------
