use mimosaupgrade
drop table if exists tempdb.dbo.#WCAReturns
create table #WCAReturns (
[Project Definition] nvarchar(50)
,[MOV WBS] nvarchar(50)
,PFNo nvarchar(50)
,[Record source] nvarchar(50)
,[Mov Programme] nvarchar(15)
,HostRegion nvarchar(100)
,RegionofOrigin nvarchar(100)
,HostCountry nvarchar(50)
,CountryofOrigin nvarchar(50)
,[Arrival date] date
,CaseNo nvarchar(50)
,MemberNo nvarchar(50)
,PrimaryRefNo nvarchar(50)
,secondaryreferenceno nvarchar(50)
,Lastname nvarchar (max)
,Firstname nvarchar (max)
,BirthDate date
,[Age at referral] bigint
,AgeRange nvarchar (25)
,Gender nvarchar(10)
,Nationality nvarchar(50)
,[Migration Type] nvarchar(50)
,RegistrationDate date
,Referraldate date
,ManagingMission nvarchar(50)
,CostID nvarchar(50)
,[Cost Project] nvarchar(50)
,[DA Programme] nvarchar(50)
,PayingMission nvarchar(50)
,CostItem nvarchar(max)
,Remarks nvarchar(max)
,CostDate date
,[DA type] nvarchar(50)
,VOTs nvarchar(50)
,UMINOR nvarchar(50)
,Detention nvarchar(50)
,COVID19Return nvarchar(50)
, [IsMassMovement] nvarchar(10)
,PhoneNo nvarchar (max)
,City nvarchar (max)
,AddressLine1 nvarchar (max)
,AddressLine2 nvarchar (max)
,FinalDestination nvarchar (max)
,AVMProcessStatus nvarchar(50)
,AVMProcessresult nvarchar(50)
);

Insert into #WCAReturns
----Movement records
select distinct 
left(mov.wbs,7) 'Project Definition'
,mov.WBS [MOV WBS]
,mov.PFNo
,case
	when act.activitycode='MOV' then 'Movement record'
	Else 'Case without movement' 
	end as 'Record source'
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'Mov Programme'
,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion
,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,cast (mov.poearrivaldate as date ) as 'Arrival date'
,cm.CaseNo
,cm.MemberNo
,m.PrimaryRefNo
,m.secondaryreferenceno
,cm.lastname
,cm.firstname
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as 'Age at referral'
,case 
	when [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)< 18 then 'Children'
	When [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)>=18 then 'Adult'
	end as AgeRange
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality
,[dbo].[udf_lookupdescription_bylookupgroup_get]  (cm.MigrantType, 'Migrationtype') 'Migration Type'
,cast (cm.RegistrationDate as date) as RegistrationDate
,cast (m.Referraldate as date) as Referraldate
,m.ManagingMission
,c.CostID
,Left (c.WBS,7) 'Cost Project'
,case when Left (c.WBS,7) in (
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'DA Programme'
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (left(c.PayingMission,2))) PayingMission
,dbo.udf_lookupdescription_get(c.CostItem) as CostItem
,c.Remarks
,Cast (c.CostDate as date) as CostDate
,case when mov.DestinationCountry=left(c.PayingMission,2) then 'Reception assistance'
		when mov.departurecountry= left(c.PayingMission,2) then 'Pre-departure assistance'
		When mov.DestinationCountry <> left(c.PayingMission,2) and mov.departurecountry <> left(c.PayingMission,2) then 'HQ inputs' else 'No DA' end as 'DA type'

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

, Case when cm.category='COVID19' then 'Yes'
		when cla.AdditionalMigrantClassification = 'COVID19' then 'Yes'
	Else 'No'
	End as COVID19Return
	 	   
,mov.[IsMassMovement]

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

FROM casemember cm (nolock)
inner join movementcases mc
on mc.Caseno=cm.caseno
inner join movement mov
on mc.pfno= mov.pfno
inner join migrantcase m
on m.caseno=cm.caseno
left join country CO
on CO.code=m.destinationcountry

left join cost c
on c.casememberid= cm.casememberid

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid

left join MigrantAssistanceProcess p on p.caseno=m.caseno

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

 left join activity act
		on act.caseno=cm.CaseNo

