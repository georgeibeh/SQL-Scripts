use mimosaupgrade

Declare @RevisedStatus table (
RADimension nvarchar(50)
,RAstatus nvarchar(50)
,StatusDescription nvarchar(50)
,RevisedStatus nvarchar(50)
,RevisedDescription nvarchar(50)
);

Insert into @RevisedStatus (RADimension, RAstatus, StatusDescription, RevisedStatus, RevisedDescription) values
('CHC','NCP','Not Completed','CAN','Cancelled')
,('CHC','CPL','Completed','CPL','Completed')
,('CHC','INP','In Process','INP','In Process')
,('CHC','REQ','Requested','REQ','Requested')
,('EDU','NCP','Not Completed','CAN','Cancelled')
,('EDU','CPL','Completed','CPL','Completed')
,('EDU','REQ','Requested','REQ','Requested')
,('EDU','INP','In Process','INP','In Process')
,('FIN','CPL','Completed','CPL','Completed')
,('FIN','REQ','Requested','REQ','Requested')
,('FIN','INP','In Process','INP','In Process')
,('FIN','NCP','Not Completed','CAN','Cancelled')
,('HOS','CPL','Completed','CPL','Completed')
,('HOS','NCP','Not Completed','CAN','Cancelled')
,('HOS','REQ','Requested','REQ','Requested')
,('HOS','INP','In Process','INP','In Process')
,('JOB','CPL','Completed','CPL','Completed')
,('JOB','NCP','Not Completed','CAN','Cancelled')
,('JOB','REQ','Requested','REQ','Requested')
,('JOB','INP','In Process','INP','In Process')
,('LEG','NCP','Not Completed','CAN','Cancelled')
,('LEG','CPL','Completed','CPL','Completed')
,('LEG','REQ','Requested','REQ','Requested')
,('LEG','INP','In Process','INP','In Process')
,('MAT','NCP','Not Completed','CAN','Cancelled')
,('MAT','CPL','Completed','CPL','Completed')
,('MAT','REQ','Requested','REQ','Requested')
,('MAT','INP','In Process','INP','In Process')
,('MES','NCP','Not Completed','CAN','Cancelled')
,('MES','CPL','Completed','CPL','Completed')
,('MES','REQ','Requested','REQ','Requested')
,('MES','INP','In Process','INP','In Process')
,('MIC','NCP','Not Completed','CAN','Cancelled')
,('MIC','CPL','Completed','CPL','Completed')
,('MIC','INP','In Process','INP','In Process')
,('MIC','REQ','Requested','REQ','Requested')
,('OTH','NCP','Not Completed','CAN','Cancelled')
,('OTH','CPL','Completed','CPL','Completed')
,('OTH','REQ','Requested','REQ','Requested')
,('OTH','INP','In Process','INP','In Process')
,('PSY','NCP','Not Completed','CAN','Cancelled')
,('PSY','CPL','Completed','CPL','Completed')
,('PSY','REQ','Requested','REQ','Requested')
,('PSY','INP','In Process','INP','In Process')
,('REC','NCP','Not Completed','CAN','Cancelled')
,('REC','CPL','Completed','CPL','Completed')
,('REC','REQ','Requested','REQ','Requested')
,('REC','INP','In Process','INP','In Process')
,('SEC','NCP','Not Completed','CAN','Cancelled')
,('SEC','CPL','Completed','CPL','Completed')
,('SEC','REQ','Requested','REQ','Requested')
,('SEC','INP','In Process','INP','In Process')
,('SOC','NCP','Not Completed','CAN','Cancelled')
,('SOC','CPL','Completed','CPL','Completed')
,('SOC','REQ','Requested','REQ','Requested')
,('SOC','INP','In Process','INP','In Process')
,('SON','NCP','Not Completed','CAN','Cancelled')
,('SON','CPL','Completed','CPL','Completed')
,('SON','REQ','Requested','REQ','Requested')
,('SON','INP','In Process','INP','In Process')
,('TRG','NCP','Not Completed','CAN','Cancelled')
,('TRG','CPL','Completed','CPL','Completed')
,('TRG','REQ','Requested','REQ','Requested')
,('TRG','INP','In Process','INP','In Process');


drop table if exists tempdb.dbo.#ReturnData
create table #ReturnData (
caseno nvarchar(50)
,MemberNo nvarchar(50)
,primaryrefno nvarchar(50)
,secondaryreferenceno nvarchar(50)
,Lastname nvarchar (max)
,Firstname nvarchar (max)
,ReferralDate date
,Gender nvarchar(50)
,BirthDate date
,AgeAtReferral Int
,MigrantType nvarchar(max)
,HostRegion nvarchar(max)
,HostCountry nvarchar(max)
,RegionofOrigin nvarchar(max)
,CountryofOrigin nvarchar(max)
,Nationality nvarchar(max)
,CounsellingStatus nvarchar(50)
,CounsellingStartDate date
,CounsellingEndDate date
,RecordSource nvarchar(50)
,MovPoject nvarchar(50)
,MovProgramme nvarchar(50)
,ArrivalDate date
,VOTs nvarchar(50)
,UMINOR nvarchar(50)
,Detention nvarchar(50)
,PhoneNo nvarchar (max)
,City nvarchar (max)
,AddressLine1 nvarchar (max)
,AddressLine2 nvarchar (max)
,FinalDestination nvarchar (max)
,AVMProcessStatus nvarchar(50)
,AVMProcessresult nvarchar(50)
);

