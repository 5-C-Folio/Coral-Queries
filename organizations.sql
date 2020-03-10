Select distinct
org.name,
alcode.name as orgCode,
org.companyURL,
org.noteText,
org.accountDetailText,
case
	when orp1.organizationRoleID = 6 then 'True'
  else 'False'
end as 'is Vendor',
group_concat(orr.shortName),
(SELECT group_concat(aty.shortName, ': ' ,al.name)
FROM 
coral_organizations.Alias al
left join
coral_organizations.AliasType aty 
on al.aliasTypeID = aty.aliasTypeID
left join 
coral_organizations.Organization org2
on al.organizationID = org2.organizationID
where org2.organizationID = org.organizationID
group by org2.organizationID) as Aliases 

from
coral_organizations.Organization org
Left join coral_organizations.Alias alcode
#type 5 (vendor code) is distinct to UMASS.  Type may be different for other schools
on org.organizationID = alcode.organizationID and alcode.aliasTypeID = 5
left join coral_organizations.OrganizationRoleProfile orp1
#role 6 (is vendor) is distinct to UMASS. RoleID might be different for other schools
on org.organizationID =  orp1.organizationID and orp1.organizationRoleID = 6
left join coral_organizations.OrganizationRoleProfile orp2
on org.organizationID = orp2.organizationID
left join coral_organizations.OrganizationRole orr
on orp2.organizationRoleID = orr.organizationRoleID

group by 
org.name,
alcode.name ,
org.companyURL,
org.noteText,
org.accountDetailText,
orp1.organizationRoleID
