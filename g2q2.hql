use uiuccapstonedb;

DROP TABLE IF EXISTS g2q2;

CREATE TABLE g2q2 (
  airport string, dest string, averageDelay double
) 
row format delimited fields terminated by ',' 
lines terminated by '\n' 
STORED AS TEXTFILE
LOCATION 's3://myuiuccca/capstoneTask1/results/g2q2/';

INSERT OVERWRITE TABLE g2q2
select Origin, Dest, totalDelayCountPerDest/totalFlightCountPerDest AS averageDelayRatePerDest
from
(select Origin, Dest, SUM(DepDel15) AS totalDelayCountPerDest, COUNT(*) AS totalFlightCountPerDest
from airlineOnTime
group by Origin, Dest) delayData
order by Origin, averageDelayRatePerDest;