Insert into #ReturnData
----Movement records
Select distinct 
cm.caseno
,cm.MemberNo
,m.primaryrefno
,m.secondaryreferenceno 
,cm.lastname
,cm.firstname
,Cast (m.ReferralDate as date) ReferralDate
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as AgeAtReferral
,[dbo].[udf_lookupdescription_get] (cm.MigrantType) MigrationType



,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry

,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality

,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select top 1 [dbo].[udf_lookupdescription_get] (couns.status) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1) else 'No Counselling process' end as CounsellingStatus
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.startdate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingStartDate
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.enddate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingEndDate

,case
	when act.activitycode='MOV' then 'Movement record'
	Else 'Case without movement' 
	end as RecordSource

,left(mov.wbs,7) MovPoject 
,case when act.projectdefinition in (
'RT.1366'
,'RT.1363'
,'RT.1367'
,'RT.1352'
,'RT.1351'
,'RT.1364'
,'RT.1341'
,'RT.1353'
,'RT.1359'
,'TC.1028'
,'RT.1345'
,'RT.1258'
,'RT.1340'
,'RT.1362'
,'RT.1400'
,'RT.1500'
,'RT.1354'
,'CT.1064'
,'RA.0091'
,'RA.0076'
,'RR.0070') then 'JI' else 'Non-JI' end as MovProgramme 
,cast (mov.poearrivaldate as date ) ArrivalDate
,case 
	when cm.category in ('VOT', 'VOTIIOM', 'VOTNOIOM') then 'Yes'
	When exists(select 1 from CaseMemberAdditionalMigrantClassification cla 
	where cla.AdditionalMigrantClassification in ('VOT', 'VOTIIOM', 'VOTNOIOM')
	and cla.casememberid=cm.casememberid
	and cla.isrevoked=0) then 'Yes'
	Else 'No'
	End as VOTs

,case 
	when cm.category='UMINOR' then 'Yes'
	when m.IsUnaccompaniedMinor=1 then 'Yes'
	when cla.AdditionalMigrantClassification = 'UMINOR' then 'Yes'
	Else 'No'
	End as UMINOR

,case
	when cm.category='DET' then 'Yes'
	When cla.AdditionalMigrantClassification = 'DET' then 'Yes'
	When exists (select 1 from CaseMemberAddress cma
	where cma.casememberid=cm.casememberid and addressline1 like '%detention%') then 'Yes'
	Else 'No'
	End as Detention
,ph.PhoneNo
,(select top 1 cma.City from CaseMemberAddress cma where cma.casememberid=cm.casememberid) City
,(select top 1 cma.AddressLine1 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine1
,(select top 1 cma.AddressLine2 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine2
,(select  ct.Description from City ct where ct.code=m.finaldestination) FinalDestination

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.status) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessStatus

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.Result) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessresult

from casemember cm (nolock)
inner join movementcases mc
on mc.Caseno=cm.caseno
inner join movement mov
on mc.pfno= mov.pfno
inner join migrantcase m
on m.caseno=cm.caseno

Inner join activity act
		on act.caseno=cm.CaseNo

left join MigrantCaseCounselling couns
on couns.caseno=m.caseno

left join MigrantAssistanceProcess p on p.caseno=m.caseno

left join country CO
on CO.code=m.destinationcountry

Left join regioncountry RO
on CO.code=RO.code

Left join regions ROO
 on ROO.code=RO.regions_code

left join country CH
on CH.code=m.locationcountry

Left join regioncountry RH
on CH.code=RH.code

Left join regions RHH
 on RHH.code=RH.regions_code

left join CaseMemberAdditionalMigrantClassification cla
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid


Where cm.isrevoke =0
and m.isrevoke =0
and act.isrevoke=0
and mov.EmPDepartureDate  >= '2017-01-01'
and mov.departurecountry <> mov.DestinationCountry
and mov.status='DEP'
and act.activitycode='MOV'
and ROO.regiongroupid=1
and RHH.regiongroupid=1
and m.DestinationCountry ='NG'


Insert into #ReturnData
----Cases without movements	
Select distinct 
cm.caseno
,cm.MemberNo
,m.primaryrefno
,m.secondaryreferenceno 
,cm.lastname
,cm.firstname
,Cast (m.ReferralDate as date) ReferralDate
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as AgeAtReferral
,[dbo].[udf_lookupdescription_get] (cm.MigrantType) MigrationType



,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry

,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality

