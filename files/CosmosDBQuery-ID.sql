SELECT c.id
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

where c.id = '@{variables('CosmosQuery')}'