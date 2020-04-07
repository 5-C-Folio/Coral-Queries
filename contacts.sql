select a.name as organizationCode, c.name, 
group_concat(cr.shortName) as categories,  
REPLACE(concat_ws('| ', c.title , REPLACE(c.addressText, '\n', ' '), REPLACE(c.noteText,'\n', ' ' )), ',', ';') as Notes, 
c.phoneNumber,   
c.altPhoneNumber, c.faxNumber,
c.emailAddress
 from coral_organizations.Contact c
inner join coral_organizations.Alias a
on  c.organizationID = a.organizationID and a.aliasTypeID = 5
left join coral_organizations.ContactRoleProfile crr
on c.contactID = crr.contactID
right join coral_organizations.ContactRole cr
on crr.contactRoleID = cr.contactRoleID
where c.archiveDate is Null
GROUP BY a.name, c.name, 
 c.title, c.addressText, c.noteText,
c.phoneNumber,   
c.altPhoneNumber, c.faxNumber,
c.emailAddress