,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select top 1 [dbo].[udf_lookupdescription_get] (couns.status) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1) else 'No Counselling process' end as CounsellingStatus
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.startdate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingStartDate
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.enddate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingEndDate

,case
	when m.locationcountry IN ('NE', 'BF') and cmi.confirmedArrivalDate  is not null then 'Movement record'
		when mnote.notes like '%Imported%Movement%' OR mnote.notes like '%Imported%case%' OR mnote.notes like '%Forced return from Algeria to Mali before the AVR%' then 'Movement record'
			when cm.MigrantType = 'PR' then 'Forced Return' Else 'Case without movement' 
	end as 'Record source'

,act.projectdefinition MovPoject 
,case when act.projectdefinition in (
'RT.1366'
,'RT.1363'
,'RT.1367'
,'RT.1352'
,'RT.1351'
,'RT.1364'
,'RT.1341'
,'RT.1353'
,'RT.1359'
,'TC.1028'
,'RT.1345'
,'RT.1258'
,'RT.1340'
,'RT.1362'
,'RT.1400'
,'RT.1500'
,'RT.1354'
,'CT.1064'
,'RA.0091'
,'RA.0076'
,'RR.0070') then 'JI' else 'Non-JI' end as MovProgramme 
,Case when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.DestinationCountry ='NE' and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate is null then cast (m.Referraldate as date )
	when m.locationcountry not IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (m.Referraldate as date )
	else cast (m.Referraldate as date ) end as 'Arrival date'

,case 
	when cm.category in ('VOT', 'VOTIIOM', 'VOTNOIOM') then 'Yes'
	When exists(select 1 from CaseMemberAdditionalMigrantClassification cla 
	where cla.AdditionalMigrantClassification in ('VOT', 'VOTIIOM', 'VOTNOIOM')
	and cla.casememberid=cm.casememberid
	and cla.isrevoked=0) then 'Yes'
	Else 'No'
	End as VOTs

,case 
	when cm.category='UMINOR' then 'Yes'
	when m.IsUnaccompaniedMinor=1 then 'Yes'
	when cla.AdditionalMigrantClassification = 'UMINOR' then 'Yes'
	Else 'No'
	End as UMINOR

,case
	when cm.category='DET' then 'Yes'
	When cla.AdditionalMigrantClassification = 'DET' then 'Yes'
	When exists (select 1 from CaseMemberAddress cma
	where cma.casememberid=cm.casememberid and addressline1 like '%detention%') then 'Yes'
	Else 'No'
	End as Detention

	,ph.PhoneNo
,(select top 1 cma.City from CaseMemberAddress cma where cma.casememberid=cm.casememberid) City
,(select top 1 cma.AddressLine1 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine1
,(select top 1 cma.AddressLine2 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine2
,(select  top 1 ct.Description from City ct where ct.code=m.finaldestination) FinalDestination

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.status) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessStatus

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.Result) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessresult

 from MigrantCase m (nolock)
inner join CaseMember cm
       on cm.CaseNo = m.CaseNo
Inner join activity act
		on act.caseno=cm.CaseNo

  left join MigrantcaseNotes mnote
on mnote.caseno=m.caseno

Left join CaseMemberOtherInfo cmi
	   on cmi.casememberID=cm.casememberID

left join MigrantCaseCounselling couns
on couns.caseno=m.caseno

left join MigrantAssistanceProcess p on p.caseno=m.caseno

left join country CO
on CO.code=m.destinationcountry

Left join regioncountry RO
on CO.code=RO.code

Left join regions ROO
 on ROO.code=RO.regions_code

left join country CH
on CH.code=m.locationcountry

Left join regioncountry RH
on CH.code=RH.code

Left join regions RHH
 on RHH.code=RH.regions_code

left join CaseMemberAdditionalMigrantClassification cla
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid

where m.LocationCountry <> m.DestinationCountry
and cm.registrationdate >= '2017-01-01'
and cm.isrevoke =0
and m.isrevoke =0
and act.isrevoke=0
and ROO.regiongroupid=1
and RHH.regiongroupid=1
and not exists (select 1 from activity act where act.caseno=cm.caseno and act.activitycode='MOV' and act.isrevoke=0)
and exists (select 1 from activity act where act.caseno=cm.caseno and act.activitycode='MAD' and act.isrevoke=0)
--and act.activitycode='MAD'
and m.globalcasestatus IN ('Active', 'Hold')

and m.DestinationCountry ='NG'



Insert into #ReturnData
----Not assigned movements	
Select distinct 
cm.caseno
,cm.MemberNo
,m.primaryrefno
,m.secondaryreferenceno 
,cm.lastname
,cm.firstname
,Cast (m.ReferralDate as date) ReferralDate
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as AgeAtReferral
,[dbo].[udf_lookupdescription_get] (cm.MigrantType) MigrationType



,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry

,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality

