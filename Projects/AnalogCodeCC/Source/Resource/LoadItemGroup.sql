SELECT
  smg.Code + ' ' + smg.[Description] AS CodeName,
  smg.parentid,
  smg.nodeid
FROM
  [%company$Item Group] smg
WHERE
  smg.[Item Group Type Code] = '“Œ¬À»Õ»ﬂ' AND
  smg.[Level] IN (0, 1)
ORDER BY
  smg.nodeid