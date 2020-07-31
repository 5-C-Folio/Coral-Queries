SELECT distinct CONCAT('AC', r.resourceID) as externalID, 
CONCAT('AC', al.name) as orgCode, 
CONCAT ('AC ', r.titleText) as titleText, 
replace(replace(r.descriptionText,'\n',''), ',',';') as desciptionText, 
r.orderNumber, 
r.systemNumber, 
CASE
when r.currentStartDate is NULL then '2020-01-01'
else r.currentStartDate
end as currentStartDate,
r.currentEndDate , at.shortName as acqType,
 rt.shortName as resourceType, 
 st.shortName as statusName,
(SELECT group_concat(atyr.shortName, ': ' ,alr.shortName)
FROM 
coral_resources.Alias alr
inner join
coral_resources.AliasType atyr 
on alr.aliasTypeID = atyr.aliasTypeID
inner join 
coral_resources.Resource r2
on alr.resourceID = r2.resourceID
where r2.resourceID = r.resourceID
group by r2.resourceID) as alias 

FROM coral_resources.Resource r
left join coral_resources.ResourceOrganizationLink rl
on r.resourceID = rl.resourceID
left  join  coral_organizations.Organization org
on rl.organizationID = org.organizationID 
left join coral_organizations.Alias al 
on rl.organizationID = al.organizationID and al.aliasTypeID = 5
left join coral_resources.Status st
on r.statusID = st.statusID
left join coral_resources.ResourceType rt
on r.resourceTypeID = rt.resourceTypeID
left join coral_resources.AcquisitionType at
on r.acquisitionTypeID = at.acquisitionTypeID
where
st.statusID != 4
and  rl.organizationRoleID = 6
and r.resourceTypeID in (2,3,5,7,9,10)
and r.resourceID not in (select resourceID from coral_resources.ResourceRelationship)
and r.resourceID not in (select relatedResourceID from coral_resources.ResourceRelationship)
and al.aliasID != 227
and r.acquisitionTypeID NOT IN (6, 2, 9, 11, 12)
