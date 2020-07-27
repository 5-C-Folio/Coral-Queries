SELECT 
-- r.titleText, 
concat( "AC", rn.resourceID) as externalID, nt.shortName as noteTitle, case
					  when rn.noteTypeID in (1, 4, 6) then 'General'
                      when rn.noteTypeID = 2 then 'Acquisition Details'
                      when rn.noteTypeID = 3 then 'Access Details'
                      when rn.noteTypeID = 8 then 'LibGuides ID'
                      when rn.noteTypeID = 5 then "Licensing Details"
                      else "oops"
                      end as "note Type",
replace(replace(rn.noteText, '\n', ' '), ',', '; ') as noteText

FROM coral_resources.ResourceNote rn
INNER JOIN coral_resources.NoteType nt
on rn.noteTypeID = nt.noteTypeID
inner join coral_resources.Resource r 
on r.resourceID = rn.ResourceID
WHERE
rn.noteTypeID != 7
