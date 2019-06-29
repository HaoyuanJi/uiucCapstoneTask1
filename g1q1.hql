use uiuccapstonedb;

DROP TABLE IF EXISTS g1q1;

CREATE TABLE g1q1 (
  airport string, departureFlight int, arrivalFlight int, totalFlight int
) 
row format delimited fields terminated by ',' 
lines terminated by '\n' 
STORED AS TEXTFILE
LOCATION 's3://myuiuccca/capstoneTask1/results/g1q1/';

INSERT OVERWRITE TABLE g1q1
select Origin, OriginCount, DestCount, (OriginCount+DestCount) AS total from
(select Origin, COUNT(*) AS OriginCount from airlineOnTime group by Origin) originTable,
(select Dest, COUNT(*) AS DestCount from airlineOnTime group by Dest) DestTable
where originTable.Origin = DestTable.Dest
order by total DESC;
