-- i have created database for my Project
CREATE DATABASE HARSH_BANK_PROJECT;
GO

USE HARSH_BANK_PROJECT;
GO

--I have created my own schema
CREATE SCHEMA HR;
GO

/*First i have created only those tables which have only primary keys,
then i have created those tables which have Primary Keys and Primary Keys both,
I have also rename some columns as per my understanding for which i have inserted comment in that table.*/ 

CREATE TABLE HR.FailedTransactionErrorType
        (FailedTransactionErrorTypeID TINYINT PRIMARY KEY NOT NULL,
		 FailedTransactionDescription VARCHAR (50) NOT NULL); 
GO
--HERE I HAVE CONSIDERED ONLY TWO TRANSACTION ERROR
INSERT INTO HR.FailedTransactionErrorType
VALUES (51,'Insufficient Balance'),
		(52,'Added Beneficiary is Not Active Yet')

GO
/*In this Table i have renamed some of the columns*/
CREATE TABLE HR.LoginErrorLog
		(LoginErrorID INT PRIMARY KEY NOT NULL, --here renamed column as LoginErrorID,was given ErrorLoginID. 
		 LoginErrorTime DATETIME,--here renamed column as LoginErrorTime,was given ErrorTime.
		 LoginErrorXML VARCHAR (30)); --here renamed column as LoginErrorXML,was given FailedTransactionXML.
GO
INSERT INTO HR.LoginErrorLog--Here i have considered two login errors
VALUES	(1001,'20170802 07:45:02.012','User name does not exist'),
		(1002,'20170216 06:50:04.023','Incorrect Username/Password'),
		(1003,'20170216 12:45:04.054','Incorrect Username/Password');
GO

CREATE TABLE AccountStatusType
	   (AccountStatusTypeID TINYINT PRIMARY KEY NOT NULL,
	    AccountStatusDescription VARCHAR (30) NOT NULL);
GO
INSERT INTO AccountStatusType --Here i have considered three kind of account status.
VALUES	(1,'OPEN'),
		(0,'CLOSE'),
		(2,'INACTIVE');
GO

CREATE TABLE HR.TransactionType
       (TransactionTypeID TINYINT PRIMARY KEY NOT NULL,
	   TransactionTypeName CHAR (10) NOT NULL,
	   TransactionTypeDescription VARCHAR (50) NOT NULL,
	   TransactionFeeAmount SMALLMONEY NOT NULL);
GO
INSERT INTO HR.TransactionType --Here i have considered four types of transaction type.
VALUES  (51,'BALANCE','See Money',0),
		(52,'WITHDRAW','Money Taken Out',0),
		(53,'DEPOSIT','Money Addition',0),
		(54,'TRANSFER','Money Transfer to Someone',10);
GO

CREATE TABLE HR.AccountType
	    (AccountTypeID TINYINT PRIMARY KEY NOT NULL,
		AccountTypeDescription VARCHAR (30) NOT NULL);
GO
INSERT INTO HR.AccountType
VALUES		(3,'SAVINGS'),
			(4,'CHECKING');
GO

CREATE TABLE HR.Employee
		(EmployeeID INT PRIMARY KEY NOT NULL,
		EmployeeFirstName VARCHAR (25) NOT NULL,
		EmployeeMiddleName VARCHAR (15),
		EmployeeLastName VARCHAR (25) NOT NULL,
		EmployeeIsManager BIT);
GO
INSERT INTO HR.Employee
VALUES		(7000,'JOHN','KAIR','POLKA',0),
			(7001,'MARRY','','HARWARD',1),
			(7002,'JOSEPH','ANDREW','VARGHASE',0);
GO

CREATE TABLE HR.SavingsInterestRates
		(InterestSavingsRateID INT PRIMARY KEY NOT NULL, --Here i have taken data type as 'INT' coz i have taken higher number for IDs.
		InterestRateValue NUMERIC(2,1) NOT NULL, --Here i have changed values for [p,s]
		InterestRateDescription VARCHAR (20) NOT NULL);
GO
INSERT INTO HR.SavingsInterestRates --Here i have taken 3 category of Interest Rate Values.
VALUES		(9001,5,'AMOUNT IS 0-4000'),
			(9002,6,'AMOUNT IS 4000-7000'),
			(9003,6.5,'AMOUNT>7000');
GO

CREATE TABLE HR.UserSecurityQuestions
		(UserSecurityQuestionID TINYINT PRIMARY KEY NOT NULL,
		UserSecurityQuestion VARCHAR (50) NOT NULL);
