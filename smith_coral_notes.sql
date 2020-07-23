SELECT 
-- r.titleText, 
concat( "SC", rn.resourceID) as externalID, nt.shortName as noteTitle, case
					  when rn.noteTypeID in (1, 4, 6) then 'General'
                      when rn.noteTypeID = 2 then 'Acquisition Details'
                      when rn.noteTypeID = 3 then 'Access Details'
                      when rn.noteTypeID = 8 then 'LibGuides ID'
                      else "oops"
                      end as "note Type",
replace(replace(rn.noteText, '\n', ' '), ',', '; ') as noteText

FROM smith_coral_resources.ResourceNote rn
INNER JOIN smith_coral_resources.NoteType nt
on rn.noteTypeID = nt.noteTypeID
inner join smith_coral_resources.Resource r 
on r.resourceID = rn.ResourceID
WHERE
rn.noteTypeID != 7
