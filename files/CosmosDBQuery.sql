SELECT TOP 100 c.id
,c.devicename
,c.eventtime
,c.fahreheit
,c.humidity
,c.pressure
,c.accelerometerx
,c.accelerometery
,c.accelerometerz
,c.isspikeanddipanomaly

FROM c

where c.deviceid = '@{variables('CosmosQuery')}'

order by c.eventtime desc