,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select top 1 [dbo].[udf_lookupdescription_get] (couns.status) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1) else 'No Counselling process' end as CounsellingStatus
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.startdate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingStartDate
,Case when exists (select 1 from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)
	then (select  top 1 cast (couns.enddate as date) from MigrantCaseCounselling couns
	where couns.caseno=m.caseno and couns.processtype ='RICNSL' and couns.sessionno= 1)  else ' ' end as CounsellingEndDate

,case
	when m.locationcountry IN ('NE', 'BF') and cmi.confirmedArrivalDate  is not null then 'Movement record'
		when mnote.notes like '%Imported%Movement%' OR mnote.notes like '%Imported%case%' OR mnote.notes like '%Forced return from Algeria to Mali before the AVR%' then 'Movement record'
			when cm.MigrantType = 'PR' then 'Forced Return' Else 'Case without movement' 
	end as 'Record source'

,act.projectdefinition MovPoject 
,case when act.projectdefinition in (
'RT.1366'
,'RT.1363'
,'RT.1367'
,'RT.1352'
,'RT.1351'
,'RT.1364'
,'RT.1341'
,'RT.1353'
,'RT.1359'
,'TC.1028'
,'RT.1345'
,'RT.1258'
,'RT.1340'
,'RT.1362'
,'RT.1400'
,'RT.1500'
,'RT.1354'
,'CT.1064'
,'RA.0091'
,'RA.0076'
,'RR.0070') then 'JI' else 'Non-JI' end as MovProgramme 
,Case when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.DestinationCountry ='NE' and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate is null then cast (m.Referraldate as date )
	when m.locationcountry not IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (m.Referraldate as date )
	else cast (m.Referraldate as date ) end as 'Arrival date'

,case 
	when cm.category in ('VOT', 'VOTIIOM', 'VOTNOIOM') then 'Yes'
	When exists(select 1 from CaseMemberAdditionalMigrantClassification cla 
	where cla.AdditionalMigrantClassification in ('VOT', 'VOTIIOM', 'VOTNOIOM')
	and cla.casememberid=cm.casememberid
	and cla.isrevoked=0) then 'Yes'
	Else 'No'
	End as VOTs

,case 
	when cm.category='UMINOR' then 'Yes'
	when m.IsUnaccompaniedMinor=1 then 'Yes'
	when cla.AdditionalMigrantClassification = 'UMINOR' then 'Yes'
	Else 'No'
	End as UMINOR

,case
	when cm.category='DET' then 'Yes'
	When cla.AdditionalMigrantClassification = 'DET' then 'Yes'
	When exists (select 1 from CaseMemberAddress cma
	where cma.casememberid=cm.casememberid and addressline1 like '%detention%') then 'Yes'
	Else 'No'
	End as Detention

	,ph.PhoneNo
,(select top 1 cma.City from CaseMemberAddress cma where cma.casememberid=cm.casememberid) City
,(select top 1 cma.AddressLine1 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine1
,(select top 1 cma.AddressLine2 from CaseMemberAddress cma where cma.casememberid=cm.casememberid) AddressLine2
,(select  top 1 ct.Description from City ct where ct.code=m.finaldestination) FinalDestination

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.status) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessStatus

,Case when exists (select 1 from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM')
	then (select top 1 [dbo].[udf_lookupdescription_get] (p.Result) from MigrantAssistanceProcess p
	where p.caseno=m.caseno and p.processtype ='SCRAVM') else 'No AVM process' end as AVMProcessresult

 from MigrantCase m (nolock)
inner join CaseMember cm
       on cm.CaseNo = m.CaseNo
Inner join activity act
		on act.caseno=cm.CaseNo

  left join MigrantcaseNotes mnote
on mnote.caseno=m.caseno

Left join CaseMemberOtherInfo cmi
	   on cmi.casememberID=cm.casememberID

left join MigrantCaseCounselling couns
on couns.caseno=m.caseno

left join MigrantAssistanceProcess p on p.caseno=m.caseno

left join country CO
on CO.code=m.destinationcountry

Left join regioncountry RO
on CO.code=RO.code

Left join regions ROO
 on ROO.code=RO.regions_code

left join country CH
on CH.code=m.locationcountry

Left join regioncountry RH
on CH.code=RH.code

Left join regions RHH
 on RHH.code=RH.regions_code

left join CaseMemberAdditionalMigrantClassification cla
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid

where m.LocationCountry <> m.DestinationCountry
and cm.registrationdate >= '2017-01-01'
and cm.isrevoke =0
and m.isrevoke =0
and ROO.regiongroupid=1
and RHH.regiongroupid=1
and act.activitycode='MOV'
and act.status='NAS'
and m.globalcasestatus IN ('Active', 'Hold')

and m.DestinationCountry ='NG'


drop table if exists tempdb.dbo.#WCARAdata
create table #WCARAdata (

caseno nvarchar(50)
,MemberNo nvarchar(50)
,primaryrefno nvarchar(50)
,secondaryreferenceno nvarchar(50)
,ReintegrationMission nvarchar(50)
,ReintegrationPlanActivityNo nvarchar(max)
,Activity nvarchar(50)
,ActivityLevel nvarchar(50)
,Dimension nvarchar(max)
,Activitystatus nvarchar(50)
,Deliveredby nvarchar(50)
,PlannedDate date
,CreatedDate date
,CreatedBy nvarchar(50)
,LastDateModified date
,LastUpdatedBy nvarchar(50)
,ActivityDescription nvarchar(max)
,OtherDescription nvarchar(max)
,ProjectDefinition nvarchar(max)
,Programme nvarchar(max)

);