left join CaseMemberAdditionalMigrantClassification cla 
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

Where cm.isrevoke =0
and m.isrevoke =0
and act.isrevoke=0
and mov.EmPDepartureDate  >= '2017-01-01'
and m.LocationCountry <> m.DestinationCountry
--and m.LocationCountry = 'NG'
and m.DestinationCountry ='NG'


and ROO.regiongroupid=1
and RHH.regiongroupid=1
and mov.status='DEP'
and act.activitycode='MOV'


Insert into #WCAReturns
----Cases without movements	
select distinct
act.projectdefinition 'Project Definition'
,'N/A' [MOV WBS]
,'No PFNo' PFNo
,case
	when m.locationcountry IN ('NE', 'BF') and cmi.confirmedArrivalDate  is not null then 'Movement record'
		when mnote.notes like '%Imported%Movement%' OR mnote.notes like '%Imported%case%' OR mnote.notes like '%Forced return from Algeria to Mali before the AVR%' then 'Movement record'
			when cm.MigrantType = 'PR' then 'Forced Return' Else 'Case without movement' 
	end as 'Record source'
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'Mov Programme'
,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion
,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,Case when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.DestinationCountry ='NE' and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate is null then cast (m.Referraldate as date )
	when m.locationcountry not IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (m.Referraldate as date )
	else cast (m.Referraldate as date ) end as 'Arrival date'
,cm.CaseNo
,cm.MemberNo
,m.PrimaryRefNo
,m.secondaryreferenceno
,cm.lastname
,cm.firstname
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as 'Age at referral'
,case 
	when [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)< 18 then 'Children'
	When [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)>=18 then 'Adult'
	end as AgeRange
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality
,[dbo].[udf_lookupdescription_bylookupgroup_get]  (cm.MigrantType, 'Migrationtype') 'Migration Type'
,cast (cm.RegistrationDate as date) as RegistrationDate
,cast (m.Referraldate as date) as Referraldate
,m.ManagingMission
,c.CostID
,Left (c.WBS,7) 'Cost Project'
,case when Left (c.WBS,7) in (
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'DA Programme'
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (left(c.PayingMission,2))) PayingMission
,dbo.udf_lookupdescription_get(c.CostItem) as CostItem
,c.Remarks
,Cast (c.CostDate as date) as CostDate
,case when m.DestinationCountry=left(c.PayingMission,2) then 'Reception assistance'
		when m.LocationCountry= left(c.PayingMission,2) then 'Pre-departure assistance'
		When m.DestinationCountry <> left(c.PayingMission,2) and m.LocationCountry <> left(c.PayingMission,2) then 'HQ inputs' else 'No DA' end as 'DA type'

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

, Case when cm.category='COVID19' then 'Yes'
		when cla.AdditionalMigrantClassification = 'COVID19' then 'Yes'
	Else 'No'
	End as COVID19Return

,'N/A' [IsMassMovement]

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
	   
	   from MigrantCase m (nolock)
inner join CaseMember cm
       on cm.CaseNo = m.CaseNo
Inner join activity act
		on act.caseno=cm.CaseNo

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid

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

Left join CaseMemberOtherInfo cmi
	   on cmi.casememberID=cm.casememberID

  left join MigrantcaseNotes mnote
on mnote.caseno=m.caseno

left join cost c
on c.casememberid= cm.casememberid

left join CaseMemberAdditionalMigrantClassification cla 
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

where m.LocationCountry <> m.DestinationCountry
and ROO.regiongroupid=1
and RHH.regiongroupid=1

--and m.LocationCountry = 'NG'
and m.DestinationCountry ='NG'


and m.RegistrationDate >= '2017-01-01'
and cm.isrevoke =0
and m.isrevoke =0
and act.isrevoke=0
and not exists (select 1 from activity act where act.caseno=cm.caseno and act.activitycode='MOV' and act.isrevoke=0 and cm.isrevoke =0)
and exists (select 1 from activity act where act.caseno=cm.caseno and act.activitycode='MAD' and act.isrevoke=0 and cm.isrevoke =0)
and act.activitycode='MAD'
and m.globalcasestatus IN ('Active', 'Hold')

