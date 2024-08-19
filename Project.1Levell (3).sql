create database DBanking;
use DBanking
go
create schema bank

CREATE TABLE bank.Countries (
    CountryID INT PRIMARY KEY,
    LongName NVARCHAR(100) Unique,
    ShortName NVARCHAR(50) NOT NULL
);

-------------------------------------------------------------------------------------------

CREATE TABLE bank.Cities (
    CityID INT PRIMARY KEY,
    CityName NVARCHAR(100) Unique,
    CountryID INT NOT NULL,
    PostalCode NVARCHAR(20) Default '0000',
	FOREIGN KEY (CountryID) REFERENCES bank.Countries(CountryID)
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.Branches (
BranchID INT PRIMARY KEY,
BranchName NVARCHAR(100) Unique,
[Address] NVARCHAR(255),
PhoneNumber NVARCHAR(20) CHECK (PhoneNumber LIKE '%[0-9]%') ,
IsActive BIT Not NULL,
CityID INT NOT NULL,
BranchHead NVARCHAR(50) Not NULL,
FOREIGN KEY (CityID) REFERENCES bank.Cities(CityID)
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE Not Null,
    Email NVARCHAR(100) Not NULL,
    PhoneNumber NVARCHAR(20) Not Null,
    [Address] NVARCHAR(255),
    PositionID INT Not NULL,
    BranchID INT NOT NULL,
    HireDate DATE Check(HireDate<=GETDATE()),
	CityID INT NOT NULL
    FOREIGN KEY (PositionID) REFERENCES bank.Positions(PositionID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
    FOREIGN KEY (CityID) REFERENCES bank.Cities(CityID)
);

Alter Table bank.Employees
Add İsActive bit 
Update bank.Employees
set İsActive=0 where EmployeeID in (10,30,65,93,116,137,180)
Update bank.Employees
set İsActive=1 where EmployeeID not in (10,30,65,93,116,137,180)
Alter Table bank.Employees
Add SeriyaN Nvarchar(30)  

--ALTER TABLE bank.Employees
--ADD CONSTRAINT emailemployee UNIQUE (Email);

--ALTER TABLE bank.Employees
--ADD CONSTRAINT FK_PositionID FOREIGN KEY (PositionID)
--REFERENCES bank.Positions(PositionID);

--ALTER TABLE bank.Employees
--ADD CONSTRAINT FK_BranchID FOREIGN KEY (BranchID)
--REFERENCES bank.Branches(BranchID);

--ALTER TABLE bank.Employees
--ADD CONSTRAINT FK_CityID FOREIGN KEY (CityID)
--REFERENCES bank.Cities(CityID);



-------------------------------------------------------------------------------------------


CREATE TABLE bank.Departments (
    DepartmentID INT PRIMARY KEY ,
    DepartmentName NVARCHAR(255) UNIQUE,
    DepartmentHead NVARCHAR(255) NOT NULL,
    DateCreated DATETIME DEFAULT GETDATE(), 
    LastUpdated DATETIME DEFAULT GETDATE(),
    CreatedUser INT NOT NULL,
    UpdatedUser INT NOT NULL,
	FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);

Alter table bank.Departments
Alter column CreatedUser INT;
Alter table bank.Departments
Alter column UpdatedUser INT;


-- Add foreign key constraints
--ALTER TABLE bank.Departments
--ADD CONSTRAINT FK_CreatedUser FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID);

--ALTER TABLE bank.Departments
--ADD CONSTRAINT FK_UpdatedUser FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID);


-------------------------------------------------------------------------------------------


CREATE TABLE bank.Positions (
    PositionID INT PRIMARY KEY,
    PositionName NVARCHAR(255) UNIQUE,
    DepartmentID INT NOT NULL,
    JobDescription TEXT,
    MinSalary DECIMAL(10, 2) CHECK (abs(MinSalary)>500),
    MaxSalary DECIMAL(10, 2) CHECK (MaxSalary <= 2000),
    DateCreated DATETIME DEFAULT GETDATE(),
    DateUpdated DATETIME DEFAULT GETDATE(),
    CreatedUser INT NOT NULL,  
    UpdatedUser INT NOT NULL
    FOREIGN KEY (DepartmentID) REFERENCES bank.Departments(DepartmentID),
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);

Alter table bank.Positions
Alter column CreatedUser INT;
Alter table bank.Positions
Alter column UpdatedUser INT;
ALTER TABLE bank.Positions
--ADD CONSTRAINT FK_CreatedUserrr FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID);

--ALTER TABLE bank.Positions
--ADD CONSTRAINT FK_UpdatedUserrr FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID);

--ALTER TABLE bank.Positions
--ADD CONSTRAINT FK_PositionsID FOREIGN KEY (DepartmentID) REFERENCES bank.Departments(DepartmentID);

--SELECT 
--    con.name AS ConstraintName
--FROM 
--    sys.check_constraints AS con
--    INNER JOIN sys.objects AS tbl ON con.parent_object_id = tbl.object_id
--    INNER JOIN sys.columns AS col ON col.object_id = tbl.object_id AND col.column_id = con.parent_column_id
--WHERE 
--    tbl.name = 'Positions' 
--    AND col.name = 'MaxSalary';

ALTER TABLE bank.Positions
DROP CONSTRAINT CK__Positions__MaxSa__60A75C0F;
ALTER TABLE bank.Positions
ADD CONSTRAINT CK_Positions_MaxSalary
CHECK (MaxSalary >= MinSalary);



-------------------------------------------------------------------------------------------



CREATE TABLE bank.LoanStatuses (
    LoanStatusID INT PRIMARY KEY,
    LoanStatusName NVARCHAR(100) Unique,
    IsActive BIT NOT NULL
);


-------------------------------------------------------------------------------------------



CREATE TABLE bank.LoansReasons (
    ReasonID INT PRIMARY KEY,
    ReasonName NVARCHAR(100) Unique
);



-------------------------------------------------------------------------------------------



CREATE TABLE bank.LoanTypes (
    LoanTypeID INT PRIMARY KEY,
    LoanTypeName NVARCHAR(100) not null,
    LoanSubtypeName NVARCHAR(100) UNIQUE,
    MinLoanAmount DECIMAL(18, 2) CHECK (abs(MinLoanAmount)>500),
    MaxLoanAmount DECIMAL(18, 2),
	CHECK (MaxLoanAmount >= MinLoanAmount),
    CollateralRequired BIT NOT NULL
);


--NULL problems
SELECT name 
FROM sys.key_constraints 
WHERE type = 'UQ' 
AND OBJECT_NAME(parent_object_id) = 'LoanTypes';

ALTER TABLE bank.LoanTypes
DROP CONSTRAINT UQ__LoanType__E26E54A6A5576C84;

-------------------------------------------------------------------------------------------


CREATE TABLE bank.DepositTypes (
    DepositTypeID INT PRIMARY KEY,
    DepositTypeName NVARCHAR(255) NOT NULL,
    DepositSubtypeName NVARCHAR(255) 
);


-------------------------------------------------------------------------------------------



