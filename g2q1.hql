use uiuccapstonedb;

DROP TABLE IF EXISTS g2q1;

CREATE TABLE g2q1 (
  airport string, uniqueCarrier string, averageDelay double
) 
row format delimited fields terminated by ',' 
lines terminated by '\n' 
STORED AS TEXTFILE
LOCATION 's3://myuiuccca/capstoneTask1/results/g2q1/';

INSERT OVERWRITE TABLE g2q1
select Origin, UniqueCarrier, totalDelayCountPerAirport/totalFlightCountPerAirport AS averageDelayRatePerAirport
from
(select Origin, UniqueCarrier, SUM(DepDel15) AS totalDelayCountPerAirport, COUNT(*) AS totalFlightCountPerAirport
from airlineOnTime
group by Origin, UniqueCarrier) delayData
order by Origin, averageDelayRatePerAirport;
