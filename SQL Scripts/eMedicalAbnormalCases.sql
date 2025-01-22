USE [MiMOSAUPGRADE];


SELECT DISTINCT(cm.[MemberNo])
      ,CAST(cms.[StartDate] AS DATE) StartDate
      ,CAST(cms.[CompletionDate] AS DATE) CompletionDate
      ,DATENAME(year,[CompletionDate]) Completion_Year
      ,DATENAME(month,[CompletionDate]) Completion_Month
      ,cms.[Status]
      ,CAST(cms.[CreatedDate] AS DATE) CreatedDate
      ,cms.[CreatedBy]
      ,cms.[mission]
      ,cm.[Gender]
      ,cm.[MigrantType]
      ,cm.[LastName]
      ,cm.[FirstName]
      ,cm.[MiddleName]
      ,(DATEDIFF(year,cm.[BirthDate],cms.[CreatedDate])) Age
      ,act.[ProjectDefinition]
      ,act.[ServiceCode]
      ,ed.[PanelSite]
      ,CONVERT(INT, cmmc.[A_Class]) [A_Class]
      ,CONVERT(INT, cmmc.[A_Tuberculosis]) [A_Tuberculosis]
      ,CONVERT(INT, cmmc.[A_SyphilisUntreated]) [A_SyphilisUntreated]
      ,CONVERT(INT, cmmc.[A_Gonorrhea]) [A_Gonorrhea]
      ,CONVERT(INT, cmmc.[A_Hansens]) [A_Hansens]
      ,CONVERT(INT, cmmc.[A_Addiction]) [A_Addiction]
      ,CONVERT(INT, cmmc.[A_AnyPhysicalMental]) [A_AnyPhysicalMental]
      ,CONVERT(INT, cmmc.[A_RefuseVaccinations]) [A_RefuseVaccinations]
      ,CONVERT(INT, cmmc.[B_Class]) [B_Class]
      ,CONVERT(INT, cmmc.[B_Pulmonary]) [B_Pulmonary]
      ,CONVERT(INT, cmmc.[B_Extrapulmonary]) [B_Extrapulmonary]
      ,CONVERT(INT, cmmc.[B_LTBIEvaluation]) [B_LTBIEvaluation]
      ,CONVERT(INT, cmmc.[B_ContactEvaluation]) [B_ContactEvaluation]
      ,CONVERT(INT, cmmc.[B_SyphilisTreated]) [B_SyphilisTreated]
      ,CONVERT(INT, cmmc.[B_GonorrheaTreated]) [B_GonorrheaTreated]
      ,CONVERT(INT, cmmc.[B_AnyPhysicalMental]) [B_AnyPhysicalMental]
      ,CONVERT(INT, cmmc.[B_SustainedAddiction]) [B_SustainedAddiction]
      ,CONVERT(INT, cmmc.[B_Multibacillary]) [B_Multibacillary]
      ,CONVERT(INT, cmmc.[B_Paucibacillary]) [B_Paucibacillary]
      ,CONVERT(INT, cmmc.[B_Others]) [B_Others]
      ,CONVERT(INT, cmmc.[B_HIV]) [B_HIV]
	  ,CONVERT(INT, cmmc.[B_STI]) [B_STI]
      ,CONVERT(INT, cmmc.[B_HepB]) [B_HepB]
      ,CONVERT(INT, cmmc.[B_HepC]) [B_HepC]
  FROM [MiMOSAUPGRADE].[dbo].[CaseMemberMedicalService] AS cms
  LEFT OUTER JOIN [dbo].[CaseMemberMed_Classification] AS cmmc
  ON  cmmc.[CaseMemberID] = cms.[CaseMemberID]
  INNER JOIN [MiMOSAUPGRADE].[dbo].[CaseMember] AS cm
  ON cms.[CaseMemberID] = cm.[CaseMemberID]
  LEFT OUTER JOIN [MiMOSAUPGRADE].[dbo].[CaseMemberMed_ExamDetails] AS ed
  ON ed.[CaseMemberID] = cm.[CaseMemberID]
  LEFT OUTER JOIN [MiMOSAUPGRADE].[dbo].[Activity] AS act
  ON  cm.[CaseNo] = act.[CaseNo]
  --LEFT OUTER JOIN  [dbo].[CaseMemberMed_TBClassification] AS cmtb
  --ON  cmtb.[CaseNo] = act.[CaseNo]
  WHERE cms.[mission] ='NG10'  AND act.[ActivityCode] ='MED' AND (cmmc.[B_Class]=1 OR cmmc.[A_Class]=1);