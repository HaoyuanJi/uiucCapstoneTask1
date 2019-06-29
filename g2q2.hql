use uiuccapstonedb;

DROP TABLE IF EXISTS g2q2;

CREATE TABLE g2q2 (
  airport string, dest string, averageDelay double
) 
STORED BY 'org.apache.hadoop.hive.dynamodb.DynamoDBStorageHandler'
TBLPROPERTIES(
    "dynamodb.table.name" = "g2q2",
    "dynamodb.column.mapping"="airport:Airport,dest:Dest,averageDelay:AverageDelay"
);

INSERT OVERWRITE TABLE g2q2
select Origin, Dest, totalDelayCountPerDest/totalFlightCountPerDest AS averageDelayRatePerDest
from
(select Origin, Dest, SUM(DepDel15) AS totalDelayCountPerDest, COUNT(*) AS totalFlightCountPerDest
from airlineOnTime
group by Origin, Dest) delayData
order by Origin, averageDelayRatePerDest;
