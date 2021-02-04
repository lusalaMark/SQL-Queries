--SQL
--Use AdventureWorks2017 DataBase
--1.	Retrieve a list of the different types of contacts that can exist in the database 
-- Expected Output: 
--       - ContactTypeID
--       - Name
select ContactTypeID, [Name]  
from person.ContactType

---USING CTE 
WITH PersonContact_CTE ( ContactTypeID, [Name])
AS
(
	SELECT ContactTypeID, [Name]
	FROM   person.ContactType
 )
SELECT ContactTypeID,
       [Name]
FROM   PersonContact_CTE

---storedprocedure
CREATE PROC spPersonContact
AS
BEGIN	select ContactTypeID, [Name]  
	from person.ContactType
END

EXEC spPersonContact
--2.	Retrieve (ContactTypeID, Name) for the contact type 'Marketing Manager'
--            Expected Output: 
--      - ContactTypeID
--      - Name 
select ContactTypeID, [Name ]
from Person.ContactType
where [Name]  = 'Marketing Manager'

--USING CTE  

WITH MarketingManager_CTE ( ContactTypeID, [Name])
AS
(
	SELECT ContactTypeID, [Name]
	FROM   person.ContactType
	where Name  = 'Marketing Manager'
)

SELECT ContactTypeID,[Name]
FROM   MarketingManager_CTE

--USING STORED PROCEDURE
CREATE PROC spMarketingManager
AS 
BEGIN
	select ContactTypeID, [Name ]
	from Person.ContactType
	where [Name]  = 'Marketing Manager'
END 

EXEC spMarketingManager

--3.	Retrieve a list of the different types of contacts which are managers
--Expected Output: 
--  - ContactTypeID
--   - Name
select ContactTypeID, [Name] 
from Person.ContactType
where [Name]  LIKE '%Manager%'
order by [Name] ASC

--USING CTE 
--3.	Retrieve a list of the different types of contacts which are managers

WITH ManagerContacts_CTE ( ContactTypeID, [Name])
AS
(
	SELECT ContactTypeID, [Name]
	FROM   person.ContactType
	where Name  LIKE '%Manager%'
)
select ContactTypeID, Name 
from ManagerContacts_CTE

--USING STORED PROCEDURE
CREATE PROC spManagerContacts
AS
BEGIN 
	select ContactTypeID, [Name] 
from Person.ContactType
where [Name]  LIKE '%Manager%'
order by [Name] ASC
END

EXEC spManagerContacts

--4.	Retrieve a list of the different types of contacts which are managers
--Expected Output: 
-- - ContactTypeID
-- - Name
---- Sorted by
--             Alphabetically Descending
select ContactTypeID, [Name] 
from Person.ContactType
where [Name]  LIKE '%Manager%' 
ORDER BY Name DESC

--USING CTE 
WITH ManagerContactsByDescendingOrderAlphabetically_CTE ( ContactTypeID, [Name])
AS
(
	SELECT ContactTypeID, [Name]
	FROM   person.ContactType
	where Name  LIKE '%Manager%'
	--The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, 
	--unless TOP, OFFSET or FOR XML is also specified.
			--****ORDER BY NAME DESC**--
)
select ContactTypeID, Name 
from ManagerContactsByDescendingOrderAlphabetically_CTE
where Name  LIKE '%Manager%'

--using stored procedure 
CREATE PROC spManagerContactsByDescendingOrderAlphabetically
AS
BEGIN 
	select ContactTypeID, [Name] 
from Person.ContactType
where [Name]  LIKE '%Manager%' 
ORDER BY Name DESC
END
EXEC spManagerContactsByDescendingOrderAlphabetically

EXEC spManagerContactsByDescendingOrderAlphabetically
--5.	Retrieve a list of all contacts which are 'Purchasing Manager' 
--Expected Output: 
--   - BusinessEntityID
--   - LastName
--  - FirstName
--  - MiddleName
SELECT Person_s.BusinessEntityID, LastName, FirstName, MiddleName
FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
INNER JOIN Person.ContactType AS Contats_s
ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
INNER JOIN Person.Person AS Person_s
ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
WHERE Contats_s.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName, MiddleName

--USING CTE 

With CTE_PurchasingManager
As
(
SELECT p.BusinessEntityID, LastName, FirstName, MiddleName
FROM Person.BusinessEntityContact AS PBEC
INNER JOIN Person.ContactType AS PCT
ON PCT.ContactTypeID = PBEC.ContactTypeID
INNER JOIN Person.Person AS p
ON p.BusinessEntityID = PBEC.PersonID
WHERE PCT.Name = 'Purchasing Manager'
)
Select * from  CTE_PurchasingManager
ORDER BY LastName, FirstName, MiddleName

