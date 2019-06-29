use uiuccapstonedb;

DROP TABLE IF EXISTS g2q1;

CREATE EXTERNAL TABLE g2q1 (
  airport string, uniqueCarrier string, averageDelay double
) 
STORED BY 'org.apache.hadoop.hive.dynamodb.DynamoDBStorageHandler'
TBLPROPERTIES(
    "dynamodb.table.name" = "g2q1",
    "dynamodb.column.mapping"="airport:Airport,uniqueCarrier:UniqueCarrier,averageDelay:AverageDelay"
);

INSERT OVERWRITE TABLE g2q1
select Origin, UniqueCarrier, totalDelayCountPerAirport/totalFlightCountPerAirport AS averageDelayRatePerAirport
from
(select Origin, UniqueCarrier, SUM(DepDel15) AS totalDelayCountPerAirport, COUNT(*) AS totalFlightCountPerAirport
from airlineOnTime
group by Origin, UniqueCarrier) delayData
order by Origin, averageDelayRatePerAirport;
