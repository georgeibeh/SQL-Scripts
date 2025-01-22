use mimosaupgrade

Declare @RevisedStatus table (
RADimension nvarchar(50)
,RAstatus nvarchar(50)
,StatusDescription nvarchar(50)
,RevisedStatus nvarchar(50)
,RevisedDescription nvarchar(50)
);

Insert into @RevisedStatus (RADimension, RAstatus, StatusDescription, RevisedStatus, RevisedDescription) values
('CHC','CAN','Cancelled','CAN','Cancelled')
,('CHC','CPL','Completed','CPL','Completed')
,('CHC','NRC','Not Received','CAN','Cancelled')
,('CHC','ONG','Ongoing','INP','In Process')
,('CHC','RCV','Received','CPL','Completed')
,('CHC','REG','Registered','CPL','Completed')
,('CHC','REQ','Requested','REQ','Requested')
,('CHC','UNK','Unknown','INP','In Process')
,('CHC','INP','In Process','INP','In Process')
,('EDU','CAN','Cancelled','CAN','Cancelled')
,('EDU','CPL','Completed','CPL','Completed')
,('EDU','DRP','Drop Out','CAN','Cancelled')
,('EDU','NST','Not Started','REQ','Requested')
,('EDU','ONG','Ongoing','INP','In Process')
,('EDU','REQ','Requested','REQ','Requested')
,('EDU','UNK','Unknown','INP','In Process')
,('EDU','INP','In Process','INP','In Process')
,('FIN','CPL','Completed','CPL','Completed')
,('FIN','REQ','Requested','REQ','Requested')
,('FIN','SNR','Subsidy Not Received','CAN','Cancelled')
,('FIN','SPR','Subsidy Partially Received','INP','In Process')
,('FIN','SRC','Subsidy Received','CPL','Completed')
,('FIN','UNK','Unknown','INP','In Process')
,('FIN','INP','In Process','INP','In Process')
,('HOS','ANR','Accommodation Not Remodelled','CAN','Cancelled')
,('HOS','ARM','Accommodation Remodelled','CPL','Completed')
,('HOS','CPL','Completed','CPL','Completed')
,('HOS','MVO','Moved Out','CAN','Cancelled')
,('HOS','PRC','Placed at Reception Center','CPL','Completed')
,('HOS','PSH','Placed at Shelter','CPL','Completed')
,('HOS','REQ','Requested','REQ','Requested')
,('HOS','RPD','Rent Paid','CPL','Completed')
,('HOS','RUP','Rent Unpaid','CAN','Cancelled')
,('HOS','TAP','Temporary Accommodation Paid','CPL','Completed')
,('HOS','UNK','Unknown','INP','In Process')
,('HOS','INP','In Process','INP','In Process')
,('JOB','CLS','Company Closed','CPL','Completed')
,('JOB','CPL','Completed','CPL','Completed')
,('JOB','CTE','Contract Ended','CPL','Completed')
,('JOB','DIS','Dismissed','CPL','Completed')
,('JOB','JSO','Job Search Ongoing','INP','In Process')
,('JOB','JSU','Job Search Unsuccessful','CPL','Completed')
,('JOB','NOS','No Show','CAN','Cancelled')
,('JOB','NST','Not Started','REQ','Requested')
,('JOB','REQ','Requested','REQ','Requested')
,('JOB','RES','Resigned','CPL','Completed')
,('JOB','UNK','Unknown','INP','In Process')
,('JOB','WRK','Working','CPL','Completed')
,('JOB','INP','In Process','INP','In Process')
,('LEG','ASP','Assistance Provided','CPL','Completed')
,('LEG','CAN','Cancelled','CAN','Cancelled')
,('LEG','CPL','Completed','CPL','Completed')
,('LEG','FPD','Fees Paid','CPL','Completed')
,('LEG','REQ','Requested','REQ','Requested')
,('LEG','UNK','Unknown','INP','In Process')
,('LEG','INP','In Process','INP','In Process')
,('MAT','CAN','Cancelled','CAN','Cancelled')
,('MAT','CPL','Completed','CPL','Completed')
,('MAT','NOS','No Show','CAN','Cancelled')
,('MAT','PRC','Partially Received','INP','In Process')
,('MAT','RCV','Received','CPL','Completed')
,('MAT','REQ','Requested','REQ','Requested')
,('MAT','UNK','Unknown','INP','In Process')
,('MAT','INP','In Process','INP','In Process')
,('MES','CAN','Cancelled','CAN','Cancelled')
,('MES','CPL','Completed','CPL','Completed')
,('MES','IRX','In Treatment','INP','In Process')
,('MES','NOS','No Show','CAN','Cancelled')
,('MES','NST','Not Started','REQ','Requested')
,('MES','REQ','Requested','REQ','Requested')
,('MES','RXC','Treatment Completed','CPL','Completed')
,('MES','INP','Treatment In Process','INP','In Process')
,('MIC','CAN','Cancelled','CAN','Cancelled')
,('MIC','CHB','Changed Business','CPL','Completed')
,('MIC','CLD','Closed Down','CPL','Completed')
,('MIC','CPL','Completed','CPL','Completed')
,('MIC','INP','In Process','INP','In Process')
,('MIC','NST','Not Started','REQ','Requested')
,('MIC','ONG','Ongoing','INP','In Process')
,('MIC','REQ','Requested','REQ','Requested')
,('MIC','SLD','Sold','CPL','Completed')
,('MIC','UNK','Unknown','INP','In Process')
,('OTH','CAN','Cancelled','CAN','Cancelled')
,('OTH','CPL','Completed','CPL','Completed')
,('OTH','ONG','Ongoing','INP','In Process')
,('OTH','REQ','Requested','REQ','Requested')
,('OTH','UNK','Unknown','INP','In Process')
,('OTH','INP','In Process','INP','In Process')
,('PSY','CAN','Cancelled','CAN','Cancelled')
,('PSY','CPL','Completed','CPL','Completed')
,('PSY','IRX','In Treatment','INP','In Process')
,('PSY','NOS','No Show','CAN','Cancelled')
,('PSY','NST','Not Started','REQ','Requested')
,('PSY','REQ','Requested','REQ','Requested')
,('PSY','RXC','Treatment Completed','CPL','Completed')
,('PSY','INP','In Process','INP','In Process')
,('REC','CAN','Cancelled','CAN','Cancelled')
,('REC','CPL','Completed','CPL','Completed')
,('REC','NOS','No Show','CAN','Cancelled')
,('REC','ONG','Ongoing','INP','In Process')
,('REC','REQ','Requested','REQ','Requested')
,('REC','UNK','Unknown','INP','In Process')
,('REC','INP','In Process','INP','In Process')
,('SEC','CAN','Cancelled','CAN','Cancelled')
,('SEC','CPL','Completed','CPL','Completed')
,('SEC','ONG','Ongoing','INP','In Process')
,('SEC','REQ','Requested','REQ','Requested')
,('SEC','UNK','Unknown','INP','In Process')
,('SEC','INP','In Process','INP','In Process')
,('SOC','CAN','Cancelled','CAN','Cancelled')
,('SOC','CPL','Completed','CPL','Completed')
,('SOC','ONG','Ongoing','INP','In Process')
,('SOC','REG','Registered','CPL','Completed')
,('SOC','REQ','Requested','REQ','Requested')
,('SOC','UNK','Unknown','INP','In Process')
,('SOC','INP','In Process','INP','In Process')
,('SON','CAN','Cancelled','CAN','Cancelled')
,('SON','CPL','Completed','CPL','Completed')
,('SON','ONG','Ongoing','INP','In Process')
,('SON','REQ','Requested','REQ','Requested')
,('SON','UNK','Unknown','INP','In Process')
,('SON','INP','In Process','INP','In Process')
,('TRG','CAN','Cancelled','CAN','Cancelled')
,('TRG','CPL','Completed','CPL','Completed')
,('TRG','DRP','Drop Out','CAN','Cancelled')
,('TRG','NST','Not Started','INP','In Process')
,('TRG','ONG','Ongoing','INP','In Process')
,('TRG','REQ','Requested','REQ','Requested')
,('TRG','UNK','Unknown','INP','In Process')
,('TRG','INP','In Process','INP','In Process');