CREATE TABLE bank.DepositStatuses (
    DepositStatusID INT PRIMARY KEY,
    DepositStatusName NVARCHAR(255) Unique,
    IsActive BIT NOT NULL
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.DepositReasons (
    ReasonID INT PRIMARY KEY,
    ReasonName NVARCHAR(255) unique
);


-------------------------------------------------------------------------------------------


CREATE TABLE bank.CustomerTypes (
    CustomerTypeID INT PRIMARY KEY,
    CustomerTypeName NVARCHAR(100) Unique,
    IsActive BIT NOT NULL,
    DateCreated DATETIME DEFAULT GETDATE() ,
    DateUpdated DATETIME DEFAULT GETDATE() ,
    CreatedUser INT NOT NULL,
    UpdatedUser INT NOT NULL,
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);
Alter table bank.CustomerTypes
Alter column CreatedUser INT;
Alter table bank.CustomerTypes
Alter column UpdatedUser INT;

-------------------------------------------------------------------------------------------


CREATE TABLE bank.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerTypeID INT NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    [Address] NVARCHAR(255) NOT NULL,
    BranchID INT NOT NULL,
    Email NVARCHAR(100) Not Null,
    PhoneNumber NVARCHAR(20) NOT NULL,
    CustomersJob NVARCHAR(255) NOT NULL,
    DateCreated DATETIME DEFAULT GETDATE() ,
    DateUpdated DATETIME DEFAULT GETDATE() ,
    CreatedUser INT NOT NULL,
    UpdatedUser INT NOT NULL,
    CityID INT NOT NULL,
    FOREIGN KEY (CustomerTypeID) REFERENCES bank.CustomerTypes(CustomerTypeID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (CityID) REFERENCES bank.Cities(CityID)
);


Alter Table bank.Customers
Add SeriyaN Nvarchar(30)  

Alter table bank.Customers
Alter column CreatedUser INT;
Alter table bank.Customers
Alter column UpdatedUser INT;

-------------------------------------------------------------------------------------------


CREATE TABLE bank.TransactionTypes (
    TransactionTypeID INT PRIMARY KEY,
    TransactionTypeName NVARCHAR(100) UNIQUE,
    IsDebit BIT NOT NULL,
    Frequency NVARCHAR(50),
    IsActive BIT NOT NULL
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.TransactionsReasons (
    ReasonID INT PRIMARY KEY,
    ReasonName NVARCHAR(255) UNIQUE
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.PayeesTypes (
    PayeesTypeID INT PRIMARY KEY,
    PayeesTypeName NVARCHAR(100) UNIQUE
);


-------------------------------------------------------------------------------------------


CREATE TABLE bank.AccountStatuses (
    AccountStatusID INT PRIMARY KEY,
    AccountStatusName NVARCHAR(100) UNIQUE,
    IsActive BIT NOT NULL
);


-------------------------------------------------------------------------------------------


CREATE TABLE bank.CardTypes (
    CardTypeID INT PRIMARY KEY,
    CardTypeName NVARCHAR(100) UNIQUE
);


-------------------------------------------------------------------------------------------


CREATE TABLE bank.CardStatuses (
    CardStatusID INT PRIMARY KEY,
    CardStatusName NVARCHAR(100) UNIQUE,
    IsActive BIT NOT NULL
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.CardsReasons (
    ReasonID INT PRIMARY KEY,
    ReasonName NVARCHAR(255) UNIQUE
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.Currencies (
    CurrencyID INT PRIMARY KEY,
    ShortName NVARCHAR(10) UNIQUE,
    LongName NVARCHAR(100) UNIQUE
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.CurrencyRates (
    CurrencyRateID INT PRIMARY KEY,
    CurrencyID INT NOT NULL,
    [Date] DATE DEFAULT GETDATE(),
    USD DECIMAL(18, 2) NOT NULL,
    AZN DECIMAL(18, 2) NOT NULL,
    TL DECIMAL(18, 2) NOT NULL,
    EURO DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID)
);

-------------------------------------------------------------------------------------------


CREATE TABLE bank.Cards (
    CardID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    CardNumber NVARCHAR(50) NOT NULL,
    CardTypeID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE() ,
    UpdatedDate DATETIME DEFAULT GETDATE() ,
    IsOnline BIT NOT NULL,
    BranchID INT NOT NULL,
    CreatedUser INT NOT NULL,
	UpdatedUser INT NOT NULL,
    StatusID INT NOT NULL,
    ReasonID INT,
    FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID),
    FOREIGN KEY (CardTypeID) REFERENCES bank.CardTypes(CardTypeID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (ReasonID) REFERENCES bank.CardsReasons(ReasonID),
	FOREIGN KEY (StatusID) REFERENCES bank.CardStatuses(CardStatusID)
);

Alter table bank.Cards
Alter column CreatedUser INT;
Alter table bank.Cards
Alter column UpdatedUser INT;

--------------------------------------------------------------------------------------

CREATE TABLE bank.AccountTypes (
    AccountTypeID INT PRIMARY KEY,
    AccountTypeName NVARCHAR(100) Unique,
    DateCreated DATETIME DEFAULT GETDATE(),
    DateUpdated DATETIME DEFAULT GETDATE(),
    CreatedUser INT NOT NULL,
    UpdatedUser INT NOT NULL,
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);

Alter table bank.AccountTypes
Alter column CreatedUser INT;
Alter table bank.AccountTypes
Alter column UpdatedUser INT;


--------------------------------------------------------------------------------------


CREATE TABLE bank.Accounts (
    AccountID INT PRIMARY KEY,
    AccountNumber NVARCHAR(50) NOT NULL,
    AccountTypeID INT NOT NULL,
    CurrentBalance DECIMAL(18, 2) NOT NULL,
    DateCreated DATETIME DEFAULT GETDATE() ,
    DateUpdated DATETIME DEFAULT GETDATE() ,
    AccountStatusID INT NOT NULL,
    CurrencyID INT NOT NULL,
    CustomerID INT NOT NULL,
    CreatedUser INT NOT NULL,
    UpdatedUser INT NOT NULL,
    FOREIGN KEY (AccountTypeID) REFERENCES bank.AccountTypes(AccountTypeID),
    FOREIGN KEY (AccountStatusID) REFERENCES bank.AccountStatuses(AccountStatusID),
    FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID),
    FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID),
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);

Alter table bank.Accounts
Alter column CreatedUser INT;
Alter table bank.Accounts
Alter column UpdatedUser INT;

--------------------------------------------------------------------------------------


CREATE TABLE bank.Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    LoanTypeID INT ,
    APR DECIMAL(10, 2) CHECK (APR >= 0),
    InterestRate DECIMAL(10, 2) CHECK (InterestRate >= 0),
    LoanStatusID INT ,
    CurrencyID INT ,
    CustomerID INT ,
    AccountID INT ,
    StartDate DATE Default getdate(),
    EndDate DATE,
    DateExtension DATE,
	CHECK(DateExtension>EndDate),
    DateCreated DATETIME DEFAULT GETDATE(),
    DateUpdated DATETIME DEFAULT GETDATE(),
    BranchID INT ,
    CreatedUser INT ,
    UpdatedUser INT ,
    ReasonID INT,
	FOREIGN KEY (LoanTypeID) REFERENCES bank.LoanTypes(LoanTypeID),
    FOREIGN KEY (LoanStatusID) REFERENCES bank.LoanStatuses(LoanStatusID),
    FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID),
    FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES bank.Accounts(AccountID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
    FOREIGN KEY (ReasonID) REFERENCES bank.LoansReasons(ReasonID),
	FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)
);


--------------------------------------------------------------------------------------



CREATE TABLE bank.LoanPayments (
    LoanPaymentID INT Identity(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    ScheduledPaymentDate DATE NOT NULL,
    PrincipalAmount DECIMAL(18, 2) ,
	CHECK (PrincipalAmount >= 0),
    InterestAmount DECIMAL(18, 2) ,
	CHECK (InterestAmount<PrincipalAmount ),
    PaidAmount DECIMAL(18, 2) NOT NULL,
    PaidDate DATE NOT NULL,
	PaymentDate Date NOT NULL,
    CurrencyID INT NOT NULL,
	FOREIGN KEY (LoanID) REFERENCES bank.Loans(LoanID),
    FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID)
);

--SELECT fk.name AS ForeignKeyName
--FROM sys.foreign_keys AS fk
--INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
--INNER JOIN sys.columns AS col ON fkc.parent_object_id = col.object_id AND fkc.parent_column_id = col.column_id
--INNER JOIN sys.tables AS tbl ON fkc.parent_object_id = tbl.object_id
--WHERE tbl.name = 'LoanPayments' -- Name of the table containing the foreign key
--  AND col.name = 'LoanID';
--  Alter table bank.LoanPayments drop constraint FK_LoanP

alter table bank.LoanPayments
Drop column ScheduledPaymentDate

--------------------------------------------------------------------------------------


CREATE TABLE bank.TransactionsStatus (
    StatusID INT PRIMARY KEY,
    StatusName NVARCHAR(50) UNIQUE,
    IsActive BIT NOT NULL 
);

--------------------------------------------------------------------------------------


CREATE TABLE bank.Transactions (
    TransactionID INT PRIMARY KEY,
    TransactionTypeID INT NOT NULL,
    DebitAccount NVARCHAR(50) ,
    CreditAccount NVARCHAR(50) ,
    Amount DECIMAL(18, 2) NOT NULL,
    CashbackAmount DECIMAL(18, 2),
    CurrencyID INT NOT NULL,
    TransactionDate DATETIME,
    MerchantProvider VARCHAR(100),
    PayeesTypeID INT,
    TransactionFee DECIMAL(18, 2),
    BranchID INT NOT NULL,
    ReasonID INT ,													
	StatusID INT NOT NULL,
    FOREIGN KEY (TransactionTypeID) REFERENCES bank.TransactionTypes(TransactionTypeID),
    FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID),
    FOREIGN KEY (PayeesTypeID) REFERENCES bank.PayeesTypes(PayeesTypeID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
    FOREIGN KEY (ReasonID) REFERENCES bank.TransactionsReasons(ReasonID),
	FOREIGN KEY (StatusID) REFERENCES bank.TransactionsStatus(StatusID)
);
Alter table bank.Transactions
Alter column TransactionTypeID INT
Alter table bank.Transactions
Alter column Amount DECIMAL(18, 2)
Alter table bank.Transactions
Alter column CurrencyID INT
Alter table bank.Transactions
Alter column BranchID INT
Alter table bank.Transactions
Alter column StatusID INT


--------------------------------------------------------------------------------------

CREATE TABLE bank.Deposits (
    DepositID INT Identity(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DepositTypeID INT NOT NULL,
    DepositAmount DECIMAL(10, 2) CHECK (DepositAmount > 0),
	CurrencyID INT,
    BranchID INT NOT NULL,
    AccountID INT NOT NULL,
    StartDate DATE NOT NULL,
	ExpiryDate Date,
    EndDate DATE,
    DateCreated DATETIME DEFAULT GETDATE() NOT NULL,
    DateUpdated DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedUser INT NOT NULL,  
    UpdatedUser INT NOT NULL,  
    DepositStatusID INT NOT NULL,
    ReasonID INT,
    FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID),
    FOREIGN KEY (DepositTypeID) REFERENCES bank.DepositTypes(DepositTypeID),
    FOREIGN KEY (BranchID) REFERENCES bank.Branches(BranchID),
	FOREIGN KEY (CurrencyID) REFERENCES bank.Currencies(CurrencyID),
    FOREIGN KEY (AccountID) REFERENCES bank.Accounts(AccountID),
    FOREIGN KEY (DepositStatusID) REFERENCES bank.DepositStatuses(DepositStatusID),
    FOREIGN KEY (ReasonID) REFERENCES bank.DepositReasons(ReasonID),
    FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID), 
    FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)  
);