Insert into #WCARAdata
select distinct 
cm.caseno
,cm.MemberNo
,m.primaryrefno
,m.secondaryreferenceno
,ra.ReintegrationMission
,ra.ReintegrationPlanActivityNo
,[dbo].[udf_lookupdescription_bylookupgroup_get] (ra.AssistanceActivity, 'AssistanceActivity') Activity
,[dbo].[udf_lookupdescription_bylookupgroup_get] (ra.BeneficiaryType,'BeneficiaryLevel') ActivityLevel

,Case
	When ra.AssistanceActivity in ('CHC', 'EDU', 'HOS', 'LEG', 'MES', 'SOC') then 'Social Support'
	When ra.AssistanceActivity in ('FIN', 'MIC', 'TRG', 'JOB') then 'Economic Support'
	When ra.AssistanceActivity in ('PSY', 'SEC') then 'Psychosocial Support'
	Else 'Others' End as Dimension

,[dbo].[udf_lookupdescription_get] (ra.Status)  Activitystatus
,[dbo].[udf_lookupdescription_get] (deliveredby) Deliveredby
,Case when ra.PlannedDate is null then '2017-01-01' else cast (ra.PlannedDate as date) End as PlannedDate
,cast (ra.CreatedDate as date) CreatedDate
,ra.CreatedBy
,cast (ra.LastDateModified as date) LastDateModified
,ra.LastUpdatedBy
,ra.ActivityDescription
,ra.OtherDescription
,Case when ra.ProjectDefinition is null then 'No project code' else upper (ra.ProjectDefinition) end as ProjectDefinition
,Case when ra.ProjectDefinition in (
'RT.1366'
,'RT.1363'
,'RT.1367'
,'RT.1352'
,'RT.1351'
,'RT.1364'
,'RT.1341'
,'RT.1353'
,'RT.1359'
,'TC.1028'
,'RT.1345'
,'RT.1258'
,'RT.1340'
,'RT.1362'
,'RT.1400'
,'RT.1500'
,'RT.1354'
,'CT.1064'
,'RA.0091'
,'RA.0076'
,'RR.0070') then 'JI' else 'Non JI' end as Programme



from casemember cm (nolock)

inner join ReintegrationPlanActivityCaseMember rm
on cm.CaseMemberID=rm.CaseMemberID

inner join reintegrationplanactivity ra
on ra.reintegrationplanactivityno=rm.reintegrationplanactivityno

inner join migrantcase m
on m.caseno=cm.caseno



where cm.isrevoke =0
and m.isrevoke=0
and cm.MigrantType <> 'NM'
and m.globalcasestatus IN ('Active', 'Hold')
and cm.registrationdate >= '2017-01-01'
--and m.ReferralDate between '2017-01-01' and '2017-12-31'
and ra.activitylevel='post'
and ra.isrevoke =0
--and cla.IsRevoked=0


and m.DestinationCountry ='NG'



drop table if exists tempdb.dbo.#Dimensionstart
Create Table #Dimensionstart (
MemberNo nvarchar(50)
,ReintegrationMission nvarchar(max)
,ReintegrationPlanActivityNo nvarchar(max)
,Activity nvarchar(50)
,ActivityLevel nvarchar(50)
,Dimension nvarchar(50)
,Activitystatus nvarchar(max)
,PlannedDate date
,ProjectDefinition nvarchar(50)
,Programme nvarchar(max)
,RAStartrank int
,DimensionStartRank int
);

Insert into #Dimensionstart
select distinct 
d.MemberNo
,d.ReintegrationMission
,d.ReintegrationPlanActivityNo
,d.Activity
,d.ActivityLevel
,d.Dimension
,case when d.Activitystatus=Rev.StatusDescription then rev.RevisedDescription else d.Activitystatus end as Activitystatus
,d.PlannedDate
,d.ProjectDefinition 
,d.Programme
,rank() over (partition by d.ReintegrationMission, d.MemberNo order by d.PlannedDate asc ) as RAStartrank
,rank() over (partition by d.ReintegrationMission, d.MemberNo,d.Dimension order by d.PlannedDate asc ) as DimensionStartRank


From #WCARAdata d
left join @RevisedStatus rev
on d.Activitystatus=Rev.StatusDescription;

Declare @ProcessStart table 
(MemberNo nvarchar(50)
,SocialStart date
,EconomicStart date
,PysStart date
,FirstActivityDate date
,FirstRAProject nvarchar(50)
)
;