drop table if exists tempdb.dbo.#WCARAdata
create table #WCARAdata (
CaseWorker nvarchar (max)
,caseno nvarchar(50)
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
,ReintegrationMission nvarchar(50)
,ReintegrationPlanActivityNo nvarchar(max)
,Activity nvarchar(50)
,ActivityLevel nvarchar(50)
,Dimension nvarchar(max)
,Activitystatus nvarchar(50)
,Location nvarchar(255)
,Latitude nvarchar(25)
,Longtitude nvarchar(25)
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
,CounsellingStatus nvarchar(50)
,CounsellingStartDate date
,CounsellingEndDate date
);

Insert into #WCARAdata
select distinct 
m.CaseWorker
,cm.caseno
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
,ra.Location
,ra.Latitude
,ra.longtitude
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

,[dbo].[udf_lookupdescription_get] (couns.status) CounsellingStatus
,cast (couns.startdate as date) CounsellingStartDate
,cast (couns.enddate as date) CounsellingEndDate


from casemember cm (nolock)

inner join ReintegrationPlanActivityCaseMember rm
on cm.CaseMemberID=rm.CaseMemberID

inner join reintegrationplanactivity ra
on ra.reintegrationplanactivityno=rm.reintegrationplanactivityno

inner join migrantcase m
on m.caseno=cm.caseno