--Stored procedure
CREATE PROC spPurchasingManager
AS 
BEGIN 
	SELECT Person_s.BusinessEntityID, LastName, FirstName, MiddleName
	FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
	INNER JOIN Person.ContactType AS Contats_s
		ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
	INNER JOIN Person.Person AS Person_s
	ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
	WHERE Contats_s.Name = 'Purchasing Manager'
	ORDER BY LastName, FirstName, MiddleName
END 

EXEC spPurchasingManager

--6.	Retrieve a list of all contacts which are 'Purchasing Manager' 
--Expected Output: 
--  - BusinessEntityID
--  - LastName
--   - FirstName
-- - MiddleName, if there is no MiddleName, to display '' (empty string) instead of NULL (*
--Use atleast 2 Ways to replace null)

 --**********USING IS NULL () FUNCTION ****************------------

SELECT Person_s.BusinessEntityID, LastName, FirstName, ISNULL(MiddleName,'')MiddleName
FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
INNER JOIN Person.ContactType AS Contats_s
ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
INNER JOIN Person.Person AS Person_s
ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
WHERE Contats_s.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName, MiddleName


 --**********USING CASE STATEMENT****************------------


SELECT Person_s.BusinessEntityID, LastName, FirstName,
	CASE 
		WHEN MiddleName IS NULL THEN '' ELSE MiddleName
	END
	AS MiddleName
FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
INNER JOIN Person.ContactType AS Contats_s
ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
INNER JOIN Person.Person AS Person_s
ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
WHERE Contats_s.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName, MiddleName

 --**********USING COALSE () FUNCTION ****************------------

 SELECT Person_s.BusinessEntityID, LastName, FirstName, COALESCE(MiddleName, '') AS MiddleName
FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
INNER JOIN Person.ContactType AS Contats_s
ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
INNER JOIN Person.Person AS Person_s
ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
WHERE Contats_s.Name = 'Purchasing Manager'
ORDER BY LastName, FirstName, MiddleName

----CTE
With CTE_PurchasingManagerMiddleNameIsNull
As
(
SELECT Person_s.BusinessEntityID, LastName, FirstName, COALESCE(MiddleName, '') AS MiddleName
FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
INNER JOIN Person.ContactType AS Contats_s
ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
INNER JOIN Person.Person AS Person_s
ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
WHERE Contats_s.Name = 'Purchasing Manager'
)
select * from CTE_PurchasingManagerMiddleNameIsNull
ORDER BY LastName, FirstName, MiddleName

--Stored procedure
Alter PROC spPurchasingManagerMiddleNameIsNull
AS 
BEGIN 
	SELECT Person_s.BusinessEntityID, LastName, FirstName, COALESCE(MiddleName, '') AS MiddleName
	FROM Person.BusinessEntityContact AS Purchasing_Manager_Contacts
	INNER JOIN Person.ContactType AS Contats_s
	ON Contats_s.ContactTypeID = Purchasing_Manager_Contacts.ContactTypeID
	INNER JOIN Person.Person AS Person_s
	ON Person_s.BusinessEntityID = Purchasing_Manager_Contacts.PersonID
	WHERE Contats_s.Name = 'Purchasing Manager'
	ORDER BY LastName, FirstName, MiddleName
END 

EXEC spPurchasingManagerMiddleNameIsNull
--7.	Retrieve a list of the different types of contacts and how many of them exist in the database 
--Expected Output: 
--   - ContactTypeID
--  - ContactTypeName
--  - N_contacts
select PersonType.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
from Person.ContactType as PersonType
inner join Person.BusinessEntityContact 
On PersonType.ContactTypeID= Person.BusinessEntityContact.ContactTypeID
group by PersonType.ContactTypeID, name

----CTE
With CTE_NContacts
As
(
select PeT.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
from Person.ContactType as PeT
inner join Person.BusinessEntityContact as PBeT
On PeT.ContactTypeID= PBeT.ContactTypeID
group by PeT.ContactTypeID, name
)
select * from CTE_NContacts 

--Stored procedure
CREATE PROC spNContacts 
AS 
BEGIN 
	select PeT.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
	from Person.ContactType as PeT
	inner join Person.BusinessEntityContact as PBeT
	On PeT.ContactTypeID= PBeT.ContactTypeID
	group by PeT.ContactTypeID, name
END 
EXEC spNContacts

--8.	Retrieve a list of the different types of contacts and how many of them exist in the database 
--Expected Output: 
-- - ContactTypeID
-- - ContactTypeName
-- - N_contacts
---- Sorted by:
----          - N_contacts descending
select PersonType.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
from Person.ContactType as PersonType
inner join Person.BusinessEntityContact 
On PersonType.ContactTypeID= Person.BusinessEntityContact.ContactTypeID
group by PersonType.ContactTypeID, name
Order by N_Contacts desc

