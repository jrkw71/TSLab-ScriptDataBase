SELECT 
  g.id
  , g.name
  , 
  , g.parent_id
FROM
  public.groups g
  INNER JOIN (
    WITH RECURSIVE subordinates AS (
    	SELECT
    		g.id,
    		g.name,
    		g.parent_id
    	FROM
    		public.groups g
    	WHERE
    		g.id = 2196  -- Musicam Group
    	UNION
    		SELECT
      		g.id,
      		g.name,
      		g.parent_id
    		FROM
    			public.groups g
    		INNER JOIN subordinates s ON s.id = g.parent_id
    ) SELECT
    	s.id
      , s.name
      , s.parent_id
    FROM
    	subordinates s 
  
  
  )


WHERE 
  g.parent_id = 3
ORDER BY
  g.name
;




WITH RECURSIVE subordinates AS (
	SELECT
		g.id,
		g.name,
		g.parent_id
	FROM
		public.groups g
	WHERE
		g.id = 2196  -- Musicam Group
	UNION
		SELECT
  		g.id,
  		g.name,
  		g.parent_id
		FROM
			public.groups g
		INNER JOIN subordinates s ON s.id = g.parent_id
) SELECT
	s.id
  , s.name
  , s.parent_id
FROM
	subordinates s 
WHERE
  1 = 1
;