drop table bank.Deposits
Alter table bank.Deposits
Alter column CreatedUser INT;
Alter table bank.Deposits
Alter column UpdatedUser INT;
Alter table bank.Deposits
Alter column CustomerID INT;
Alter table bank.Deposits
Alter column AccountID INT;
Alter table bank.Deposits
Alter column BranchID INT;
Alter table bank.Deposits
Alter column DepositStatusID INT;
Alter table bank.Deposits
Alter column DepositTypeID INT;
Alter table bank.Deposits
Alter column StartDate DATETIME ;
Alter table bank.Deposits
Alter column DateCreated DATETIME ;
Alter table bank.Deposits
Alter column DateUpdated DATETIME ;
select * from bank.Deposits

-----------------------------------------------------------------------------

CREATE TABLE bank.LoginCredentials (
    UserID INT PRIMARY KEY,
    UserName NVARCHAR(100) UNIQUE,
    [DateTime] DATETIME,
    [Password] NVARCHAR(255) NOT NULL, 
    LastLogin DATETIME,
    OTP VARCHAR(20) unique, 
    Foreign Key(UserID) References bank.Customers(CustomerID)
);

--There are customers who do not run the application(NULL problems)
SELECT name 
FROM sys.key_constraints 
WHERE type = 'UQ' 
AND OBJECT_NAME(parent_object_id) = 'LoginCredentials';

ALTER TABLE bank.LoginCredentials
DROP CONSTRAINT UQ__LoginCre__C9F2845607CE22B2;

ALTER TABLE bank.LoginCredentials
Alter column [Password] NVarCHAR(255)


--OTP 
SELECT name 
FROM sys.key_constraints 
WHERE type = 'UQ' 
AND OBJECT_NAME(parent_object_id) = 'LoginCredentials';
ALTER TABLE bank.LoginCredentials
DROP CONSTRAINT UQ__LoginCre__CB3903D9AB79D9AC;

--Then they all became unique

-----------------------------------------------------------------------------

 
CREATE TABLE bank.UserSessions (
    SessionID INT PRIMARY KEY,
    UserID INT NOT NULL,
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME,
    DeviceInfo NVARCHAR(255),
	FOREIGN KEY (UserID) REFERENCES bank.LoginCredentials(UserID)
);

-----------------------------------------------------------------------------

 

CREATE TABLE bank.NotificationTypes (
    NotificationTypeID INT PRIMARY KEY,
    NotificationTypeName NVARCHAR(100)  UNIQUE
);

-----------------------------------------------------------------------------

 
CREATE TABLE bank.NotificationsMethods (
    MethodID INT PRIMARY KEY,
    MethodName NVARCHAR(50) UNIQUE
);

-----------------------------------------------------------------------------

 
CREATE TABLE bank.SendNotifications (
    NotificationID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
	NotificationTypeID INT NOT NULL,
    PhoneNumber NVARCHAR(20),
    [Message] TEXT,
    SendDateTime DATETIME NOT NULL,
	NotificationMethodID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID),
	FOREIGN KEY (NotificationTypeID) REFERENCES bank.NotificationTypes(NotificationTypeID),
	FOREIGN KEY (NotificationMethodID) REFERENCES bank.NotificationsMethods(MethodID)
);

--ALTER TABLE bank.SendNotifications
--ADD CONSTRAINT FK_NotificationTypeID FOREIGN KEY (NotificationTypeID) REFERENCES bank.NotificationTypes(NotificationTypeID);
-----------------------------------------------------------------------------

 
CREATE TABLE bank.NotificationsReceipts (
    ReceiptID INT PRIMARY KEY,
    NotificationID INT NOT NULL,
    SendDateTime DATETIME NOT NULL,
    Response TEXT,
	NotificationMethodID INT NOT NULL,
    FOREIGN KEY (NotificationID) REFERENCES bank.SendNotifications(NotificationID),
	FOREIGN KEY (NotificationMethodID) REFERENCES bank.NotificationsMethods(MethodID)
);


--Finished creating tables
 --------------------------------------------------------------------------------------


 --We create a trigger from the first and last names of employees
CREATE TRIGGER bank.TriggerEmail
ON bank.Employees
AFTER Insert
AS
BEGIN
    UPDATE e
    SET e.Email = lower(e.FirstName)+lower(e.LastName)+'@gmail.com'
	From bank.Employees e
    join inserted i on i.EmployeeID=e.EmployeeID 
END;


--We create a trigger from the first and last names of employees
CREATE TRIGGER bank.TriggerCustomerEmail
ON bank.Customers
AFTER Insert
AS
BEGIN
    UPDATE c
    SET c.Email = lower(i.FirstName)+lower(i.LastName)+'@gmail.com'
	From bank.Customers c
    join inserted i on i.CustomerID=c.CustomerID 
END;

----------------------------------------------------------------------------------

--A trigger for statically setting cashback value
UPDATE bank.Transactions 
SET CashbackAmount = Amount*0.05

select * from bank.Transactions

--A trigger for statically setting fee value
UPDATE bank.Transactions 
SET TransactionFee = Amount * 0.01

-------------------------------------------------------------------------------------
--The presence of customers from each branch is checked
select BranchID,Count(*) from bank.Customers group by BranchID order by BranchID


--I created a trigger so that serial numbers are automatic and unique
CREATE TRIGGER bank.TriggerSeriyaN
ON bank.Customers
AFTER Insert
AS
BEGIN
    UPDATE c1
    SET c1.SeriyaN =c3.ShortName+Right(c1.PhoneNumber,6)
	From bank.Customers c1 
	join bank.Cities c2 on c2.CityID=c1.CityID 
	join bank.Countries c3 on c3.CountryID=c2.CountryID
	join inserted i on i.CustomerID = c1.CustomerID;
END;
select * from bank.Countries
-----------------------------------------------------------------------------------

select * from bank.LoginCredentials order by DateTime

UPDATE bank.LoginCredentials
SET DateTime = DATEADD(MONTH, 4 - 6, DateTime),
    LastLogin = DATEADD(MONTH, 4 - 6, LastLogin)
WHERE DateTime >= '2024-06-01' AND DateTime < '2024-07-01'
   OR LastLogin >= '2024-06-01' AND LastLogin < '2024-07-01';


UPDATE bank.LoginCredentials
SET DateTime = DATEADD(MONTH, 4 - 6, DateTime),
    LastLogin = DATEADD(Month, 4 - 6, LastLogin)