Insert into @ProcessStart
Select distinct dm.MemberNo
,(select top 1 dm.PlannedDate from #Dimensionstart DM  where dm.MemberNo=d.MemberNo and DimensionStartRank=1 and dm.Dimension='Social Support') SocialStart
,(select top 1 dm.PlannedDate from #Dimensionstart DM where dm.MemberNo=d.MemberNo and DimensionStartRank=1 and dm.Dimension='Economic Support') EconomicStart
,(select top 1 dm.PlannedDate from #Dimensionstart DM where dm.MemberNo=d.MemberNo and DimensionStartRank=1 and dm.Dimension='Psychosocial Support') PysStart
,(select top 1 dm.PlannedDate from #Dimensionstart DM where dm.MemberNo=d.MemberNo and RAStartrank=1) FirstActivityDate
,(select top 1 dm.ProjectDefinition from #Dimensionstart DM where dm.MemberNo=d.MemberNo and RAStartrank=1) FirstRAProject

from #Dimensionstart DM inner join #WCARAdata d on dm.MemberNo=d.MemberNo; 

Declare @ConcatsRA table (
MemberNo nvarchar(50)
,ReintegrationActivities nvarchar(max)
,Projects nvarchar(max)
,Programme nvarchar(max)
,RAStatus nvarchar(max)
,LastActivityDate date
,LastRAProject nvarchar(50)
--,ActivityLevel nvarchar(max)
--,Dimension nvarchar(max)
);

Insert into  @ConcatsRA
select distinct 
dm.MemberNo
,dbo.GROUP_CONCAT_DS(distinct dm.Activity + ' - ' + dm.ActivityLevel + ' - ' + dm.Activitystatus,'; ', 1) as ReintegrationActivities
,dbo.GROUP_CONCAT_DS(distinct dm.ProjectDefinition,'; ', 1) as Projects
,dbo.GROUP_CONCAT_DS(distinct dm.Programme,'; ', 1) as Programme
,dbo.GROUP_CONCAT_DS(distinct dm.Activitystatus,'; ', 1) as RAStatus
,max (dm.PlannedDate) LastActivityDate
,(select top 1 dm.ProjectDefinition from #Dimensionstart DM where dm.MemberNo=d.MemberNo and dm.PlannedDate= max(d.PlannedDate)) LastRAProject
--,dbo.GROUP_CONCAT_DS(distinct dm.ActivityLevel,'; ', 1) as ActivityLevel
--,dbo.GROUP_CONCAT_DS(distinct dm.Dimension + ' - ' + dm.ActivityLevel,'; ', 1) as Dimension


from #Dimensionstart DM
inner join #WCARAdata d
on dm.MemberNo= d.MemberNo
inner join @RevisedStatus rev
on dm.Activitystatus=Rev.RevisedDescription
where
dm.MemberNo= d.MemberNo
and dm.Activity= d.Activity
and dm.Activitystatus= rev.RevisedDescription
group by dm.MemberNo, d.MemberNo;


Declare @Concatstable table (
MemberNo  nvarchar(50)
,Recordsource nvarchar(50)
,PhoneNo nvarchar (max)

);
Insert into @Concatstable
select distinct 
d.MemberNo
,dbo.GROUP_CONCAT_DS(distinct d.Recordsource,'; ', 1) as Recordsource
,dbo.GROUP_CONCAT_DS(distinct d.PhoneNo,'// ', 1) as PhoneNo

from #ReturnData d
group by d.MemberNo


declare @Categories table (
MemberNo nvarchar(50)
--,GlobalStatus nvarchar(50)
,Category1 nvarchar(50)
,Category2 nvarchar(50)
,Category3 nvarchar(50)
--,[Economic Support] nvarchar(50)
--,[Social Support] nvarchar(50)
--,[Psychosocial Support] nvarchar(50)
--,EcoSupportLevel nvarchar(50)
--,SocSupportLevel nvarchar(50)
--,PsySupportLevel nvarchar(50)
);

Insert into @Categories
Select distinct 
CRA.MemberNo

,Case when exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities = 'Reception Assistance - Completed' and d.MemberNo=CRA.MemberNo) 
and not exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities <> 'Reception Assistance - Completed' and d.MemberNo=CRA.MemberNo) then 'Reception only'
Else 'N/A' end as Category1

,Case When exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities not like '%Financial Services%' and CRA.ReintegrationActivities not like '%Microbusiness%'and CRA.ReintegrationActivities not like '%Training%' and CRA.ReintegrationActivities not like '%Job Placement%' and d.MemberNo=CRA.MemberNo)
and not exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities like '%Financial Services%'and CRA.ReintegrationActivities like '%Microbusiness%' and CRA.ReintegrationActivities like '%Training%' and CRA.ReintegrationActivities like '%Job Placement%' and d.MemberNo=CRA.MemberNo)  then 'No economic support'
Else 'N/A' end as Category2

,Case When exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities  like '%Training%' and d.MemberNo=CRA.MemberNo)
and exists (select 1 from #WCARAdata d where CRA.ReintegrationActivities not like '%Microbusiness%' and CRA.ReintegrationActivities not like '%Job Placement%' and d.MemberNo=CRA.MemberNo) then 'Training only'
Else 'N/A' end as Category3

--, case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support%' and d.MemberNo=CRA.MemberNo) then 'Yes' else 'No' end as [Economic Support]
--, case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support%' and d.MemberNo=CRA.MemberNo) then 'Yes' else 'No' end as [Social Support]
--, case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support%' and d.MemberNo=CRA.MemberNo) then 'Yes' else 'No' end as [Psychosocial Support]

--,Case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Collective; Economic Support - Community; Economic Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--		When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Community; Economic Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Collective; Economic Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Collective; Economic Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Collective'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Collective%' and d.MemberNo=CRA.MemberNo) then 'Collective' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Economic Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Individual'
--	else 'N/A' end as EcoSupportLevel



--,Case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Collective; Social Support - Community; Social Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Community; Social Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Collective; Social Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Collective; Social Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Collective'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Collective%' and d.MemberNo=CRA.MemberNo) then 'Collective' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Social Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Individual'
--	else 'N/A' end as SocSupportLevel

