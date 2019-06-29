use uiuccapstonedb;

DROP TABLE IF EXISTS g2q4;

CREATE TABLE g2q4 (
  airport string, Dest string, averageDelayMinutes double
) 
STORED BY 'org.apache.hadoop.hive.dynamodb.DynamoDBStorageHandler'
TBLPROPERTIES(
    "dynamodb.table.name" = "g2q4",
    "dynamodb.column.mapping"="airport:Airport,dest:Dest,averageDelayMinutes:AverageDelayMinutes"
);

INSERT OVERWRITE TABLE g2q4
select Origin, Dest, totalDelayMinutesPerDest/totalFlightCountPerDest AS averageDelayMinutesPerDest
from
(select Origin, Dest, SUM(DepDelayMinutes) AS totalDelayMinutesPerDest, COUNT(*) AS totalFlightCountPerDest
from airlineOnTime
group by Origin, Dest) delayData
order by Origin, averageDelayMinutesPerDest;