WHERE DateTime >= '2024-07-01' AND DateTime < '2024-08-01'
   OR LastLogin >= '2024-07-01' AND LastLogin < '2024-08-01';
   UPDATE bank.LoginCredentials
SET DateTime = DATEADD(Day, 4 - 9, DateTime),
    LastLogin = DATEADD(Day, 4 - 9, LastLogin)
WHERE DateTime >= '2024-07-01' AND DateTime < '2024-08-01'
   OR LastLogin >= '2024-07-01' AND LastLogin < '2024-08-01';

UPDATE bank.LoginCredentials
SET DateTime = DATEADD(MONTH, 4 - 7, DateTime),
    LastLogin = DATEADD(MONTH, 4 - 7, LastLogin)
WHERE DateTime >= '2024-08-01' AND DateTime < '2024-09-01'
   OR LastLogin >= '2024-08-01' AND LastLogin < '2024-09-01';

   UPDATE bank.LoginCredentials
SET DateTime = DATEADD(day, 7, DateTime),
    LastLogin = DATEADD(Day, 7, LastLogin)
WHERE DateTime >= '2024-05-26' AND DateTime < '2024-06-01'
   OR LastLogin >= '2024-05-26' AND LastLogin < '2024-06-01';  
   select * from bank.LoginCredentials

UPDATE bank.LoginCredentials
SET DateTime = DATEADD(MONTH, 4 - 8, DateTime),
    LastLogin = DATEADD(MONTH, 4 - 8, LastLogin)
WHERE DateTime >= '2024-09-01' AND DateTime < '2024-10-01'
   OR LastLogin >= '2024-09-01' AND LastLogin < '2024-10-01';

 
 ----------------------------------------------------------------------------

select * from bank.UserSessions order by StartDateTime

UPDATE bank.userSessions
SET StartDateTime = DATEADD(MONTH, 4 -5 , StartDateTime),
    EndDateTime = DATEADD(MONTH, 4 - 5, EndDateTime)
WHERE StartDateTime >= '2024-07-01' AND StartDateTime < '2024-08-01'
   OR EndDateTime >= '2024-07-01' AND EndDateTime < '2024-08-01';


UPDATE bank.UserSessions
SET StartDateTime = DATEADD(MONTH, 4 - 6, StartDateTime),
    EndDateTime = DATEADD(MONTH, 4 - 6, EndDateTime)
WHERE StartDateTime >= '2024-08-01' AND StartDateTime < '2024-09-01'
   OR EndDateTime >= '2024-08-01' AND EndDateTime < '2024-09-01';

UPDATE bank.UserSessions
SET StartDateTime = DATEADD(MONTH, 4-7, StartDateTime),
    EndDateTime = DATEADD(MONTH, 4 - 7, EndDateTime)
WHERE StartDateTime >= '2024-09-01' AND StartDateTime < '2024-10-01'
   OR EndDateTime >= '2024-09-01' AND EndDateTime < '2024-10-01';

   UPDATE bank.UserSessions
SET StartDateTime = DATEADD(MONTH, 4-8, StartDateTime),
    EndDateTime = DATEADD(MONTH, 4 -8, EndDateTime)
WHERE StartDateTime >= '2024-10-01' AND StartDateTime < '2024-11-01'
   OR EndDateTime >= '2024-10-01' AND EndDateTime < '2024-11-01';


--------------------------------------------------------------------------------------------
--to check the uniqueness of the sample
select Email,Count(*) from bank.Employees group by Email having Count(Email)>1

select * from bank.Employees where Email='chris78brown87@gmail.com'
select * from bank.Employees where Email='jane50smith50@gmail.com' 
select * from bank.Employees where Email='john49doe49@gmail.com'
select * from bank.Employees where Email='michael51johnson51@gmail.com' 
select * from bank.Employees where Email='emily46davis46@gmail.com'
select * from bank.Employees where Email='pat48taylor48@gmail.com'
Update bank.Employees
Set Email='chris78brown89@gmail.com' where  EmployeeID=197;
Update bank.Employees
Set Email='jane50smith550@gmail.com' where  EmployeeID=200;
Update bank.Employees
Set Email='john49doe94@gmail.com' where  EmployeeID=199;
Update bank.Employees
Set Email='pat48taylor70@gmail.com'   where  EmployeeID=201;
Update bank.Employees
Set Email='emily46davis64@gmail.com'  where  EmployeeID=196;
Update bank.Employees
Set Email='pat48taylor78@gmail.com' where  EmployeeID=198;


--employee serial numbers become unique
CREATE TRIGGER bank.TriggerSeriyaNforEmp
ON bank.Employees
AFTER Insert
AS
BEGIN
    UPDATE e1
    SET e1.SeriyaN =c3.ShortName+Right(e1.PhoneNumber,6)
	From bank.Employees e1 
	join bank.Cities c2 on c2.CityID=e1.CityID 
	join bank.Countries c3 on c3.CountryID=c2.CountryID
	join inserted i on i.EmployeeID = e1.EmployeeID;
END;

select SeriyaN,Count(*) from bank.Employees group by SeriyaN having count(*)>1

-----------------------------------------------------------------------------------------
select * from bank.Cards
--EXEC sp_rename 'bank.Cards.ExpiryDate', 'EndDate', 'COLUMN';


--Create a procedure DateUpdated to be updated directly
CREATE PROCEDURE bank.PROCDate
AS
BEGIN
    UPDATE bank.Cards
    SET UpdatedDate = DATEADD(MONTH, 3, CreatedDate);
END;

Exec bank.PROCDate

select * from bank.CardStatuses
select * from bank.CardsReasons
select * from bank.Cards

--the trigger for giving reason according to the status
CREATE TRIGGER bank.TriggeReasons
ON bank.Cards
AFTER Update
AS
BEGIN
    UPDATE c
    SET ReasonID = 
        CASE 
            WHEN i.StatusID IN (2, 3, 9) THEN 1
            WHEN i.StatusID = 4 THEN 4
            WHEN i.StatusID IN (5, 6) THEN 2
            WHEN i.StatusID = 7 THEN 3
            ELSE NULL
        END
    FROM bank.Cards c
    INNER JOIN inserted i ON c.CardID = i.CardID;
END;

--Determination of expired status
Update bank.Cards
Set StatusID=4 where EndDate<'2024-07-06'

CREATE PROCEDURE bank.UpdateStatusID
AS
BEGIN
    DECLARE @id INT = 1;
    DECLARE @currentStatusID INT = 1;
    DECLARE @maxRows INT = 2150;
    DECLARE @rowsUpdated INT = 0;

    WHILE @rowsUpdated < @maxRows
    BEGIN
        -- Update the StatusID column sequentially
        UPDATE Top(1) bank.Cards
        SET StatusID = @currentStatusID
        WHERE CardID= @id; -- Assuming there is an Id column to identify rows

        -- Increment counters
        SET @rowsUpdated = @rowsUpdated + 1;
        SET @id = @id + 1;

        -- Increment @currentStatusID and reset if it exceeds 9
        SET @currentStatusID = @currentStatusID + 1;
        IF @currentStatusID > 9
        BEGIN
            SET @currentStatusID = 1;
        END
    END
END
GO
EXEC bank.UpdateStatusID;


UPDATE bank.Cards
SET IssueDate = DATEADD(YEAR, 4 -7 , IssueDate),
    EndDate = DATEADD(Year, 4 - 6, EndDate),
	CreatedDate = DATEADD(Year, 4 - 6, CreatedDate)
WHERE IssueDate >= '2023-01-01' AND IssueDate < '2025-01-01'
   OR EndDate >= '2023-01-01' AND EndDate < '2025-01-01'
   OR CreatedDate>='2023-01-01' AND CreatedDate< '2025-01-01';


UPDATE bank.Cards
SET IssueDate = DATEADD(YEAR, 4 -8, IssueDate),
    EndDate = DATEADD(Year, 4 - 6, EndDate),
	CreatedDate = DATEADD(Year, 4 - 7, CreatedDate)
WHERE IssueDate >= '2025-01-01' AND IssueDate < '2027-01-01'
   OR EndDate >= '2025-01-01' AND EndDate< '2027-01-01'
   OR CreatedDate>= '2025-01-01' AND CreatedDate< '2027-01-01';


UPDATE bank.Cards
SET IssueDate = DATEADD(YEAR, 4 - 9, IssueDate),
    EndDate = DATEADD(Year, 4 - 7, EndDate),
	CreatedDate = DATEADD(Year, 4 - 9, CreatedDate)