Insert into #WCAReturns
----Cases without movements	
select distinct
act.projectdefinition 'Project Definition'
,'N/A' [MOV WBS]
,'No PFNo' PFNo
,case
	when m.locationcountry IN ('NE', 'BF') and cmi.confirmedArrivalDate  is not null then 'Movement record'
		when mnote.notes like '%Imported%Movement%' OR mnote.notes like '%Imported%case%' OR mnote.notes like '%Forced return from Algeria to Mali before the AVR%' then 'Movement record'
			when cm.MigrantType = 'PR' then 'Forced Return' Else 'Case without movement' 
	end as 'Record source'
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'Mov Programme'
,Case
	When RHH.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When RHH.description = 'European Economic Area - COs' then 'Europe'
	When RHH.description = 'Middle East and North Africa COs' then 'North Africa'
	When RHH.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as HostRegion
,Case
	When ROO.description ='Central and West Africa COs' then 'Sahel and Lake Chad'
	When ROO.description = 'European Economic Area - COs' then 'Europe'
	When ROO.description = 'Middle East and North Africa COs' then 'North Africa'
	When ROO.description = 'East and Horn of Africa COs' then 'Horn of Africa'
	Else 'Other' End as RegionofOrigin

,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.locationcountry)) HostCountry
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (m.destinationcountry)) CountryofOrigin
,Case when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.DestinationCountry ='NE' and cmi.confirmedArrivalDate  is not null then cast (cmi.confirmedArrivalDate as date )
	when m.locationcountry IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate is null then cast (m.Referraldate as date )
	when m.locationcountry not IN ('NE', 'MR', 'BF') and cmi.confirmedArrivalDate  is not null then cast (m.Referraldate as date )
	else cast (m.Referraldate as date ) end as 'Arrival date'
,cm.CaseNo
,cm.MemberNo
,m.PrimaryRefNo
,m.secondaryreferenceno
,cm.lastname
,cm.firstname
,cast (cm.BirthDate as date) as BirthDate
,[dbo].[udf_age] (cm.BirthDate, m.ReferralDate) as 'Age at referral'
,case 
	when [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)< 18 then 'Children'
	When [dbo].[udf_age] (cm.BirthDate, m.ReferralDate)>=18 then 'Adult'
	end as AgeRange
,[dbo].[udf_lookupdescription_get] (cm.gender) as Gender
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (cm.Nationality))  Nationality
,[dbo].[udf_lookupdescription_bylookupgroup_get]  (cm.MigrantType, 'Migrationtype') 'Migration Type'
,cast (cm.RegistrationDate as date) as RegistrationDate
,cast (m.Referraldate as date) as Referraldate
,m.ManagingMission
,c.CostID
,Left (c.WBS,7) 'Cost Project'
,case when Left (c.WBS,7) in (
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
,'RR.0070') then 'JI' else 'Non-JI' end as 'DA Programme'
,[dbo].[udf_propercase_get]([dbo].[udf_countrydescription_get] (left(c.PayingMission,2))) PayingMission
,dbo.udf_lookupdescription_get(c.CostItem) as CostItem
,c.Remarks
,Cast (c.CostDate as date) as CostDate
,case when m.DestinationCountry=left(c.PayingMission,2) then 'Reception assistance'
		when m.LocationCountry= left(c.PayingMission,2) then 'Pre-departure assistance'
		When m.DestinationCountry <> left(c.PayingMission,2) and m.LocationCountry <> left(c.PayingMission,2) then 'HQ inputs' else 'No DA' end as 'DA type'

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

, Case when cm.category='COVID19' then 'Yes'
		when cla.AdditionalMigrantClassification = 'COVID19' then 'Yes'
	Else 'No'
	End as COVID19Return

,'N/A' [IsMassMovement]

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

	   from MigrantCase m (nolock)
inner join CaseMember cm
       on cm.CaseNo = m.CaseNo
Inner join activity act
		on act.caseno=cm.CaseNo

Left join CaseMemberPhone ph
on ph.casememberid=cm.casememberid

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

Left join CaseMemberOtherInfo cmi
	   on cmi.casememberID=cm.casememberID

  left join MigrantcaseNotes mnote
on mnote.caseno=m.caseno

left join cost c
on c.casememberid= cm.casememberid

