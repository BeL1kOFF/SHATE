WITH CTE AS (
              SELECT
                smg.nodeid,
                smg.Code
              FROM
                [%company$Item Group] smg
              WHERE
                smg.nodeid = :NodeId AND
                smg.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ'
              UNION ALL
              SELECT
                smg.nodeid,
                smg.Code
              FROM
                CTE c
                JOIN [%company$Item Group] smg
                  ON smg.parentid = c.nodeid)
  SELECT DISTINCT
    t.[Trade Mark Name]
  FROM
    tm t
    JOIN part p
      ON p.tmid = t.[Trade Mark Code]
    JOIN [%company$Item] sm
      ON sm.[Part ID] = p.partid
    JOIN [%company$Item Item Group] smig
      ON smig.[Item No_] = sm.No_
    JOIN CTE c
      ON c.Code = smig.[Item Group Code]
  WHERE
    smig.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ'
  ORDER BY
    t.[Trade Mark Name]