WHERE IssueDate >= '2027-01-01' AND IssueDate < '2029-01-01'
   OR EndDate >= '2027-01-01' AND EndDate<= '2029-12-31'
   OR CreatedDate>='2027-01-01' AND CreatedDate< '2029-01-01';

  UPDATE bank.Cards
SET IssueDate = DATEADD(YEAR, 4 - 9, IssueDate),
    EndDate = DATEADD(Year, 4 - 10, EndDate),
	CreatedDate = DATEADD(Year, 4 - 9, CreatedDate)
WHERE IssueDate >= '2029-01-01' 
   OR EndDate >= '2030-01-01' AND EndDate< '2032-02-01'
   OR CreatedDate>= '2029-01-01' ;
     
--------------------------------------------------------------------------------


	select * from bank.SendNotifications
	select * from bank.NotificationsMethods

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Day, -29, SendDateTime),
--WHERE SendDateTime >= '2024-06-28' AND SendDateTime < '2024-07-06'
 

-- select * from bank.SendNotifications
--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -1, SendDateTime)
--WHERE SendDateTime >= '2024-07-06' AND SendDateTime < '2024-08-06'
 

--  UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -1, SendDateTime)
--WHERE SendDateTime >= '2024-08-06' AND SendDateTime < '2024-09-06'

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -3, SendDateTime)
--WHERE SendDateTime >= '2024-09-06' AND SendDateTime < '2024-10-06'

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Day, -133, SendDateTime)
--WHERE SendDateTime >= '2024-10-06' AND SendDateTime < '2024-11-06'


--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -5, SendDateTime)
--WHERE SendDateTime >= '2024-11-06' AND SendDateTime < '2024-12-06'

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -6, SendDateTime),
--WHERE SendDateTime <= '2025-06-01' AND SendDateTime > '2024-12-06'

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(Month, -18, SendDateTime),
--WHERE SendDateTime >= '2025-06-01' AND SendDateTime < '2025-12-31'

---- Update for November 2024 to November 2025
--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -5, SendDateTime)
--WHERE SendDateTime >= '2024-11-06' AND SendDateTime < '2024-12-06';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -6, SendDateTime)
--WHERE SendDateTime >= '2025-01-01' AND SendDateTime < '2025-02-01';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -6, SendDateTime)
--WHERE SendDateTime >= '2025-02-01' AND SendDateTime < '2025-03-01';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -6, SendDateTime)
--WHERE SendDateTime >= '2025-03-01' AND SendDateTime < '2025-04-01';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -6, SendDateTime)
--WHERE SendDateTime >= '2025-04-01' AND SendDateTime < '2025-05-01';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -6, SendDateTime)
--WHERE SendDateTime >= '2025-05-01' AND SendDateTime < '2025-06-01';

---- Update for June 2025 to December 2036
--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(MONTH, -18, SendDateTime)
--WHERE SendDateTime >= '2025-06-01' AND SendDateTime < '2025-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -11, SendDateTime)
--WHERE SendDateTime >= '2025-12-31' AND SendDateTime < '2026-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -13, SendDateTime)
--WHERE SendDateTime >= '2026-12-31' AND SendDateTime < '2027-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -18, SendDateTime)
--WHERE SendDateTime >= '2027-12-31' AND SendDateTime < '2028-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -17, SendDateTime)
--WHERE SendDateTime >= '2028-12-31' AND SendDateTime < '2029-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -15, SendDateTime)
--WHERE SendDateTime >= '2029-12-31' AND SendDateTime < '2030-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -14, SendDateTime)
--WHERE SendDateTime >= '2030-12-31' AND SendDateTime < '2031-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -14, SendDateTime)
--WHERE SendDateTime >= '2031-12-31' AND SendDateTime < '2032-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -18, SendDateTime)
--WHERE SendDateTime >= '2032-12-31' AND SendDateTime < '2033-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -11, SendDateTime)
--WHERE SendDateTime >= '2033-12-31' AND SendDateTime < '2034-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -18, SendDateTime)
--WHERE SendDateTime >= '2034-12-31' AND SendDateTime < '2035-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -12, SendDateTime)
--WHERE SendDateTime >= '2035-12-31' AND SendDateTime < '2036-12-31';

--UPDATE bank.SendNotifications
--SET SendDateTime = DATEADD(YEAR, -10, SendDateTime)
--WHERE SendDateTime >= '2036-12-31' AND SendDateTime < '2037-12-31';
--select * from bank.SendNotifications
--select * from bank.Transactions

--We create a temporary table to hold a 1-month date range
create table ##TableTemporary(id INT IDENTITY(1,1) Primary key,vaxt DateTime);

-- Inserting some sample datetime values(in Project.2level)

--We insert data by itself
INSERT INTO ##TableTemporary (vaxt)
SELECT vaxt FROM ##TableTemporary;

--data is inserted from the temporary table to other tables
update tr
set tr.TransactionDate=t.vaxt from bank.Transactions tr join ##TableTemporary t on t.id=tr.TransactionID where tr.TransactionID between 1 and 3133

Update  s
set s.SendDateTime=t.vaxt from bank.SendNotifications s join ##TableTemporary t on t.id=s.NotificationID where  s.NotificationID between 1 and 1808

Update n
set n.SendDateTime=t.vaxt from bank.NotificationsReceipts n join ##TableTemporary t on t.id=n.ReceiptID where n.ReceiptID between  1 and 1510



--I create a trigger to ensure the uniqueness of phone numbers
CREATE TRIGGER bank.TriggerforPhoneNumber
ON bank.SendNotifications
After INSERT
AS
BEGIN
    Update s
    SET PhoneNumber='+1222333' + RIGHT('0000' + CAST(i.NotificationID AS VARCHAR(4)), 4) 
    FROM bank.SendNotifications s join inserted i on i.NotificationID=s.NotificationID;
END;


select * from bank.SendNotifications
--Customers who do not use the application do not interact with the application
select NotificationID from bank.SendNotifications where NotificationMethodID=4 and CustomerID between 101 and 151 
select NotificationID from bank.SendNotifications where NotificationMethodID=4 and CustomerID between 949 and 996
Update bank.SendNotifications
SET NotificationMethodID=1 where NotificationMethodID=4 and CustomerID between 101 and 151;
Update bank.SendNotifications
SET NotificationMethodID=3 where NotificationMethodID=4 and CustomerID between 949 and 996;

------------------------------------------------------------------------------------------------------------------------------------------------
--customers who do not use the application do not interact with the application
select * from bank.NotificationsReceipts
WITH UpdatedDates AS (
   select n.ReceiptID,n.NotificationID,c.CustomerID,n.NotificationMethodID from bank.NotificationsReceipts n 
   join bank.SendNotifications s on s.NotificationID=n.NotificationID 
   join bank.Customers c on c.CustomerID=s.CustomerID
   where n.NotificationMethodID=4 and c.CustomerID  between 101 and 151 

)
UPDATE bank.NotificationsReceipts
SET NotificationMethodID=1 where NotificationID=ANY(Select NotificationID from Updateddates)

select n.ReceiptID,n.NotificationID,c.CustomerID,n.NotificationMethodID from bank.NotificationsReceipts n 
join bank.SendNotifications s on s.NotificationID=n.NotificationID 
join bank.Customers c on c.CustomerID=s.CustomerID
where n.NotificationMethodID=4 and c.CustomerID  between 101 and 151

select n.ReceiptID,n.NotificationID,c.CustomerID from bank.NotificationsReceipts n 
join bank.SendNotifications s on s.NotificationID=n.NotificationID 
join bank.Customers c on c.CustomerID=s.CustomerID
where n.NotificationMethodID=4 and c.CustomerID between 949 and 996 



-----------------------------------------------------------------------------------------------------------------------------------

--Places the details of credit accounts in the deposit table
CREATE TRIGGER bank.triggerDeposits
ON bank.Accounts
AFTER INSERT
AS
BEGIN
    INSERT INTO bank.Deposits (bank.Deposits.AccountID, bank.Deposit.CustomerID,bank.Deposits.CurrencyID)
    SELECT inserted.AccountID, inserted.CustomerID,inserted.CurrencyID FROM inserted  
	where inserted.AccountTypeID in (2,3,6,9,10)
END;