GO
INSERT INTO HR.UserSecurityQuestions --Here i have taken option of 3 security questions
VALUES		(7,'What is your pet name?'),
			(8,'What is your Place of Birth?'),
			(9,'What is your best friend name?');
GO

CREATE TABLE HR.UserLogins
		(UserLoginID INT PRIMARY KEY NOT NULL,
		 UserLogin CHAR (15) NOT NULL,
		 UserPassword VARCHAR (20) NOT NULL);
GO
INSERT INTO HR.UserLogins
VALUES	(100,'SW115','sw1234'),
		(101,'SG123','sg1234'),
		(102,'RP312','rp1234'),
		(103,'MV789','mv1234'),
		(104,'TS789','ts1234');
GO
		
CREATE TABLE HR.FailedTransactionLog
		(FailTransactionID INT PRIMARY KEY NOT NULL,
		FailedTransactionErrorTypeID TINYINT,
		FailedTransactionErrorTime DATETIME,
		FailedTransactionXML VARCHAR (30), 
		CONSTRAINT FK_FailedTansactionLogFailedTransactionErrorType
		FOREIGN KEY (FailedTransactionErrorTypeID)
		REFERENCES HR.FailedTransactionErrorType(FailedTransactionErrorTypeID));
GO
INSERT INTO HR.FailedTransactionLog
VALUES		(2001,51,'20170702 10:05:01.012','Insufficient Balance'),
			(2003,51,'20170907 08:30:04.011','Insufficient Balance'),
			(2005,52,'20171205 11:45:56.020','Added Beneficiaries not active');
GO

CREATE TABLE HR.TransactionLog
		(TransactionID INT PRIMARY KEY NOT NULL,
		 TransactionDate DATETIME NOT NULL,
		 TransactionTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES HR.TransactionType(TransactionTypeID),
		 TransactionAmount MONEY,
		 NewBalance MONEY,
		 AccountID INT NOT NULL FOREIGN KEY REFERENCES HR.Account(AccountID),
		 CustomerID INT NOT NULL FOREIGN KEY REFERENCES HR.Customer(CustomerID),
		 EmployeeID INT NOT NULL FOREIGN KEY REFERENCES HR.Employee(EmployeeID),
		 UserLoginID INT NOT NULL FOREIGN KEY REFERENCES HR.UserLogins(UserLoginID));
GO
INSERT INTO Select * from HR.TransactionLog
VALUES		(6001,'20170201 09:10:45.102',51,0.0,8000.0,8000,4001,7000,100),
			(6002,'20170705 10:13:23.101',52,7000.0,-1000.0,8001,4002,7001,101),
			(6003,'20170806 06:15:45.104',53,2000.0,2200.1,8002,4003,7000,102),
			(6004,'20170216 03:15:56:120',54,50.0,4050.2,8003,4004,7002,103),
			(6005,'20171211 02:18:23.111',53,600.0,3600.7,8004,4005,7002,104);
GO

CREATE TABLE HR.Account
       (AccountID INT PRIMARY KEY NOT NULL,
	    CurrentBalance INT NOT NULL,
		AccountTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES HR.AccountType(AccountTypeID),
		AccountStatusTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES HR.AccountStatusType(AccountStatusTypeID),
		InterestSavingsRateID INT NOT NULL FOREIGN KEY REFERENCES HR.SavingsInterestrates(InterestSavingsRateID));
GO
INSERT INTO HR.Account
VALUES		(8000,8000,3,1,9003),
			(8001,6000.5,4,0,9002),
			(8002,200.1,4,0,9001),
			(8003,4100.2,3,2,9002),
			(8004,3000.7,4,1,9001);
GO

CREATE TABLE HR.OverDraftLog
       (AccountID INT PRIMARY KEY NOT NULL FOREIGN KEY REFERENCES HR.Account(AccountID),
	    OverDraftDate DATETIME,
		OverDraftAmount MONEY,
		OverDraftTransactionXML VARCHAR(30));
GO
INSERT INTO HR.OverDraftLog
VALUES (8001,'20170504 10:09:15.120',1000,'Max Overdraft Limit Reached');
GO


