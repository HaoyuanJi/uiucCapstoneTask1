use uiuccapstonedb;

DROP TABLE IF EXISTS g3q2;

CREATE EXTERNAL TABLE g3q2 (
  itenarary string, flightDate string, firstFlightNum string, secondFlightNum string, totalDelay double
) 
STORED BY 'org.apache.hadoop.hive.dynamodb.DynamoDBStorageHandler'
TBLPROPERTIES(
    "dynamodb.table.name" = "g3q2",
    "dynamodb.column.mapping"="itenarary:Itenarary,flightDate:FlightDate,firstFlightNum:FirstFlightNum,secondFlightNum:SecondFlightNum,totalDelay:TotalDelay"
);

INSERT OVERWRITE TABLE g3q2
select concat(a.Origin, "-", a.Dest, "-", b.Dest) AS Itinerary, a.FlightDate AS FlightDate, a.FlightNum, b.FlightNum,a.ArrDelayMinutes+b.ArrDelayMinutes AS TotalDelay
from
(select FlightNum,Origin,Dest,CAST(FlightDate AS date),CRSDepTime,ArrDelayMinutes
 from airline2008 
 where CRSDepTime<"\"1200\"" 
  AND (Origin="\"CMI\"" OR Origin="\"JAX\"" OR Origin="\"SLC\"" OR Origin="\"LAX\"" OR Origin="\"DFW\"")
  AND (Dest="\"ORD\"" OR Dest="\"DFW\"" OR Dest="\"BFL\"" OR Dest="\"SFO\"")
  AND (FlightDate="2008-04-03" OR FlightDate="2008-09-09" OR FlightDate="2008-01-04" OR FlightDate="2008-12-07" OR FlightDate="2008-10-06" OR FlightDate="2008-01-01")) a left join
(select FlightNum,Origin,Dest,CAST(FlightDate AS date),CRSDepTime,ArrDelayMinutes
 from airline2008 
 where CRSDepTime>"\"1200\""
 AND (Origin="\"ORD\"" OR Origin="\"DFW\"" OR Origin="\"BFL\"" OR Origin="\"SFO\"")
 AND (Dest="\"LAX\"" OR Dest="\"CRP\"" OR Dest="\"PHX\"" OR Dest="\"DFW\"" OR Dest="\"JFK\"")
 AND (FlightDate="2008-04-05" OR FlightDate="2008-09-11" OR FlightDate="2008-01-06" OR FlightDate="2008-12-09" OR FlightDate="2008-10-08" OR FlightDate="2008-01-03")) b on a.Dest=b.Origin
 where
 b.FlightDate=date_add(a.FlightDate,2)
 order by Itinerary,FlightDate,TotalDelay;