--Places the details of credit accounts in the credit table
CREATE TRIGGER bank.triggerLoans
ON bank.Accounts
AFTER INSERT
AS
BEGIN
    INSERT INTO bank.Loans (bank.Loans.AccountID, bank.Loans.CustomerID,bank.Loans.CurrencyID)
    SELECT inserted.AccountID, inserted.CustomerID,inserted.CurrencyID FROM inserted  
	where inserted.AccountTypeID in (4,5,11,12)
END;


--The extension date is 6 months
Update bank.Loanss
Set DateExtension=DateAdd(Month,6,EndDate)
select * from bank.Loans

-------------------------------------------------------------------------------------------------------------
--I store createddate and updatedate in an existing table
create table storeddatetime(
id int identity(1,1) primary key,
CreatedDate DateTime,
UpdatedDate DateTime
);

insert into storeddatetime(CreatedDate,UpdatedDate) select CreatedDate,UpdatedDate from storeddatetime
select * from storeddatetime

--We insert from that table to the other tables
Update a
set a.DateCreated=s.CreatedDate,
    a.DateUpdated=s.UpdatedDate 
from bank.Accounts a join storeddatetime s on s.id=a.AccountID where  a.AccountID between 1 and 2500

	Update l 
set l.DateCreated=s.CreatedDate,
    l.DateUpdated=s.UpdatedDate
from bank.Loans l join storeddatetime s on s.id=l.LoanID where l.LoanID between 1 and 822


Update D
set D.DateCreated=s.CreatedDate,
    D.DateUpdated=s.UpdatedDate
from bank.Deposits D join storeddatetime s on s.id=D.DepositID where D.DepositID between 1 and 1049

--Since there are no customer branches in the account table, a join is needed to link the branches
CREATE PROCEDURE bank.BranchIDforLoanss
AS
BEGIN
    UPDATE l
    SET l.BranchID = c.BranchID
    FROM bank.Loans l
    jOIN bank.Accounts a  ON a.AccountID = l.AccountID 
    join bank.Customers c on c.customerID=l.CustomerID 
END
GO

EXEC bank.BranchIDforLoanss

--created temporary table
create table ##Test(
LoanID INT Primary Key , 
LoanTypeID INT, 
APR INT, 
InterestRate INT, 
LoanStatusID INT, 
CurrencyID INT,
DateCreated datetime, 
DateUpdated DateTIME, 
StartDate DateTime, 
EndDate Datetime, 
DateExtension datetime, 
CreatedUser INT, 
UpdatedUser INT, 
ReasonID int);

--select * from ##Test

--and I update the data in the empty columns of the credit table

UPDATE L
SET L.LoantypeID=T.LoanTypeID, 
    L.APR=T.APR,
    L.InterestRate=T.InterestRate,
	L.LoanStatusID=T.LoanStatusID,
	L.EndDate=T.EndDate,
	L.DateExtension=T.DateExtension,
	L.CreatedUser=T.CreatedUser,
	L.UpdatedUser=T.UpdatedUser,
	L.ReasonID=T.ReasonID
FROM bank.Loans AS L
JOIN ##Test AS T ON T.LoanID = L.LoanID
where L.LoanID between 1 and 822

select * from ##Test
select * from bank.Loans

-----------------------------------------------------------------------------------------------------------------

--I do the same for the Deposits table as I did for the Loans table

select * from bank.Deposits

CREATE PROCEDURE bank.BranchIDforDeposits
AS
BEGIN
    UPDATE d
    SET d.BranchID = c.BranchID
    FROM bank.Deposits d
    jOIN bank.Accounts a  ON a.AccountID = d.AccountID 
    join bank.Customers c on c.customerID=d.CustomerID 
END
GO

EXEC bank.BranchIDforDeposits

select * from bank.Deposits
select * from bank.DepositTypes
select * from bank.DepositStatuses
select * from bank.DepositReasons

create table ##Test2
(
DepositID INT Primary Key , 
DepositTypeID INT, 
DepositAmount Decimal(10,2),  
StartDate DateTime, 
EndDate Datetime, 
ExpiryDate datetime,
DateCreated datetime, 
DateUpdated DateTIME, 
CreatedUser INT, 
UpdatedUser INT, 
DepositStatusID INT,
ReasonID int
);

select * from ##Test2
select * from bank.Deposits
select * from bank.Loans
UPDATE D
SET D.DepositTypeID=T.DepositTypeID, 
    D.DepositAmount=T.DepositAmount,
	D.StartDate=T.StartDate,
	D.EndDate=T.EndDate,
	D.ExpiryDate=T.ExpiryDate,
	D.DateCreated=T.DateCreated,
	D.DateUpdated=T.DateUpdated,
	D.CreatedUser=T.CreatedUser,
	D.UpdatedUser=T.UpdatedUser,
	D.DepositStatusID=T.DepositStatusID,
	D.ReasonID=T.ReasonID
FROM bank.Deposits AS D
JOIN ##Test2 AS T ON T.DepositID = D.DepositID
where D.DepositID between 1 and 1049



Update l 
set l.StartDate=Convert(Date,s.CreatedDate)
from bank.Loans l join storeddatetime s on s.id=l.LoanID where l.LoanID between 1 and 822

Update bank.Deposits 
set ExpiryDate=DateADD(Month,1,EndDate) where DepositID between 1 and 1049

select * from bank.DepositsTypes
Update bank.Deposits 
set DateCreated=DateADD(Year,-1,StartDate) where DepositID between 1 and 1049

--set reasons by status
Update bank.Deposits 
set ReasonID=NULL where DepositStatusID in (1,3,4)
select * from bank.DepositTypes
-------------------------------------------------------------------------------------------
--Adjustment of periods according to types of deposits
Create procedure bank.ProcForEndDate
As
begin
     update bank.Deposits
	 Set EndDate=case
	 when DepositTypeID=2 then DATEADD (Month,3,StartDate)
	 when DepositTypeID=3 then DATEADD (Month,6,StartDate)
	 when DepositTypeID=4 then DATEADD (Month,9,StartDate)
	 when DepositTypeID=3 then DATEADD (Month,12,StartDate)
	 when DepositTypeID=3 then DATEADD (Month,24,StartDate)
	 else NULL
	 end
 end

Exec bank.ProcForEndDate

select * from bank.Loans
select * from bank.Deposits
select * from bank.DepositTypes

--I try to make the dates close to reality
Update bank.Loans
set StartDate=DateADD(Year,-1,StartDate) 

Update bank.Loans
set EndDate=DateADD(Year,3,StartDate) 

-------------------------------------------------------------------------------------------------
--procedures for determining loan repayments
CREATE Procedure bank.ProcedureforInterestRate
AS
BEGIN
    UPDATE lp
    SET lp.InterestAmount = i.InterestRate*lp.PrincipalAmount/100
	From bank.LoanPayments lp
    join bank.Loans i on i.LoanID=lp.LoanID 
END;
Exec bank.ProcedureforInterestRate

CREATE Procedure bank.ProcedurePaidAmount
AS
BEGIN
    UPDATE lp
    SET lp.PaidAmount = i.InterestRate*lp.PrincipalAmount/100+lp.PrincipalAmount
	From bank.LoanPayments lp
    join bank.Loans i on i.LoanID=lp.LoanID 
END;
Exec bank.ProcedurePaidAmount

Update bank.LoanPayments
set PaidDate=DateAdd(Year,-2,PaidDate)
--delete from bank.LoanPayments where LoanpaymentID in (2223,2224,2225,2226)
--delete from bank.LoanPayments where LoanpaymentID in (2155,2156,2157,2158)
Update bank.LoanPayments
set PaymentDate=DateAdd(Month,-1,PaymentDate)

select * from bank.LoanPayments

---------------------------------------------------------------------------------------------
--Table to randomly assign updateuser and createduser
create table testable(
id INT IDENTITY(1,1) PRIMARY KEY,
CreatedUser INT,
UpdatedUser INT)

insert into testable 
Select CreatedUser,UpdatedUser from testable

select * from  testable

--updateuser and createduser are inserted into other tables

UPDATE bank.Deposits
SET CreatedUser = testable.CreatedUser,
    UpdatedUser = testable.UpdatedUser
FROM bank.Deposits
JOIN testable ON bank.Deposits.DepositID = testable.id where bank.Deposits.DepositID between 1 and 1049
select * from bank.Deposits

Update l
Set l.CreatedUser=t.CreatedUser,l.UpdatedUser=t.UpdatedUser from bank.Loans l join testable t on t.id=l.LoanID where l.LoanID between  1 and 822
select * from bank.Loans