--,Case when exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Collective; Psychosocial Support - Community; Psychosocial Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Community; Psychosocial Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Collective; Psychosocial Support - Community%' and d.MemberNo=CRA.MemberNo) then 'Community'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Collective; Psychosocial Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Collective'
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Collective%' and d.MemberNo=CRA.MemberNo) then 'Collective' 
--	When exists (select 1 from @ConcatsRA CRA where cra.Dimension like '%Psychosocial Support - Individual%' and d.MemberNo=CRA.MemberNo) then 'Individual'
--	else 'N/A' end as PsySupportLevel


From #WCARAdata d 
left join @ConcatsRA CRA
on d.MemberNo=CRA.MemberNo;

Declare @ConsolidatedData table (
RecordSource nvarchar(50)
,MovPoject nvarchar(50)
,MovProgramme nvarchar(50)
,ArrivalDate Date
,caseno nvarchar(50)
,MemberNo nvarchar(50)
,primaryrefno nvarchar(50)
,secondaryreferenceno nvarchar(50)
,ReferralDate nvarchar(50)
,Gender nvarchar(50)
,BirthDate date
,AgeAtReferral int
,MigrantType nvarchar(50)
,HostRegion nvarchar(50)
,HostCountry nvarchar(50)
,RegionofOrigin nvarchar(50)
,CountryofOrigin nvarchar(50)
,Nationality nvarchar(50)
,ReintegrationMission nvarchar(50)
,ReintegrationActivities nvarchar(max)
,Projects nvarchar(max)
,Programme nvarchar(50)
,RAStatus nvarchar(max)
,Counsellingstatus nvarchar(50)
,CounsellingStartDate date
,CounsellingEndDate date
,SocialStart date
,EconomicStart date
,PysStart date
,FirstRAProject nvarchar(50)
,LastRAProject nvarchar(50)
,FirstActivityDate date
,LastActivityDate date
,VOTs nvarchar(50)
,UMINOR nvarchar(50)
,Detention nvarchar(50)
,Category1 nvarchar(50)
,Category2 nvarchar(50)
,Category3 nvarchar(50)
,PhoneNo nvarchar (max)
,City nvarchar (max)
,AddressLine1 nvarchar (max)
,AddressLine2 nvarchar (max)
,FinalDestination nvarchar (max)
,AVMProcessStatus nvarchar(50)
,AVMProcessresult nvarchar(50)
--,Dimension nvarchar (max)
--,[Economic Support] nvarchar (max)
--,EcoSupportLevel nvarchar (max)
--,[Social Support] nvarchar (max)
--,SocSupportLevel nvarchar (max)
--,[Psychosocial Support] nvarchar (max)
--,PsySupportLevel nvarchar (max)
);

Insert into @ConsolidatedData
Select distinct
concatR.RecordSource
,ret.MovPoject
,ret.MovProgramme
,ret.ArrivalDate
,ret.caseno
,ret.MemberNo 
,ret.primaryrefno
,ret.secondaryreferenceno
,ret.ReferralDate
,ret.Gender
,ret.BirthDate
,ret.AgeAtReferral
,ret.MigrantType
,ret.HostRegion
,ret.HostCountry
,ret.RegionofOrigin
,ret.CountryofOrigin
,ret.Nationality
,d.ReintegrationMission
,CRA.ReintegrationActivities
,CRA.Projects
,CRA.Programme
,CRA.RAStatus
,ret.Counsellingstatus
,ret.CounsellingStartDate
,ret.CounsellingEndDate
,p.SocialStart 
,p.EconomicStart 
,p.PysStart
,p.FirstRAProject
,CRA.LastRAProject
,p.FirstActivityDate
,CRA.LastActivityDate
,ret.VOTs
,ret.UMINOR
,ret.Detention
,cat.Category1
,cat.Category2
,cat.Category3
,concatR.PhoneNo
,ret.City
,ret.AddressLine1 
,ret.AddressLine2
,ret.FinalDestination
,ret.AVMProcessStatus
,ret.AVMProcessresult
--,cra.Dimension
--,cat.[Economic Support]
--,cat.EcoSupportLevel
--,cat.[Social Support]
--,cat.SocSupportLevel
--,cat.[Psychosocial Support]
--,cat.PsySupportLevel