left join MigrantCaseCounselling couns
on couns.caseno=m.caseno

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

where cm.isrevoke =0
and m.isrevoke=0
and cm.MigrantType <> 'NM'
and couns.processtype ='RICNSL'
and couns.sessionno= 1
and cm.registrationdate >= '2017-01-01'
--and m.ReferralDate between '2018-01-01' and '2018-12-31'
and ra.activitylevel='post'
and ra.isrevoke =0
and ROO.regiongroupid=1
and RHH.regiongroupid=1



and ra.ReintegrationMission ='NG10'
;
drop table if exists tempdb.dbo.#Customfields
Create Table #Customfields (
Caseno nvarchar(50)
,GroupNo nvarchar(50)
,FieldName nvarchar(max)
,Description nvarchar(max)
,Value nvarchar(max)
,mission nvarchar(50)
);

Insert into #Customfields
select distinct 
mcust.Caseno
,Custlist.GroupNo
,Custlist.FieldName
,Cust.Description
,mcust.Value
,mcust.mission

from MigrantCaseCustomFieldValue mcust
inner join CustomFieldList Cust
on mcust.FieldNo= Cust.FieldNo
inner join CustomField Custlist
on Custlist.FieldNo=Cust.FieldNo
where mcust.mission='NG10'
and Custlist.GroupNo = 'NG102020391835'


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
,CounsellingStatus nvarchar(50)
,RAStartrank int
,DimensionStartRank int
,LastDateModified date
,LastUpdatedBy nvarchar(50)
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
,d.CounsellingStatus
,rank() over (partition by d.ReintegrationMission, d.MemberNo order by d.PlannedDate asc ) as RAStartrank
,rank() over (partition by d.ReintegrationMission, d.MemberNo,d.Dimension order by d.PlannedDate asc ) as DimensionStartRank
,d.LastDateModified 
,d.LastUpdatedBy


From #WCARAdata d
Inner join @RevisedStatus rev
on d.Activitystatus=Rev.StatusDescription;

Declare @ProcessStart table 
(MemberNo nvarchar(50)
,SocialStart date
,EconomicStart date
,PysStart date
,FirstActivityDate date
,FirstRAProject nvarchar(50))
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
,LastUpdatedBy nvarchar(50)
,FirstUpdatedBy nvarchar(50)
);