Update c
Set c.CreatedUser=t.CreatedUser,c.UpdatedUser=t.UpdatedUser from bank.Customers c join testable t on t.id=c.CustomerID where c.CustomerID between  1 and 1008
select * from bank.Customers

Update c
Set c.CreatedUser=t.CreatedUser,c.UpdatedUser=t.UpdatedUser from bank.CustomerTypes c join testable t on t.id=c.CustomerTypeID where c.CustomerTypeID between  1 and 9 
select * from bank.CustomerTypes

Update p
Set p.CreatedUser=t.CreatedUser,p.UpdatedUser=t.UpdatedUser from bank.Positions p join testable t on t.id=p.PositionID where p.PositionID between  1 and 52
select * from bank.Positions

Update d
Set d.CreatedUser=t.CreatedUser,d.UpdatedUser=t.UpdatedUser from bank.Departments d join testable t on t.id=d.DepartmentID where d.DepartmentID between  1 and 26
select * from bank.Departments

Update a
Set a.CreatedUser=t.CreatedUser,a.UpdatedUser=t.UpdatedUser from bank.Accounts a join testable t on t.id=a.AccountID where a.AccountID between  1 and 2500
select * from bank.Accounts

Update a
Set a.CreatedUser=t.CreatedUser,a.UpdatedUser=t.UpdatedUser from bank.AccountTypes a join testable t on t.id=a.AccountTypeID where a.AccountTypeID between  1 and 12
select * from bank.AccountTypes

Update crd
Set crd.CreatedUser=t.CreatedUser,crd.UpdatedUser=t.UpdatedUser from bank.Cards crd join testable t on t.id=crd.CardID where crd.CardID between  1 and 2150
select * from bank.Cards

Update bank.Transactions
set ReasonID=Null where StatusID in (1,2)
select * from bank.TransactionsStatus

-----------------------------------------------------------------------------------------------------------------------------------------------------------


select * from bank.Transactions where TransactionTypeID=2 and CreditAccount=NULL

--Create Temporary Table and I drop the accounts into a temporary table
--I keep in mind that certain accounts have more transactions and some have not
create table ##TempAccount
(id int Identity(1,1) Primary key,
 AccountN nvarchar(250));

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 1 and 1500

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 34 and  227

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 400 and 1100

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 700 and 800

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 600 and 900

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 500 and 600
 
 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 600 and 800

 insert into ##TempAccount (AccountN) 
 select AccountNumber from bank.Accounts where AccountID between 50 and 83

 
 select * from ##TempAccount
 select * from bank.Accounts 

----------------------------------------------------------------------------------------------------------------- 

--And now we update from the temporary table to the Transaction table
Update t
Set t.DebitAccount=a.AccountN
from bank.Transactions t join ##TempAccount a on a.id=t.TransactionID

--Considering that my client is the party transferring money to his transfer account.
Update bank.Transactions
Set DebitAccount='987654321098'+Right('0000'+Cast(TransactionID as varchar(50)),4)
where TransactionTypeID=2 and TransactionID between 1080 and 2020
Update t
Set t.CreditAccount=a.AccountN
from bank.Transactions t join ##TempAccount a on a.id=t.TransactionID 
where TransactionTypeID=2 and TransactionID between 1080 and 2020


--There are cases where both sides are my clients
Update t
Set t.CreditAccount='ACC'+Right('1000'+Cast(a.TransactionID+3 as varchar(50)),4)
from bank.Transactions t join bank.Transactions a on a.TransactionID =t.TransactionID 
where t.TransactionTypeID=2 and t.TransactionID between 700 and 900
select * from bank.Transactions



--final revisions to the Cards table 
Select * from bank.Cards
Select * from bank.Cards where IssueDate<CreatedDate
Update bank.Cards
set IssueDate=DateAdd(Month,5,IssueDate)
Update bank.Cards
set CreatedDate=DateAdd(Month,-5,CreatedDate)
Update bank.Cards
set CreatedDate=DateAdd(Year,-2,CreatedDate) 


--final revisions to the Cities table  
Select * from bank.Cities
UPDATE c
SET c.PostalCode = o.ShortName + CAST(c.cityID AS VARCHAR(10)) + c.PostalCode
FROM bank.Cities c
JOIN bank.Countries o ON o.CountryID = c.CountryID;


--final revisions to the Loans table
Update bank.Loans
set DateCreated=DateAdd(Month,-17,DateCreated)
Update bank.Loans
set DateExtension=DateAdd(Month,12,EndDate)
Update bank.Loans
set ReasonID=NULL where LoanStatusID in (1,2,4)


--final revisions to the Branches table
Update bank.Branches
set PhoneNumber=PhoneNumber+Cast(BranchID as Varchar(50))
select * 
--final revisions to the CustomerTypes table
Update bank.CustomerTypes
set DateUpdated=DateAdd(Month,8,DateUpdated)
select * from bank.Transactions
select * from bank.TransactionTypes
--final revisions to the CustomerTypes table
Update bank.Customers
set PhoneNumber=PhoneNumber+Cast(CustomerID as Varchar(50))
Update bank.Customers
set Email=Cast(CustomerID as Varchar(50))+Email

--final revisions to the LoginCredentials table
select * from bank.LoginCredentials
Update bank.LoginCredentials
set OTP=RIGHT('0000' + CAST(UserID AS VARCHAR(4)), 4) 


--final revisions to the LoanPayments table
create table bank.LoanPaymentsStatuses
(
 StatusID int Primary key,
 StatusName varchar(250)
 );


 Alter table bank.LoanPayments
 add StatusID int
 Alter table bank.LoanPayments
 Add constraint fk Foreign key(StatusID) References bank.LoanPaymentsStatuses(StatusID)
 insert into bank.LoanPaymentsStatuses values
 (1,'successful'),
 (2,'failed');



 select * from bank.LoanPayments
 select * from bank.LoanStatuses
 CREATE PROCEDURE bank.UpdatedddStatusID
AS
BEGIN
    DECLARE @id INT = 1;
    DECLARE @currentStatusID INT = 1;
    DECLARE @maxRows INT = 2473;
    DECLARE @rowsUpdated INT = 0;

    WHILE @rowsUpdated < @maxRows
    BEGIN
        -- Update the StatusID column sequentially
        UPDATE Top(1) bank.LoanPayments
        SET StatusID = @currentStatusID
        WHERE LoanPaymentID= @id; -- Assuming there is an Id column to identify rows

        -- Increment counters
        SET @rowsUpdated = @rowsUpdated + 1;
        SET @id = @id + 1;

        -- Increment @currentStatusID and reset if it exceeds 9
        SET @currentStatusID = @currentStatusID + 1;
        IF @currentStatusID > 2
        BEGIN
            SET @currentStatusID = 1;
        END
    END
END
GO
EXEC bank.UpdatedddStatusID;

update lp
SET lp.StatusID = CASE 
                      WHEN l.LoanStatusID IN (3, 5, 7, 10) THEN 2
                      ELSE 1
                 END
FROM bank.LoanPayments lp
JOIN bank.Loans l ON l.LoanID = lp.LoanID;
select * from bank.LoanPayments

----------------------------------------------------------------------------------
Select * from bank.Transactions
select * from bank.Accounts
UPDATE bank.Transactions
SET CustomerID = a.CustomerID
FROM bank.Transactions t
JOIN bank.Accounts a ON t.DebitAccount = a.AccountNumber OR t.CreditAccount = a.AccountNumber


UPDATE t
SET t.StatusID = 3
FROM bank.Transactions t
JOIN bank.Accounts a ON a.CustomerID = t.CustomerID 
WHERE a.AccountStatusID Not in (1,4,7);


UPDATE t
SET t.StatusID = 2
FROM bank.Transactions t
JOIN bank.Accounts a ON a.CustomerID = t.CustomerID 
WHERE a.AccountStatusID in (1,4,7);

select AccountStatusID,Count(*) from bank.Accounts group by AccountStatusID
ALTER TABLE bank.Transactions
ADD CustomerID INT ;

ALTER TABLE bank.Transactions
ADD FOREIGN KEY (CustomerID) REFERENCES bank.Customers(CustomerID)

CREATE PROCEDURE bank.rReasonID
AS
BEGIN
    DECLARE @id INT = 1;
    DECLARE @currentReasonID INT = 1;
    DECLARE @maxRows INT = 3133;
    DECLARE @rowsUpdated INT = 0;

    WHILE @rowsUpdated < @maxRows
    BEGIN
        UPDATE Top(1) bank.Transactions
        SET ReasonID = @currentReasonID
        WHERE TransactionID= @id; 
        SET @rowsUpdated = @rowsUpdated + 1;
        SET @id = @id + 1;
        SET @currentReasonID = @currentReasonID + 1;
        IF @currentReasonID > 7
        BEGIN
            SET @currentReasonID = 1;
        END
    END