from #ReturnData ret
inner join @Concatstable concatR
on concatR.MemberNo= ret.MemberNo
left join #WCARAdata d
on d.MemberNo=ret.MemberNo
left join @ProcessStart p
on p.MemberNo=d.MemberNo
 left join @ConcatsRA CRA
 on CRA.MemberNo = d.MemberNo
 left join @Categories Cat
 on cat.MemberNo= d.MemberNo

 Select distinct 
 Case when dat.RecordSource='Case without movement; Movement record' or dat.RecordSource='Movement record' then 'Movement record' else 'Case without movement' end as RecordSource
,dat.MovPoject
,dat.MovProgramme
,dat.ArrivalDate
,dat.caseno
,dat.MemberNo 
,dat.primaryrefno
,dat.secondaryreferenceno
,dat.ReferralDate
,dat.Gender
,dat.BirthDate
,dat.AgeAtReferral
,dat.MigrantType
,dat.HostRegion
,dat.HostCountry
,dat.RegionofOrigin
,dat.CountryofOrigin
,dat.Nationality
,dat.ReintegrationMission
,dat.ReintegrationActivities
,dat.Projects
,dat.Programme
,dat.RAStatus
,dat.Counsellingstatus
,dat.CounsellingStartDate
,dat.CounsellingEndDate
,dat.SocialStart 
,dat.EconomicStart 
,dat.PysStart
,dat.FirstRAProject
,dat.LastRAProject
,dat.FirstActivityDate
,dat.LastActivityDate
,dat.VOTs
,dat.UMINOR
,dat.Detention
,dat.PhoneNo
,dat.City
,dat.AddressLine1 
,dat.AddressLine2
,dat.FinalDestination
,dat.AVMProcessStatus
,dat.AVMProcessresult
--,dat.Dimension
--,dat.[Economic Support]
--,dat.EcoSupportLevel
--,dat.[Social Support]
--,dat.SocSupportLevel
--,dat.[Psychosocial Support]
--,dat.PsySupportLevel

,Case when exists (select 1 from @ConsolidatedData dat where (dat.RAStatus = 'Completed' OR dat.RAStatus = 'Cancelled; Completed') and ret.MemberNo=dat.MemberNo)
and not exists (select 1 from @ConsolidatedData where dat.RAStatus like 'Requested' and dat.RAStatus like 'In Process' and ret.MemberNo=dat.MemberNo) Then 'Completed'
 
 When exists (select 1 from @ConsolidatedData dat where (dat.RAStatus = 'Requested' OR dat.RAStatus is null) and ret.Counsellingstatus ='completed' and ret.MemberNo=dat.MemberNo)
and not exists (select 1 from @ConsolidatedData where (dat.RAStatus <> 'Requested' OR dat.RAStatus is not null) and ret.Counsellingstatus <>'completed' and ret.MemberNo=dat.MemberNo) then 'Pending Assistance'
 
 When exists (select 1 from @ConsolidatedData dat where (dat.RAStatus is null OR dat.RAStatus ='Requested')  and (ret.Counsellingstatus ='Requested' or ret.Counsellingstatus ='In process' or ret.Counsellingstatus ='No Counselling process')  and ret.MemberNo=dat.MemberNo)
 and not exists (select 1 from @ConsolidatedData dat where ((dat.RAStatus is not null OR dat.RAStatus <>'Requested' )and (ret.Counsellingstatus <>'Requested'  or ret.Counsellingstatus <>'In process') and ret.MemberNo=dat.MemberNo)) then 'Pending Counselling'

 When exists (select 1 from @ConsolidatedData dat where dat.RAStatus='Cancelled' and ret.Counsellingstatus ='completed' and ret.MemberNo=dat.MemberNo)
 and not exists (select 1 from @ConsolidatedData dat where dat.RAStatus <> 'Cancelled' and ret.Counsellingstatus <>'completed' and ret.MemberNo=dat.MemberNo)then 'Early Discontinuation'

  When exists (select 1 from @ConsolidatedData dat where dat.RAStatus is null and ret.Counsellingstatus ='Not completed' and ret.MemberNo=dat.MemberNo)
 and not exists (select 1 from @ConsolidatedData dat where dat.RAStatus is not null and ret.Counsellingstatus <>'Not completed' ) then 'Drop out'
 
 Else 'Pending Completion' end as GlobalStatus

 ,dat.Category1
,dat.Category2
,dat.Category3

 from @ConsolidatedData dat
 inner join #ReturnData ret
 on ret.memberno= dat.MemberNo