CREATE TABLE HR.Customer
		(CustomerID INT PRIMARY KEY NOT NULL,
		 AccountID INT NOT NULL FOREIGN KEY REFERENCES HR.Account(AccountID),
		 CustomerAddress1 VARCHAR (30) NOT NULL,
		 CustomerAddress2 VARCHAR (30) NOT NULL,
		 CustomerFirstName VARCHAR(30) NOT NULL,
		 CustomerMiddleInitial VARCHAR(10),--I have given Long Middle Name
		 CustomerLastName VARCHAR(30) NOT NULL,
		 City VARCHAR (20) NOT NULL,
		 State CHAR(10) NOT NULL,
		 ZipCode CHAR (10) NOT NULL,
		 EmailAddress VARCHAR (40),
		 HomePhone CHAR(10),
		 CellPhone CHAR (10) NOT NULL,
		 WorkPhone CHAR (10),
		 SSN CHAR (10) NOT NULL,
		 UserLoginID INT NOT NULL FOREIGN KEY REFERENCES HR.UserLogins(UserLoginID));
GO
INSERT INTO select * from HR.Customer
VALUES  (4001,8000,'2193','Victoria Park Avenue','Steve',' ','Williamson','Toronto','Ontario','M2J3B4','steve.williamson@hotmail.com','7259889','4165551234','8912334','988677434',100),
		(4002,8001,'2433','Sheppard Avenue','Sandeep','Kumar','Gupta','Ottawa','Ontario','M3C4J2','s.gupta@hotmail.com','6217989','4165551235','8976432','345123876',101),
		(4003,8002,'1723','DonMills Road','Robert','Joseph','Patrik','Toronto','Ontario','N3D4RT','robert.patrik@hotmail.com','6217990','4165551236','9867556','987123567',102),
		(4004,8003,'1223','Yonge street','Marina',' ','Varghese','Hamilton','Ontario','R6H7T5','marina.varghese@hotmail.com','6217991','4165551237','2378456','876152098',103),
		(4005,8004,'7234','Lawrence','Tasha','Neil','Sharma','Ottawa','Ontario','H8K9E3','tasha.neil@gmail.com','6217992','4165551238','7821098','987345678',104);
GO

CREATE TABLE HR.CustomerAccount
	   (AccountID INT NOT NULL FOREIGN KEY REFERENCES HR.Account(AccountID),
	    CustomerID INT NOT NULL FOREIGN KEY REFERENCES HR.Customer(CustomerID));
GO
INSERT INTO HR.CustomerAccount
VALUES  (8000,4001),
		(8001,4002),
		(8002,4003),
		(8003,4004),
		(8004,4005);
GO

CREATE TABLE HR.LoginAccount
		(UserLoginID INT NOT NULL FOREIGN KEY REFERENCES HR.UserLogins(UserLoginID),
		 AccountID INT NOT NULL FOREIGN KEY REFERENCES HR.Account(AccountID));
GO
INSERT INTO HR.LoginAccount
VALUES  (100,8000),
		(101,8001),
		(102,8002),
		(103,8003),
		(104,8004);
GO

CREATE TABLE HR.UserSecurityAnswers
        (UserLoginID INT PRIMARY KEY NOT NULL FOREIGN KEY REFERENCES HR.UserLogins(UserLoginID),
		UserSecurityAnswer VARCHAR(25),
		UserSecurityQuestionID TINYINT NOT NULL FOREIGN KEY REFERENCES HR.UserSecurityQuestions(UserSecurityQuestionID));
GO
INSERT INTO HR.UserSecurityAnswers
VALUES  (100,'Simba',7),
		(101,'Toronto',8),
        (102,'Timmy',7),
		(103,'Jo',9),
		(104,'Kim',9);
GO

--PROJECT PHAE-2

/*Problem No-1, Create a view to get all customers with checking account from ON province.*/

CREATE VIEW Customers_CA_ON AS
select C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+CustomerLastName AS [Customer Name], C.State, AT.AccountTypeDescription
from HR.Customer C join HR.Account A on C.AccountID=A.AccountID
				   join HR.AccountType AT on A.AccountTypeID=AT.AccountTypeID
where C.State='Ontario' and AT.AccountTypeDescription='CHECKING';

Select * from Customers_CA_ON;

/*Problem No-2, Create a view to get all customers with total account balance (including interest rate) greater than 5000*/

CREATE VIEW [Account Balance with Interest Amount] AS
select C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+CustomerLastName AS [Customer Name],
A.CurrentBalance,S.InterestRateValue,
A.CurrentBalance+(A.currentBalance*S.InterestRateValue) AS [Current Balance with Interest Amount]

