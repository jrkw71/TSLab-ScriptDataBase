/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT
	NULL AS [(No modificar) Contacto]
	,NULL AS [(No modificar) Suma de comprobación de fila]
	,NULL AS [(No modificar) Fecha de modificación]
	,NULL AS [Código]
	,[codigo] AS [Código GMX]
	,[Nombre de pila]
	,[apellido] AS[Apellidos]
	,[Puesto]
	,CASE 
		WHEN [Email] LIKE '%<%' THEN NULL
		WHEN [Email] LIKE '%,%' THEN NULL
		WHEN [Email] LIKE '%"%' THEN NULL
		WHEN [Email] LIKE '%[%' THEN NULL
		WHEN [Email] LIKE '%|%' THEN NULL
		WHEN PATINDEX('%@%', [Email]) > 0 THEN [Email]
		ELSE NULL
	END AS [Email]
	,[telefono] AS [Teléfono]
	,[movil] AS [Teléfono móvil]
	,[skype] AS [Mensajería (Skype/WhatsApp]
	--,[Nombre compañia] AS [Nombre de la compañía]
	,null AS [Nombre de la compañía]
	--,bc.[ID] AS [ID (Nombre de la compañía) (Cuenta)]
	,null AS [ID (Nombre de la compañía) (Cuenta)]
	,[codigo empresa] AS [ID GMX (Nombre de la compañía) (Cuenta)]
	,[Metodo de Contacto Preferido] AS [Método de contacto preferido]
	,[Clasificacion MKT] AS [Clasificación MKT]
	,[Calle]
	,[Tipo de Direccion] AS [Tipo de dirección]
	,iif([Ciudad Id] IS NULL, null,[Ciudad]) AS [Ciudad]
	,[Ciudad Id] AS [Código (Ciudad) (Ciudad)]
	,iif([Codigo Postal Id] IS NULL, null, [Codigo Postal]) AS [Código Postal]
	,[Codigo Postal Id] AS [Código (Código Postal) (Código Postal)]
	,iif([Provincia Id] is null, null , [Provincia]) AS [Provincia]
	,[Provincia Id] AS [Código (Provincia) (Provincia)]
	,NULL AS [País]
	,[pais] AS [Código (País) (País)]
	,'Goom Spain' AS [Propietario]
	,[Es operario]
	,[Razon Estado] AS [Razón para el estado]
	,[Estado]
	,[Descripcion] AS [Descripción]
	,[No permitir correo elec. en masa]
	,[no permitir correo electronico] AS [No permitir correo electrónico]
	,[Enviar materiales de marketing]
	,[fecha de creacion] AS [Fecha de creación]
	,[email2] AS [Dirección de correo electrónico 2]
	,[email3] AS [Dirección de correo electrónico 3]

FROM [target].[rs_contacto] ct
	CROSS APPLY (
		SELECT 
			bc.[ID] 
			,bc.[Nombre]
		FROM [source].[xlsCuentas_BC] bc
		WHERE
			bc.[ID GMX] = ct.[codigo Empresa]
	) bc
WHERE
	1 =1 --existe = 0
	AND NOT ct.Codigo IN (
		SELECT 
			xct.[Código GMX]
		FROM [source].[xlsContactos] xct
	)

