select distinct 
case when equipmentpath like 'LUCID\\\\\CG\\\\\GA%' then 'GA01'
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