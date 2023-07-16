# SQL-Daily-Lights
A log of all the expedite lights within the last 24hrs

# Create a daily report/vizualization for the expedite lights. To monitor the time length and figure out what parts are consistently running low.
# The query - create a query that'll show what plant called for the part, color code the severity of the part number, part number,date and time it was called in, time it was replenished and the duration of the light. All within the last 24hrs.

SELECT DISTINCT
CASE WHEN equipmentpath like 'LUCID\\\\\CG\\\\\GA%' then 'GA01'
	 when equipmentpath like 'LUCID\\\\\CG\\\\\BIW%' then 'BIW01'
	 when equipmentpath like 'LUCID\\\\\CG\\\\\PWT%' then 'PWT1'
	 when equipmentpath like 'LUCID\\\\\CG\\\\\PAINT%' then 'PAINT'
	 when equipmentpath like 'LUCID\\\\\CG\\\\\GILA%' then 'GILA'
	 else 'Null' end "Equipment Path",
case when severity = 1 then 'Red'
	 when severity = 2 then 'Yellow'
	 when severity = 3 then 'Blue' end "Light",
partnumber,
left(calldatetime,19) "Call Date Time",
left(replenishmentdatetime,19) " Replenishment Date Time",
right(left(to_timestamp(DATEDIFF(second,calldatetime,replenishmentdatetime),'ss'),19),8) "Light Duration"
from raw_data_ignition.enterprise_tblpartshortagecalllog et
where severity in ('1','2','3')
and calldatetime >= dateadd(hour,-24,getdate())
order by "Equipment Path",light desc,calldatetime desc

# I then passed this query to SSRS and Tableau. I created an automated excel report using SSRS, that sends out every weekday at 3pm to supervisors and managers for their daily meetings at 3:30pm. In Tableau I used it to create a vizualization of the part numbers that are being called the most.
