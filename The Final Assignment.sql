--**********************************************************************************************--
-- Title: ITFnd130Final
-- Author: SDawkins
-- Desc: This file demonstrates how to design and create; 
--       tables, views, and stored procedures
-- Change Log: When,Who,What
-- 2020-09-02,SDawkins,Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'ITFnd130FinalDB_SDawkins')
	 Begin 
	  Alter Database [ITFnd130FinalDB_SDawkins] set Single_user With Rollback Immediate;
	  Drop Database ITFnd130FinalDB_SDawkins;
	 End
	Create Database ITFnd130FinalDB_SDawkins;
End Try
Begin Catch
	Print Error_Number();
End Catch
go

Use ITFnd130FinalDB_SDawkins;

/*
-- Create Tables (Module 01)-- 
-- Add Constraints (Module 02) -- 
-- Adding Views (Module 03 and 06) -- 
-- Adding Stored Procedures (Module 04, 08, and 09) --
-- Set Permissions --
--< Test Sprocs >-- 
--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  
**************************************************************************************************/

-- Creating Tables 

Create -- Drop
  Table dbo.Students
   (CustomerID int Identity(1,1) Not Null, 
    StudentID nvarchar(50) Not Null,
    FirstName varchar(50) Not Null, 
    LastName varchar(50) Not Null, 
	Email nvarchar (50) Not Null, 
    PhoneNumber varchar(50) Not Null,
	Address varchar(50) Not Null, 
	Constraint pkCustomerID Primary Key Clustered (CustomerID) -- PK primery key created
	)

Create -- Drop
  Table dbo.Course 
     (CourseID int Identity(1,1) Not Null, 
	  Enroll_Date nvarchar (50) Not Null,
	  CourseName nvarchar (50) Not Null, 
	  StartDate nvarchar(50) Not Null, 
	  EndDate nvarchar(50) Not Null,
	  CustomerID int Null, -- FK foreign key constraints 
	  Tuition money Not Null,
	  Constraint pkCourseID Primary Key Clustered (CourseID) -- PK primery key created
	  );
go

Create -- Drop
  Table dbo.Registration
    (RegistrationID int Identity(1,1) Not Null,
	 Session_Start nvarchar(50) Not Null,
	 Session_End nvarchar(50) Not Null,
	 CourseID int Null, -- FK foreign key constraints 
	 StartTime nvarchar(50) Not Null, 
	 EndTime nvarchar(50) Not Null,
	 Classroom nvarchar(50) Not Null,
	 Constraint pkRegisrationID Primary Key Clustered (RegistrationID) -- PK primery key created
	);
go

--*** Adding a Unique, Foregin Key, Check Constraint ***'
-----------------------------------------------------------------------------------------------------------------------
ALTER TABLE dbo.Students
	ADD 
	CONSTRAINT uStudentID UNIQUE NonCLUSTERED (StudentID);
go

ALTER TABLE dbo.Students
	ADD 
	CONSTRAINT uEmail UNIQUE NonCLUSTERED (Email);
go

ALTER TABLE dbo.Students
	ADD 
	CONSTRAINT uFirstName UNIQUE NonCLUSTERED (FirstName);
go

ALTER TABLE dbo.Students
	ADD 
	CONSTRAINT uLastName UNIQUE NonCLUSTERED (LastName);
go

ALTER TABLE dbo.Students
	ADD 
	CONSTRAINT uPhoneNumer UNIQUE NonCLUSTERED (PhoneNumber);
go


Alter Table dbo.Course -- Check Constraint 
  Add -- Drop
  Constraint ckCourse_Tuiotion Check (Tuition >= 0);
go 

--*** Adding a Referential Constraint ***'
Alter Table dbo.Course 
   ADD -- Drop
   Constraint fkCourse_Customer
      Foreign key (CustomerID)
	  References dbo.Students (CustomerID)
	  ON UPDATE CASCADE 
      ON DELETE CASCADE;
go

Alter Table dbo.Registration
   ADD -- Drop
   Constraint fkRegistration_CourseID
      Foreign key (CourseID)
	  References dbo.Course (CourseID)
	  ON UPDATE CASCADE 
      ON DELETE CASCADE;
