SELECT distinct CONCAT("SC", r.resourceID) as externalID,  
CONCAT("SC", al.name) as orgCode, 
CONCAT("SC ", r.titleText) as titleText,
 replace(replace(r.descriptionText,'\n',''), ',',';') as descriptionText, 
r.orderNumber, 
r.systemNumber, 
r.currentStartDate, 
r.currentEndDate , 
at.shortName as acqType, 
rt.shortName as resourceType, 
st.shortName as statusName,
(SELECT group_concat(atyr.shortName, ': ' ,alr.shortName)
FROM 
smith_coral_resources.Alias alr
inner join
smith_coral_resources.AliasType atyr 
on alr.aliasTypeID = atyr.aliasTypeID
inner join 
smith_coral_resources.Resource r2
on alr.resourceID = r2.resourceID
where r2.resourceID = r.resourceID
group by r2.resourceID) as alias 

FROM smith_coral_resources.Resource r
left join smith_coral_resources.ResourceOrganizationLink rl
on r.resourceID = rl.resourceID
left  join  smith_coral_organizations.Organization org
on rl.organizationID = org.organizationID 
left join smith_coral_organizations.Alias al 
on rl.organizationID = al.organizationID and al.aliasTypeID = 4
left join smith_coral_resources.Status st
on r.statusID = st.statusID
left join smith_coral_resources.ResourceType rt
on r.resourceTypeID = rt.resourceTypeID
left join smith_coral_resources.AcquisitionType at
on r.acquisitionTypeID = at.acquisitionTypeID
where
st.statusID != 4