from HR.Customer C join HR.Account A on C.AccountID=A.AccountID
				   Join HR.SavingsInterestRates S on A.InterestSavingsRateID=S.InterestSavingsRateID
where (A.CurrentBalance+(A.currentBalance*S.InterestRateValue))>5000;

Select * from [Account Balance with Interest Amount];

/*Problem No-3,Create a view to get counts of checking and savings accounts by customer.*/

CREATE VIEW [Customers Account Type Count] AS
Select C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+CustomerLastName AS [Customer Name],
COUNT(AT.AccountTypeDescription) AS [Count of Account Type]

from HR.Customer C join HR.Account A on C.AccountID=A.AccountID
				   join HR.AccountType AT on A.AccountTypeID=AT.AccountTypeID
Group By C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+CustomerLastName,AT.AccountTypeDescription; 

Select * from [Customers Account Type Count];

/*Problem No-4, Create a view to get any particular user’s login and password using AccountId.*/

CREATE VIEW [Account Login Information] AS
Select L.AccountID, U.UserLogin, U.UserPassword
from HR.LoginAccount L join HR.UserLogins U on L.UserLoginID=U.UserLoginID
where L.AccountID=8001;

Select* from [Account Login Information];

/*Problem No-5, Create a view to get all customers’ overdraft amount.*/

CREATE VIEW [Customers Over Draft Amount] AS
Select  ALL C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+CustomerLastName AS [Customer Name], O.OverDraftAmount
From HR.Customer C join HR.OverDraftLog O on C.AccountID=O.AccountID;

Select * from [Customers Over Draft Amount];


/*Problem No-6, Create a stored procedure to add “User_” as a prefix to everyone’s login (username)*/

CREATE PROC AddUsertoLogin
AS
SELECT 'User_'+ UserLogin AS [Username] 
From HR.UserLogins;

EXEC AddUsertoLogin;

/*Problem No-7,Create a stored procedure that accepts AccountId as a parameter and returns customer’s full name.*/

CREATE PROC [AccountID With Customer Name]
(@AccountID AS INT)
AS
SELECT AccountID,CustomerFirstName+' '+CustomerMiddleInitial+' '+CustomerLastName AS [Customer Name]
From HR.Customer
Where AccountID=@AccountID;

EXEC [AccountID With Customer Name] @AccountID=8004;

/*Problem No-8,Create a stored procedure that returns error logs inserted in the last 24 hours. */
Create PROC [Log In Last 24 Hrs]
AS
Select *
From HR.LoginErrorLog
WHERE LoginErrorTime>=DATEADD(HOUR,-24,GETDATE());

EXEC [Log In Last 24 Hrs];

/*Problem No-9, Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account. */

CREATE PROC [Deposit Money]
(@Deposit AS INT)
AS
UPDATE HR.ACCOUNT
SET CurrentBalance=CurrentBalance+@Deposit
WHERE AccountID=8002;

EXEC [Deposit Money] @Deposit=300;

/*Problem No-10, Create a stored procedure that takes a withdrawal amount as a parameter and updates CurrentBalance value for that particular account.*/

CREATE PROC [Withdraw Money]
(@Withdraw AS INT)
AS
UPDATE HR.ACCOUNT
SET CurrentBalance=CurrentBalance-@Withdraw
WHERE AccountID=8004;

EXEC [Withdraw Money] @Withdraw=500;

/*Problem No-11,Create a stored procedure to remove all security questions for a particular login. */

CREATE PROC [Delete Security Questions]
@UserLoginID AS SMALLINT
AS
UPDATE HR.UserSecurityQuestions
SET UserSecurityQuestion=' ' 
/*I have taken UserSecurityQuestion Value as ' ' (Blank) because while Creating table
i have taken column UserSecurityQuestion as NOT NULL value */
WHERE UserSecurityQuestionID= (Select UQ.UserSecurityQuestionID
							   from HR.UserSecurityAnswers UA JOIN HR.UserSecurityQuestions UQ
							   ON UA.UserSecurityQuestionID=UQ.UserSecurityQuestionID
							   WHERE UA.UserLoginID=@UserLoginID);

EXEC [Delete Security Questions] @UserLoginID=101;

/*Problem No-12, Delete all error logs created in the last hour.*/

DELETE FROM HR.LoginErrorLog
Where LoginErrorTime>= DATEADD(HOUR,-1,GETDATE());

/*Problem No-13,Write a query to remove SSN column from Customer table*/

ALTER TABLE HR.Customer
DROP COLUMN SSN;