go

--*** Adding a Default Constraint after the table is made ***

Alter Table dbo.Course
    ADD
	Constraint dfCourse_CustomerID Default (1)
	For CustomerID;
go

Alter Table dbo.Registration
    ADD
	Constraint dfRegistration_CourseID Default (1)
	For CourseID;
go

-----------------------Inserting Data from Excel Sheet---------------------

Insert Into Students 
   Values 
       ('B-Smith-071', 'Bob', 'Smith', 'Bsmith@HipMail.com', '(206)-111-2222', '123 Main St. Seattle, WA., 98001'),
       ('S-Jones-003', 'Sue', 'Jones', 'SueJones@YaYou.com', '(206)-231-4321', '333 1st Ave. Seattle, WA., 98001')
go 

Insert Into Course
    Values
       ('1/3/2017', 'SQL1 - Winter 2017', '1/10/2017', '1/24/2017', 1, '$399.00'),
	   ('1/3/2017', 'SQL2 - Winter 2017', '2/14/2017', '2/21/2017', 1, '$399.00'),
       ('12/14/2016', 'SQL1 - Winter 2017', '1/10/2017', '1/24/2017', 2, '$349.00'),
	   ('12/14/2016', 'SQL2 - Winter 2017', '2/14/2017', '2/21/2017', 2, '$349.00')
go

Insert Into Registration
    Values
       ('1/10/2017', '1/24/2017', 1, '06:00', '08:50', 'A-201'),
       ('1/10/2017', '1/24/2017', 1, '06:00', '08:50', 'A-201'),
       ('1/10/2017', '1/24/2017', 1, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 2, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 2, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 2, '06:00', '08:50', 'B-303'),

       ('1/10/2017', '1/24/2017', 3, '06:00', '08:50', 'A-201'),
       ('1/10/2017', '1/24/2017', 3, '06:00', '08:50', 'A-201'),
       ('1/10/2017', '1/24/2017', 3, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 4, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 4, '06:00', '08:50', 'B-303'),
       ('1/31/2017', '2/14/2017', 4, '06:00', '08:50', 'B-303')
go

----------------------- Creating views for each table ----------------------
Create -- Drop
   View vStudents With SchemaBinding
     As Select CustomerID, StudentID, FirstName, LastName, Email, PhoneNumber, [Address]
   From dbo.Students
go

Create -- Drop 
   View vCourse With SchemaBinding
     As Select CourseID, Enroll_Date, CourseName, StartDate, EndDate, CustomerID, Tuition
   From dbo.Course
go

Create -- Drop 
   View vRegistration With SchemaBinding
     As Select RegistrationID, Session_Start, Session_End, CourseID, StartTime, EndTime, Classroom
   From dbo.Registration
go


--Create Insert, Update, and Delete Transactions Store Procedures for vCustomers 
-- Create the insert Procedure as pInsStudents

Create -- Drop
 Procedure dbo.pInsStudents
   @StudentID nvarchar(50),
   @FirstName varchar(50),
   @LastName varchar(50),
   @Email nvarchar (50),
   @PhoneNumber varchar(50),
   @Address varchar(50)
 -- Author: <SDawkins>
 -- Desc: Processes Insert Into Customers Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Students (StudentID, FirstName, LastName, Email, PhoneNumber, Address)
	Values (@StudentID, @FirstName, @LastName, @Email, @PhoneNumber, @Address);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Update Procedure as pUpdStudents
Create -- Drop
 Procedure dbo.pUpdStudents
  (@CustomerID Int,
   @StudentID nvarchar(50),
   @FirstName varchar(50),
   @LastName varchar(50),
   @Email nvarchar (50),
   @PhoneNumber varchar(50),
   @Address varchar(50))
 -- Author: <SDawkins>
 -- Desc: Processes Update Customers Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update dbo.Students
	 Set StudentID = @StudentID,
         FirstName = @FirstName,
         LastName = @LastName,
         Email = @Email,
         PhoneNumber = @PhoneNumber,
         Address = @Address
	 Where CustomerID = @CustomerID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Delete Procedure as pDelStudents
