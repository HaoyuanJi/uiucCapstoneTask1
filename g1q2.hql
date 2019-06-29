use uiuccapstonedb;

DROP TABLE IF EXISTS g1q2;

CREATE TABLE g1q2 (
  uniqueCarrier string, averageDelay double
) 
row format delimited fields terminated by ',' 
lines terminated by '\n' 
STORED AS TEXTFILE
LOCATION 's3://myuiuccca/capstoneTask1/results/g1q2/';

INSERT OVERWRITE TABLE g1q2
select UniqueCarrier, totalDelayFlights/totalFlightCount AS delayRate
from
(select UniqueCarrier, SUM(ArrDel15) AS totalDelayFlights, COUNT(*) AS totalFlightCount
from airlineOnTime
group by UniqueCarrier) delayData
order by delayRate;
