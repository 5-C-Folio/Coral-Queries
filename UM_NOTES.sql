SELECT
-- r.titleText, 
concat( "UM", rn.resourceID) as externalID, nt.shortName as noteTitle, case
					  when rn.noteTypeID = 17 then "Accessibility"
                      when rn.NoteTypeID = 3 then "Access Details"
                      when rn.NoteTypeID = 2 then "Acquisition Details"
                      when rn.NoteTypeID = 15 then "Data Integration"
                      when rn.NoteTypeID in (23,22,14,24) then "Discovery Details"
                      when rn.NoteTypeID in (4,1) then "General"
                      when rn.NoteTypeID = 5 then "Licensing Details"
                      else rn.NoteTypeID
                      end as "note Type",
replace(replace(rn.noteText, '\n', ' '), ',', '; ') as noteText

FROM coral_resources.ResourceNote rn
INNER JOIN coral_resources.NoteType nt
on rn.noteTypeID = nt.noteTypeID
inner join coral_resources.Resource r 
on r.resourceID = rn.ResourceID


WHERE rn.noteTypeID in (
17,
3,
4,
2,
23,
22,
14,
24,
15,
5,
1)
and rn.resourceID in (
SELECT r.resourceID 
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
and rl.organizationRoleID = 6 )