Insert into  @ConcatsRA
select distinct 
dm.MemberNo
,dbo.GROUP_CONCAT_DS(distinct dm.Activity + ' - ' + dm.Activitystatus ,'; ', 1) as ReintegrationActivities
,dbo.GROUP_CONCAT_DS(distinct dm.ProjectDefinition,'; ', 1) as Projects
,dbo.GROUP_CONCAT_DS(distinct dm.Programme,'; ', 1) as Programme
,dbo.GROUP_CONCAT_DS(distinct dm.Activitystatus,'; ', 1) as RAStatus
,max (dm.PlannedDate) LastActivityDate
,(select top 1 dm.ProjectDefinition from #Dimensionstart DM where dm.MemberNo=d.MemberNo and dm.PlannedDate= max(d.PlannedDate)) LastRAProject
,(select top 1 dm.LastUpdatedBy from #Dimensionstart DM where dm.MemberNo=d.MemberNo and dm.LastDateModified= max(d.LastDateModified)) LastUpdatedBy
,(select top 1 dm.LastUpdatedBy from #Dimensionstart DM where dm.MemberNo=d.MemberNo and dm.LastDateModified= min(d.LastDateModified)) FirstUpdatedBy



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



declare @Categories table (
MemberNo nvarchar(50)
,GlobalStatus nvarchar(50)
,Category1 nvarchar(50)
,Category2 nvarchar(50)
,Category3 nvarchar(50)
);

Insert into @Categories
Select distinct 
CRA.MemberNo

,Case when exists (select 1 from @ConcatsRA CRA where (CRA.RAStatus = 'Completed' OR CRA.RAStatus = 'Cancelled; Completed') and d.MemberNo=CRA.MemberNo)
and not exists (select 1 from @ConcatsRA CRA where CRA.RAStatus like 'Requested' and CRA.RAStatus like 'In Process' and d.MemberNo=CRA.MemberNo) Then 'Completed'
 
 When exists (select 1 from @ConcatsRA CRA where CRA.RAStatus like 'Requested'  and d.MemberNo=CRA.MemberNo)
 and not exists (select 1 from @ConcatsRA CRA where CRA.RAStatus not like 'Requested' and d.MemberNo=CRA.MemberNo)then 'Pending Assistance' 
 
 Else 'Pending Completion' end as GlobalStatus

,Case when exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities = 'Reception Assistance - Completed' and d.MemberNo=CRA.MemberNo) 
and not exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities <> 'Reception Assistance - Completed' and d.MemberNo=CRA.MemberNo) then 'Reception only'
Else 'N/A' end as Category1

,Case When exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities not like '%Financial Services%' and CRA.ReintegrationActivities not like '%Microbusiness%'and CRA.ReintegrationActivities not like '%Training%' and CRA.ReintegrationActivities not like '%Job Placement%' and d.MemberNo=CRA.MemberNo)
and not exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities like '%Financial Services%'and CRA.ReintegrationActivities like '%Microbusiness%' and CRA.ReintegrationActivities like '%Training%' and CRA.ReintegrationActivities like '%Job Placement%' and d.MemberNo=CRA.MemberNo)  then 'No economic support'
Else 'N/A' end as Category2

,Case When exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities  like '%Training%' and d.MemberNo=CRA.MemberNo)
and exists (select 1 from @ConcatsRA CRA where CRA.ReintegrationActivities not like '%Microbusiness%' and CRA.ReintegrationActivities not like '%Job Placement%' and d.MemberNo=CRA.MemberNo) then 'Training only'
Else 'N/A' end as Category3

From @ConcatsRA CRA
inner join #WCARAdata d
on d.MemberNo=CRA.MemberNo;

Select distinct
custF.Value as 'Custom CaseWorker'
,d.CaseWorker as 'MAD CaseWorker'
,CRA.FirstUpdatedBy
,CRA.LastUpdatedBy
,d.caseno
,d.MemberNo 
,d.primaryrefno
,d.secondaryreferenceno
,d.Lastname
,d.Firstname
,d.ReferralDate
,d.Gender
,d.BirthDate
,d.AgeAtReferral
,d.MigrantType
,d.HostRegion
,d.HostCountry
,d.RegionofOrigin
,d.CountryofOrigin
,d.Nationality
,d.ReintegrationMission
,CRA.ReintegrationActivities
,CRA.Projects
,CRA.Programme
,CRA.RAStatus
,d.Counsellingstatus
,d.CounsellingStartDate
,d.CounsellingEndDate
,d.Location
,d.Latitude
,d.longtitude
,d.ActivityDescription
,p.SocialStart 
,p.EconomicStart 
,p.PysStart
,p.FirstRAProject
,CRA.LastRAProject
,p.FirstActivityDate
,CRA.LastActivityDate
,cat.GlobalStatus
,cat.Category1
,cat.Category2
,cat.Category3



from #WCARAdata d
inner join @ProcessStart p
on p.MemberNo=d.MemberNo
 inner join @ConcatsRA CRA
 on CRA.MemberNo = d.MemberNo
 inner join @Categories Cat
 on cat.MemberNo= d.MemberNo
 left join #Customfields custF
 on custF.Caseno=d.CaseNo