Create -- Drop
 Procedure dbo.pDelStudents
  (@CustomerID int)
 -- Author: <SDawkins>
 -- Desc: Processes Dlete from Customer Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete -- Delete statement
     From Students
	 Where CustomerID = @CustomerID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Insert, Update, and Delete Transactions Store Procedures for Course
-- Create the insert Procedure as pCourse

Create -- Drop
 Procedure dbo.pInsCourse
   (@Enroll_Date nvarchar (50),
    @CourseName nvarchar (50),
	@StartDate nvarchar(50), 
	@EndDate nvarchar(50),
	@CustomerID int,
	@Tuition money)
 -- Author: <SDawkins>
 -- Desc: Processes Insert Into Category Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Course (Enroll_Date, CourseName, StartDate, EndDate, CustomerID, Tuition)
	Values (@Enroll_Date, @CourseName, @StartDate, @EndDate, @CustomerID, @Tuition);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


--Create Update Procedure as pUpdCourse
Create -- Drop
 Procedure dbo.pUpdCourse
   (@CourseID int,
    @Enroll_Date nvarchar (50),
    @CourseName nvarchar (50),
	@StartDate nvarchar(50), 
	@EndDate nvarchar(50),
	@CustomerID int,
	@Tuition money)
 -- Author: <SDawkins>
 -- Desc: Processes Update Course Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Course
	 Set Enroll_Date = @Enroll_Date,
	     CourseName = @CourseName,
	     StartDate = @StartDate, 
	     EndDate = @EndDate,
	     CustomerID = @CustomerID,
	     Tuition = @Tuition
	 Where CourseID = @CourseID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Delete Procedure as pDelCourse
Create -- Drop
 Procedure dbo.pDelCourse
  (@CourseID int)
 -- Author: <SDawkins>
 -- Desc: Processes Dlete from Course Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete -- Delete statement
     From Course
	 Where CourseID = @CourseID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Insert, Update, and Delete Transactions Store Procedures for Registration
-- Create the insert Procedure as pInsRegistration

Create -- Drop
 Procedure dbo.pInsRegistration
   (@Session_Start nvarchar(50),
    @Session_End nvarchar(50),
	@CourseID int,
	@StartTime nvarchar(50), 
	@EndTime nvarchar(50),
	@Classroom nvarchar(50))
 -- Author: <SDawkins>
 -- Desc: Processes Insert Into Registration Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Registration (Session_Start, Session_End, CourseID,  StartTime, EndTime, Classroom)
	Values (@Session_Start, @Session_End, @CourseID, @StartTime, @EndTime, @Classroom);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


--Create Update Procedure as pUpdRegistration
Create -- Drop
 Procedure dbo.pUpdRegistration
    @RegistrationID int,
    @Session_Start nvarchar(50),
    @Session_End nvarchar(50),
	@CourseID int,
	@StartTime nvarchar(50), 
	@EndTime nvarchar(50),
	@Classroom nvarchar(50)
 -- Author: <SDawkins>
 -- Desc: Processes Update Registration Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Registration
	 Set Session_Start = @Session_Start,
         Session_End = @Session_End,
	     CourseID = @CourseID,
	     StartTime = @StartTime, 
	     EndTime = @EndTime,
	     Classroom = @Classroom
	 Where RegistrationID = @RegistrationID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Delete Procedure as pDelRegistration
Create -- Drop
 Procedure dbo.pDelRegistration
  (@RegistrationID int)
 -- Author: <SDawkins>
 -- Desc: Processes Dlete from Registration Table
 -- Change Log: When,Who,What
 -- <2020-08-25>,<SDawkins>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete -- Delete statement
     From Registration
	 Where RegistrationID = @RegistrationID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


-----------Settimg Permission to lock tables to public but giving access to views------
Deny Select on dbo.Students to Public 
Deny Select on dbo.Course to Public 
Deny Select on dbo.Registration to Public


Grant Select on dbo.vStudents to Public 
Grant Select on dbo.vCourse to Public 
Grant Select on dbo.vRegistration to Public

--< Test Insert Sprocs >--

