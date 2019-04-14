WITH Telemetry AS 
(

--MX Chip Telemetry Data
SELECT
	Stream.IoTHub.ConnectionDeviceId as DeviceID,
	Ref.msdyn_name as DeviceName,
    Ref.msdyn_iotdeviceid as iotdeviceid,
	System.TimeStamp AS EventTime, --This is based on TIMESTAMP BY IoTHub.EnqueuedTime which is the time the message was placed in IoTHub
	Ref._msdyn_account_value as accountid,
	AVG(Ref.cfs_latitude) as Latitude, 
	AVG(Ref.cfs_longitude) as Longitude,
	AVG(((Stream.temp*1.8)+(32-7))) as Fahreheit,
	AVG(Stream.humidity) as Humidity,
	AVG(Stream.pressure) as Pressure,
	MIN(Stream.accelerometerX) as AccelerometerX,
	MIN(Stream.accelerometerY) as AccelerometerY,
	MIN(Stream.accelerometerZ) as AccelerometerZ

FROM
	IoTStream Stream TIMESTAMP BY IoTHub.EnqueuedTime
	JOIN IotDeviceReference Ref 
	ON Stream.IoTHub.ConnectionDeviceId = Ref.msdyn_deviceid
WHERE
    Stream.temp IS NOT NULL
	
GROUP BY Ref._msdyn_account_value, Stream.IoTHub.ConnectionDeviceId, Ref.msdyn_name, Ref.msdyn_iotdeviceid, TumblingWindow(second, 15)
),

AnomalyDetectionStep AS (
SELECT
	*,
    system.timestamp as anomalyDetectionStepTimestamp,
	AnomalyDetection_SpikeAndDip(Fahreheit, 99, 20, 'spikesanddips') OVER(LIMIT DURATION(mi, 10)) as SpikeAndDipScores
FROM Telemetry
)


-- Send summarized data to CosmosDB
SELECT 
    DeviceID,
	DeviceName,
	EventTime,
    iotdeviceid,
	accountid,
	Latitude, 
    Longitude,
	Fahreheit,
	Humidity,
	Pressure,
    AccelerometerX,
	AccelerometerY,
	AccelerometerZ,
	CAST(GetRecordPropertyValue(SpikeAndDipScores, 'Score') as float) as SpikeAndDipScore, 
	CAST(GetRecordPropertyValue(SpikeAndDipScores, 'IsAnomaly') as bigint) as IsSpikeAndDipAnomaly

INTO CosmosDB
FROM AnomalyDetectionStep