----CTE
With CTE_NContactsDesc
As
(
select PersonType.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
from Person.ContactType as PersonType
inner join Person.BusinessEntityContact 
On PersonType.ContactTypeID= Person.BusinessEntityContact.ContactTypeID
group by PersonType.ContactTypeID, name
)
Select * from CTE_NContactsDesc
Order by N_Contacts desc

	--Stored procedure
CREATE PROC spNContactsDesc
AS 
BEGIN 
	select PersonType.ContactTypeID, name as ContactTypeName, COUNT (*) as N_Contacts
	from Person.ContactType as PersonType
	inner join Person.BusinessEntityContact 
	On PersonType.ContactTypeID= Person.BusinessEntityContact.ContactTypeID
	group by PersonType.ContactTypeID, name
END 
 EXEC SPNContactsDesc

--9.	Retrieve a list of the different types of contacts and how many of them exist in the database 
--Expected Output: 
-- - ContactTypeID
-- - ContactTypeName
--- N_contacts
---- Sorted by:
----          - N_contacts descending
---- Filter:
--  - Only interested in ContactTypes that have 100 contacts or more.
select Prson.ContactTypeID, name as ContactTypeName, COUNT(Prson.ContactTypeID) as N_Contacts
from Person.ContactType as ContType
inner join [Person].[BusinessEntityContact] as Prson
ON ContType.ContactTypeID=Prson.ContactTypeID
group by  Prson.ContactTypeID, Name
having COUNT (PersonID)>=100
Order by N_Contacts desc

 ---Using CTE 
With CTE_ContactsWithContactsMoreThan100 
As
(
select Prson.ContactTypeID, name as ContactTypeName, COUNT(Prson.ContactTypeID) as N_Contacts
from Person.ContactType as ContType
inner join [Person].[BusinessEntityContact] as Prson
ON ContType.ContactTypeID=Prson.ContactTypeID
group by  Prson.ContactTypeID, Name
having COUNT (PersonID)>=100
)
Select* from CTE_ContactsWithContactsMoreThan100 
Order by N_Contacts desc

	--Stored procedure
CREATE PROC spContactsWithContactsMoreThan100
AS 
BEGIN 
	select Prson.ContactTypeID, name as ContactTypeName, COUNT(Prson.ContactTypeID) as N_Contacts
	from Person.ContactType as ContType
	inner join [Person].[BusinessEntityContact] as Prson
	ON ContType.ContactTypeID=Prson.ContactTypeID
	group by  Prson.ContactTypeID, Name
	having COUNT (PersonID)>=100
	Order by N_Contacts desc
END 
exec spContactsWithContactsMoreThan100


--10.	The table [HumanResources].[EmployeePayHistory] holds employees current salary along with historical data
--Retrieve a List of employees and their Historical weekly salary (based on 40h a week) 
--Expected Output: 
--- RateChangeDate from historical table aliased to DateFrom, in the format 'dd/mm/yyyy'
--- 1 column which includes 'LastName, FirstName MiddleName' called FullNamne 
--- WeeklySalary which must be calculated too
---- Sorted by 
--   - FullName

select CONCAT(FirstName,' ', MiddleName,' ', LastName) as Fullname,  (Rate*40) as Weekly_Salary, 
CONVERT(varchar, ratechangedate) as dateform
from [HumanResources].[EmployeePayHistory] as HumanHIstoricalData
Inner join Person.Person as Persons
on HumanHIstoricalData.BusinessEntityID= Persons.BusinessEntityID
Order by Weekly_Salary

----Using CTE
With CTE_Weekly_Salary
As
(
select CONCAT(FirstName,'', MiddleName,'', LastName) as Fullname,  (Rate*40) as Weekly_Salary, 
CONVERT(varchar, ratechangedate) as dateform
from [HumanResources].[EmployeePayHistory] as HumanHIstoricalData
Inner join Person.Person as Persons
on HumanHIstoricalData.BusinessEntityID= Persons.BusinessEntityID
)
Select * from CTE_Weekly_Salary
Order by Weekly_Salary

--USING Storedprocedure
CREATE PROC spWeekly_Salary
AS 
BEGIN 
	select CONCAT(FirstName,' ', MiddleName,' ', LastName) as Fullname,  (Rate*40) as Weekly_Salary, 
	CONVERT(varchar, ratechangedate) as dateform
	from [HumanResources].[EmployeePayHistory] as HumanHIstoricalData
	Inner join Person.Person as Persons
	on HumanHIstoricalData.BusinessEntityID= Persons.BusinessEntityID
	Order by Weekly_Salary
END 

EXEC spWeekly_Salary
