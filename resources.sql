SELECT distinct CONCAT("UM",r.resourceID) as externalID, 
CONCAT("UM", al.name )as orgCode, 
CONCAT( "UM ", r.titleText) as titleText, 
replace(replace(r.descriptionText,'\n',''), ',',' ') as descriptionText, 
r.orderNumber, 
r.systemNumber, 
CASE
when r.currentStartDate is NULL then '2020-01-01'
else r.currentStartDate
end as currentStartDate,
r.currentEndDate , 
at.shortName as acqType, 
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
inner join coral_resources.Status st
on r.statusID = st.statusID
inner join coral_resources.ResourceType rt
on r.resourceTypeID = rt.resourceTypeID
inner join coral_resources.AcquisitionType at
on r.acquisitionTypeID = at.acquisitionTypeID
where
st.statusID != 4
and rt.resourceTypeID not In (3, 5)
and r.resourceID not in (select resourceID from coral_resources.ResourceRelationship)
and r.resourceID not in (select relatedResourceID from coral_resources.ResourceRelationship)
and r.acquisitionTypeID not in (20, 19, 2, 8, 9, 12, 25,23,24,15)
and rl.organizationRoleID = 6
