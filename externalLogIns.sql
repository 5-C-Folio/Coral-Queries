select ex.externalLoginID, a.name as code, group_concat(ext.shortName) as interfaceType ,
ex.emailAddress, 
ex.username, md5(ex.password), 
ex.loginURL,
RePLACE(REPLACE(ex.noteText, ',',';'), '\n', ' ') as Notes
 from coral_organizations.ExternalLogin ex
inner join coral_organizations.Alias a
#when running smith, update alias type
on  ex.organizationID = a.organizationID and a.aliasTypeID = 5
inner join coral_organizations.ExternalLoginType ext
on ex.externalLoginTypeID = ext.externalLoginTypeID
Group by a.name ,ex.emailAddress, ex.username, md5(ex.password), ex.noteText
