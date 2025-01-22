SELECT  distinct cm.[MemberNo]
      ,cms.[CaseMemberMedicalServiceID]
      ,cms.[CaseMemberID]
      ,cms.[StartDate]
      ,cms.[EstimatedCompletionDate]
      ,cms.[CompletionDate]
	  ,DATENAME(month,[CompletionDate]) Completion_Month
      ,cms.[MedServiceCode]
      ,cms.[MedServiceDescription]
      ,cms.[Status]
      ,cms.[CreatedDate]
      ,cms.[CreatedBy]
      ,cms.[LastDateModified]
      ,cms.[LastUpdateBy]
      ,cms.[mission]
      ,cm.[LastName]
      ,cm.[FirstName]
      ,cm.[MiddleName]
      ,cm.[BirthDate]
      ,cm.[CaseNo]
      ,act.[ProjectDefinition]
      ,act.[ServiceCode]
  FROM [MiMOSAUPGRADE].[dbo].[CaseMemberMedicalService] AS cms
  INNER JOIN [MiMOSAUPGRADE].[dbo].[CaseMember] AS cm
  ON cms.[CaseMemberID] = cm.[CaseMemberID]
  LEFT OUTER JOIN [MiMOSAUPGRADE].[dbo].[Activity] AS act
  ON  cm.[CaseNo] = act.[CaseNo]
  WHERE cms.[MedServiceCode] IN ('MEDLAB024','MEDLAB024') AND cms.[mission]='NG10' AND cms.[CompletionDate] > '2023-12-31';