END
GO
EXEC bank.rReasonID;


Update bank.Transactions
set ReasonID=NULL where StatusID=2

ALTER TABLE bank.Transactions
ADD CreatedUser INT ;

ALTER TABLE bank.Transactions
ADD FOREIGN KEY (CreatedUser) REFERENCES bank.Employees(EmployeeID)

ALTER TABLE bank.Transactions
ADD UpdatedUser INT ;

ALTER TABLE bank.Transactions
ADD FOREIGN KEY (UpdatedUser) REFERENCES bank.Employees(EmployeeID)

select * from bank.Transactions

select * from testable
insert into testable(CreatedUser,UpdatedUser)
select CreatedUser,UpdatedUser from testable 

Update a
Set a.CreatedUser=t.CreatedUser,a.UpdatedUser=t.UpdatedUser 
from bank.Transactions a 
join testable t on t.id=a.TransactionID where a.TransactionID between  1 and 3133


----------------------------------------------------------------------------------------------------------------------
--Convert currency values ​​as needed
CREATE FUNCTION bank.ConvertCurrency (
    @amount DECIMAL(18, 2),
    @fromCurrency NVARCHAR(10),
    @toCurrency NVARCHAR(10),
    @date DATE
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @fromRate DECIMAL(18, 2);
    DECLARE @toRate DECIMAL(18, 2);
    DECLARE @convertedAmount DECIMAL(18, 2);

    -- Get rates for fromCurrency and toCurrency
    SELECT
        @fromRate = CASE @fromCurrency
                        WHEN 'USD' THEN USD
                        WHEN 'AZN' THEN AZN
                        WHEN 'TL' THEN TL
                        WHEN 'EURO' THEN EURO
                    END,
        @toRate = CASE @toCurrency
                        WHEN 'USD' THEN USD
                        WHEN 'AZN' THEN AZN
                        WHEN 'TL' THEN TL
                        WHEN 'EURO' THEN EURO
                    END
    FROM
        bank.CurrencyRates
    WHERE
        [Date] = @date;

    -- Convert amount
    SET @convertedAmount = CASE
                                WHEN @fromCurrency = 'USD' THEN @amount / @fromRate
                                WHEN @fromCurrency = 'AZN' THEN @amount / @fromRate
                                WHEN @fromCurrency = 'TL' THEN @amount / @fromRate
                                WHEN @fromCurrency = 'EURO' THEN @amount / @fromRate
                            END * @toRate;

    RETURN @convertedAmount;
END;

Update bank.CurrencyRates
Set Date=GETDATE()
Select * from bank.CurrencyRates

--------------------------------------------------------------------------
select * from bank.Cards
select * from bank.Transactions

ALTER TABLE bank.Cards
ADD LastUsedDate DateTime ;

UPDATE c
SET c.LastUsedDate= t.TransactionDate
FROM bank.Cards c
JOIN bank.Transactions t ON t.TransactionID = c.CardID where c.CardID between 1 and 3133

----------------------------------------------------------------------------------------------------------------------------------
select  * from bank.Loans
UPDATE bank.LoanPayments
SET PaymentDate = DATEADD(MONTH, -3, PaymentDate)
WHERE LoanPaymentID BETWEEN 2431 AND 2473;

UPDATE bank.LoanPayments
SET PaymentDate = DATEADD(MONTH, -15, PaymentDate)
WHERE LoanPaymentID BETWEEN  1 and 100 ;

UPDATE bank.LoanPayments
SET PaymentDate = DATEADD(MONTH, -15, PaymentDate)
WHERE LoanPaymentID BETWEEN  970 and 1100 ;


--select * from bank.Loans where CustomerID=567

--------------------------------------------------------------------------------------------------------------------
select * from bank.Transactions
Update bank.Transactions
set CreditAccount='ACC1002' where TransactionID=1


select * from bank.Cards

Alter table bank.Cards
Add ExpiryDate DateTime
Update bank.Cards
Set ExpiryDate=DateAdd(Month,6,EndDate)



Update bank.UserSessions
Set EndDateTime=NULL where SessionID in (2,4,8,16,64,400,800)

----------------------------------------------------------------------------------------------------------------------------------------------------------
select * from bank.PayeesTypes
select * from bank.Transactions where TransactionTypeID=3
select * from bank.Transactions where TransactionTypeID=2
select * from bank.Transactions where TransactionTypeID=5
UPDATE bank.Transactions
SET TransactionTypeID = 2,
    PayeesTypeID = NULL,
    MerchantProvider = 'Bank Transfer'
WHERE TransactionTypeID = 3
  AND CreditAccount IS NOT NULL;

  UPDATE bank.Transactions
SET CreditAccount='2347658901234567'
WHERE TransactionTypeID = 2
  AND CreditAccount IS NULL;

--PayeesTypeID NULL olsun mu?


UPDATE bank.Transactions
SET TransactionTypeID = 5
WHERE TransactionTypeID = 2 and
    PayeesTypeID = 3 and
    MerchantProvider = 'Credit Card Payment'


select * from bank.TransactionTypes
delete from bank.TransactionTypes where TransactionTypeID=3

----------------------------------------------------------------------------------------------------------------------------------------------------------
--Create another tables
CREATE TABLE bank.ExchangeRates (
    RateID INT Identity(1,1) PRIMARY KEY ,
    FromCurrencyID INT NOT NULL,
    ToCurrencyID INT NOT NULL,
    BuyRate DECIMAL(10, 4) NOT NULL,
    SellRate DECIMAL(10, 4) NOT NULL,
    RateDateTime DATETIME DEFAULT Getdate(),
    FOREIGN KEY (FromCurrencyID) REFERENCES bank.Currencies(CurrencyID),
    FOREIGN KEY (ToCurrencyID) REFERENCES bank.Currencies(CurrencyID)
);

CREATE TABLE bank.ExchangeRateTypes (
    TypeID INT PRIMARY KEY IDENTITY,
    TypeName VARCHAR(50) NOT NULL UNIQUE
);
 
CREATE TABLE bank.ExchangeTransactions (
    ExchangeTransactionID INT PRIMARY KEY IDENTITY,
    AccountID INT NOT NULL,
	RateID INT NOT NULL,
    FromAmount DECIMAL(15, 2) NOT NULL,
    ToAmount DECIMAL(15, 2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    RateTypeID INT NOT NULL,
	EmployeeID INT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES bank.Employees(EmployeeID),
    FOREIGN KEY (AccountID) REFERENCES bank.Accounts(AccountID),
    FOREIGN KEY (RateTypeID) REFERENCES bank.ExchangeRateTypes(TypeID),
	FOREIGN KEY (RateID) REFERENCES bank.ExchangeRates(RateID)
);

--------------------------------------------------------------------------------------------------------------
create table ##TableTemporarry(id INT IDENTITY(1,1) Primary key,vaxt DateTime);

-- Inserting some sample datetime values(in Project.2level)

--We insert data by itself
INSERT INTO ##TableTemporarry (vaxt)
SELECT vaxt FROM ##TableTemporarry;


Update ext
Set ext.TransactionDate=t.vaxt from bank.ExchangeTransactions ext 
join ##TableTemporarry t on t.id=ext.ExchangeTransactionID
where ext.ExchangeTransactionID between 1 and 1013


CREATE TRIGGER bank.TriggerforExchangeTransactions 
ON bank.ExchangeTransactions
AFTER INSERT
AS
BEGIN
    UPDATE ext
    SET ext.ToAmount = 
   CASE 
    WHEN rt.TypeID = 1 THEN ext.FromAmount * exr.BuyRate
    WHEN rt.TypeID = 2 THEN ext.FromAmount * exr.SellRate
   END
    FROM inserted ins
    JOIN bank.ExchangeTransactions ext ON ins.ExchangeTransactionID = ext.ExchangeTransactionID
    JOIN bank.ExchangeRates exr ON ext.RateID = exr.RateID
    JOIN bank.ExchangeRateTypes rt ON ext.RateTypeID = rt.TypeID;
END;

select * from bank.ExchangeTransactions
select * from bank.ExchangeRates
select * from bank.ExchangeRateTypes