left join CaseMemberAdditionalMigrantClassification cla 
on cla.casememberid=cm.casememberid

left join CaseMemberAddress cma 
on cma.casememberid=cm.casememberid

where m.LocationCountry <> m.DestinationCountry
and ROO.regiongroupid=1
and RHH.regiongroupid=1
--and m.LocationCountry = 'NG'
and m.DestinationCountry ='NG'


and m.RegistrationDate >= '2017-01-01'
and cm.isrevoke =0
and m.isrevoke =0
and act.isrevoke=0
and act.activitycode='MOV'
and act.Status='NAS'
and m.globalcasestatus IN ('Active', 'Hold')

Declare @Concatstable table (
MemberNo  nvarchar(50)
,[Record source] nvarchar(50)
,[DA type] nvarchar(max)
,[Cost Project] nvarchar(max)
,[DA Programme] nvarchar(max)
,PayingMission nvarchar(max)
,VOTs nvarchar(50)
,UMINOR nvarchar(50)
,Detention nvarchar(50)
,COVID19Return nvarchar(50)
,CostItem nvarchar(max)
,PhoneNo nvarchar (max)
);

Insert into @Concatstable
select distinct 
d.MemberNo
,dbo.GROUP_CONCAT_DS(distinct d.[Record source],'; ', 1) as [Record source]
,dbo.GROUP_CONCAT_DS(distinct d.[DA type] + ' - ' +[Cost Project],'; ', 1) as [DA type]
,dbo.GROUP_CONCAT_DS(distinct d.[Cost Project],'; ', 1) as [Cost Project]
,dbo.GROUP_CONCAT_DS(distinct d.[DA Programme],'; ', 1) as [DA Programme]
,dbo.GROUP_CONCAT_DS(distinct d.PayingMission,'; ', 1) as PayingMission
,dbo.GROUP_CONCAT_DS(distinct d.VOTs,'; ', 1) as VOTs
,dbo.GROUP_CONCAT_DS(distinct d.UMINOR,'; ', 1) as UMINOR
,dbo.GROUP_CONCAT_DS(distinct d.Detention,'; ', 1) as Detention
,dbo.GROUP_CONCAT_DS(distinct d.COVID19Return,'; ', 1) as COVID19Return
,dbo.GROUP_CONCAT_DS(distinct d.CostItem + ' - ' +[Cost Project],'; ', 1) as CostItem
,dbo.GROUP_CONCAT_DS(distinct d.PhoneNo,'// ', 1) as PhoneNo

from #WCAReturns d
group by d.MemberNo

----Consolidated transit cases
Select distinct
[Project Definition]
,[MOV WBS]
,PFNo
,Case when dd.[Record source]='Case without movement; Movement record' or dd.[Record source]='Movement record' then 'Movement record' when dd.[Record source]='Forced Return' then 'Forced Return' else 'Case without movement' end as [Record source]
,[Mov Programme]
,[IsMassMovement]
,HostRegion
,RegionofOrigin
,HostCountry
,CountryofOrigin
,[Arrival date]
,CaseNo
,d.MemberNo
,PrimaryRefNo
,secondaryreferenceno
,lastname
,firstname
,BirthDate
,[Age at referral]
,AgeRange
,Gender
,Nationality
,[Migration Type]
,RegistrationDate
,Referraldate
,ManagingMission
,dd.[Cost Project]
,dd.[DA Programme]
,dd.PayingMission
,dd.[DA type]
,dd.CostItem
,Case when dd.VOTs='No; Yes' OR dd.VOTs='Yes' then 'Yes'  else 'No' end as VOTs
,Case when dd.UMINOR= 'No; Yes' OR dd.UMINOR= 'Yes' then 'Yes' else 'No' end as UMINOR
,Case when dd.Detention= 'No; Yes' OR dd.Detention= 'Yes' then 'Yes' else 'No' end as Detention
,Case when dd.COVID19Return= 'No; Yes' OR dd.COVID19Return= 'Yes' then 'Yes' else 'No' end as COVID19Return
,dd.PhoneNo
,City
,AddressLine1
,AddressLine2
,FinalDestination
,AVMProcessStatus
,AVMProcessresult

from #WCAReturns d
inner join @Concatstable dd
on d.MemberNo=dd.MemberNo