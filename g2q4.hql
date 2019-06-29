use uiuccapstonedb;

DROP TABLE IF EXISTS g2q4;

CREATE TABLE g2q4 (
  airport string, Dest string, averageDelayMinutes double
) 
row format delimited fields terminated by ',' 
lines terminated by '\n' 
STORED AS TEXTFILE
LOCATION 's3://myuiuccca/capstoneTask1/results/g2q4/';

INSERT OVERWRITE TABLE g2q4
select Origin, Dest, totalDelayMinutesPerDest/totalFlightCountPerDest AS averageDelayMinutesPerDest
from
(select Origin, Dest, SUM(DepDelayMinutes) AS totalDelayMinutesPerDest, COUNT(*) AS totalFlightCountPerDest
from airlineOnTime
group by Origin, Dest) delayData
order by Origin, averageDelayMinutesPerDest;