-- Test [dbo].[pInsStudents]
Declare @Status int;
Exec @Status = dbo.pInsStudents
               @StudentID = 'R-Stephenson-065',
               @FirstName = 'Rory',
               @LastName = 'Stephenson',
               @Email = 'R.Stephenson@gmail.com',
               @PhoneNumber = '(206)-555-6565',
               @Address = '444 2nd Ave, Seattle, WA, 98001';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status];
-- * From vCategories Where CategoryID = @@IDENTITY;
go

-- Test [dbo].[pInsCourse]
Declare @Status int;
Exec @Status = dbo.pInsCourse
               @Enroll_Date = '12/20/2016',
			   @CourseName = 'Math-Winter 2017',
               @StartDate = '1/12/2017',
               @EndDate = '1/26/2017',
               @CustomerID  = 3,
               @Tuition = '$149.00';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status];
-- * From vCategories Where CategoryID = @@IDENTITY;
go

Declare @Status int;
Exec @Status = dbo.pInsRegistration
               @Session_Start = '1/12/2017',
               @Session_End = '1/26/20017',
               @CourseID  = 5,
               @StartTime = '08:00',
			   @EndTime = '10:00',
			   @Classroom = 'C-303';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status];
-- * From vCategories Where CategoryID = @@IDENTITY;
go

--< Test Update Sprocs >--
Declare @Status int;
Exec @Status = dbo.pUpdStudents
               @CustomerID = 3,
               @StudentID = 'R-Stephenson-065',
               @FirstName = 'Rory',
               @LastName = 'Stephenson',
               @Email = 'R.Stephenson@gmail.com',
               @PhoneNumber = '(646)-333-5454',
               @Address = '444 2nd Ave, Seattle, WA 98081'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status];
--Select * From vCategories where CategoryID = @@IDENTITY
go

Declare @Status int;
Exec @Status = dbo.pUpdCourse
               @Enroll_date = '12/20/2016',
			   @CourseID = 5,
			   @CourseName = 'Math-Winer 2017',
	           @StartDate = '2017-03-10', 
	           @EndDate = '2017-03-14',
	           @CustomerID = 3,
	           @Tuition ='$170.00'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status];
--Select * From vCategories where CategoryID = @@IDENTITY
go

Declare @Status int;
Exec @Status = dbo.pUpdRegistration
               @RegistrationID = 13,
               @Session_Start = '1/12/2017',
               @Session_End = '1/26/20017',
			   @CourseID = 5,
			   @StartTime = '08:00',
			   @EndTime = '10:00',
			   @Classroom = 'A-303'
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status];
--Select * From vCategories where CategoryID = @@IDENTITY
go


Declare @Status int;
Exec @Status = dbo.pDelRegistration
               @RegistrationID = 13
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status];
--Select * From vEmployees Where EmplyoeeID = @@IDENTITY;   
go

Declare @Status int;
Exec @Status = dbo.pDelCourse
               @CourseID = 5
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status];
--Select * From vEmployees Where EmplyoeeID = @@IDENTITY;   
go

Declare @Status int;
Exec @Status = dbo.pDelStudents
               @CustomerID = 3
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status];
--Select * From vEmployees Where EmplyoeeID = @@IDENTITY;   
go


Select * From vStudents
Select * From vCourse
Select * From vRegistration
go

--Select * From Students
--Select * From Course
--Select * From Registration
--go


/*
--Creating a view using the view access to display all information on table using Inner Join

Create -- Drop
  View vStudentCourse
  As 
  Select Top 1000000 
	C.StudentID, 
    [StudentName] = C.FirstName + ' ' + C.LastName,
    C.Email,
	C.PhoneNumber,
	C.Address,
	Co.CourseName,
	Co.Tuition,
	R.SessionDate,
	R.StartTime,
	R.EndTime,
	R.Classroom
	From vCustomers As C 
	 Inner Join vCourse As CO
	  on C.CustomerID = Co.CustomerID
	Inner Join vRegistration As R
	  on Co.CourseID = R.CourseID
Order By 1
go

Select * from vStudentCourse
go
*/

