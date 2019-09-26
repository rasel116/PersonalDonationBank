USE master
IF DB_ID('MyDream') IS NOT NULL
    DROP DATABASE MyDream
GO
use master
Create database MyDream
go

			--SELECT 'kill ' + CONVERT(VARCHAR(100), session_id)
			--FROM sys.dm_exec_sessions
			--WHERE database_id = DB_ID('MyDream')
			--AND session_id &lt;&gt; @@spid
			--go

			--USE master
			--GO
			--ALTER DATABASE MyDream SET SINGLE_USER WITH ROLLBACK IMMEDIATE
			--GO
			--USE master
			--GO
			--DROP DATABASE MyDream
			--GO

ALTER DATABASE MyDream MODIFY FILE(name=N'MyDream',Size=10MB, MaxSize=unlimited,FileGrowth=1024KB)
go

ALTER DATABASE MyDream MODIFY FILE(name=N'MyDream_log',Size=9MB, MaxSize=100MB,FileGrowth=10%)
go


create SCHEMA Schma_DreamProject
go

use MyDream
create TABLE HelplessBox
(
ApplicationNo int primary key identity(100,3),
AppllyId as ('Help'+cast(ApplicationNo as varchar(30))+'PiggyBank'),
FirstName varchar (20)NOT NULL,
LastName varchar (20)NOT NULL,
WantedAmmount money NOT NULL,
ApplyDate datetime NOT NULL DEFAULT GETDATE() ,
Purpose varchar(50)NOT NULL,
TotallWA money,
TotallReceiveAmount money,
PayoutAmount money
 
)
go

Insert into HelplessBox(FirstName,LastName,WantedAmmount,Purpose,TotallWA,TotallReceiveAmount,PayoutAmount) values('RAsel','Siddique',500,'Sick',300,200,100)
Insert into HelplessBox(FirstName,LastName,WantedAmmount,Purpose,TotallWA,TotallReceiveAmount,PayoutAmount) values('Mahfuz','Ahmed',800,'Education',400,200,200)
Insert into HelplessBox(FirstName,LastName,WantedAmmount,Purpose,TotallWA,TotallReceiveAmount,PayoutAmount) values('Nazma','Khanom',1000,'Birthday',200,100,100)
GO



create Table  DonorList
(
HeartNo int primary key identity (777,10),
DonateId int foreign key references HelplessBox(ApplicationNo),
FullName varchar (30),
Surname varchar(10),
DonationAmount money,
TotallDA money
) 
go

Insert into DonorList(DonateId,Surname,DonationAmount,TotallDA)values(103,'Akib',200,300)
Insert into DonorList(DonateId,Surname,DonationAmount,TotallDA)values(101,'RAkib',100,100)
Insert into DonorList(DonateId,Surname,DonationAmount,TotallDA)values(100,'Sakib',250,260)
GO



create TABLE Verfication
(
VerificationID int primary key identity,
DonorVerification int foreign key references DonorList(HeartNo),
DoctorVerification nvarchar(100) null,
LocationVerifation nvarchar(max)  null,
LiveVideoVerification nvarchar(30) null,
VerificationStatus bit not null
)
go

insert into Verfication(DonorVerification,DoctorVerification,LocationVerifation,LiveVideoVerification,VerificationStatus)values(777,'He really need operation','','',0)
insert into Verfication(DonorVerification,DoctorVerification,LocationVerifation,LiveVideoVerification,VerificationStatus)values(797,'He really need operation','','',1)
Go

create function fn_TotallWA
(
	@totallWA money,
	@wantedAmmount money
)
	returns int
	as 
	begin
		
		set @totallWA=sum (@wantedAmmount)
		return @totallWA
	end
go



create function fn_TotallDA
	(
	@totallDA money,
	@donationAmount money
	)
	returns int
	as 
	begin
		
		set @totallDA=sum (@donationAmount)
		return @totallDA
	end
go

Create proc sp_Mydream
@applicationNo int,
@AppllyId nvarchar,
@firstName varchar (20),
@lastName varchar (20),
@wantedAmmount money ,
@applyDate datetime,
@purpose varchar(50),
@totallWA money,
@payoutamount money,
@servicecharge decimal=.20,						

@heartNo int,
@donateId int,
@fullName varchar (30),
@surname varchar(10),
@donationAmount money,
@totallDA money,

@verificationID int,
@donorVerification int,
@doctorverification nvarchar(100),
@locationverifation varbinary(max) ,
@liveVideoverification nvarchar(30),
@verificationStatus bit,

@tablename varchar(30),
@operation varchar(30),
@message varchar (50) output
as
begin
-----------------------------Donorlist

	if @tablename='DonerList' and @operation='insert'
		begin try 
			begin transaction
			 insert into DonorList(HeartNo,DonateId,FullName,Surname,DonationAmount)
			 Values (@heartNo,@donateId,@fullName,@surname,@donationAmount,@totallDA)
			 set @message='We will Give Your money to Perfect helpless'
			 print @message
			commit transaction
		end try

		begin catch
			Rollback transaction
			print 'Please,One more Try'
		end catch

	if @tablename='DonerList' and @operation='update'
		begin try 
			begin transaction
			 Update DonorList set FullName=@fullName,Surname=@surname	
			 where HeartNo=@heartNo	
			 set @message='Thanks for staying with Truth '
			 print @message
			commit transaction
		end try

	begin catch
		Rollback transaction
		print 'Please, Check your input Correctly'
	end catch


------------------Donation Table

if @tablename='HelplessBox' and @operation='insert'
		begin try 
			begin transaction
			 insert into HelplessBox(ApplicationNo,FirstName,LastName,WantedAmmount,ApplyDate,Purpose,TotallWA)
			 Values (@applicationNo,@firstName,@lastName,@wantedAmmount,@applyDate,@purpose,@totallWA)
			 set @message='We Will Try Our Best '
			 print @message
			commit transaction
		end try

		begin catch
			Rollback transaction
			print 'Are you a Spammer?'
		end catch

	if @tablename='HelperBox' and @operation='update'
		begin try 
			begin transaction
			 Update HelplessBox set WantedAmmount=@wantedAmmount,Purpose=@purpose	
			 where AppllyId=@AppllyId	
			 set @message='Thanks for saying Truth '
			 print @message
			commit transaction
		end try

	begin catch
		Rollback transaction
		print 'You are Cheating with US !!!'
	end catch

-----------========================-verification Table


	if @tablename='Verfication' and @operation='insert'
			begin try 
				begin transaction
				 insert into Verfication(VerificationID,DonorVerification,DoctorVerification,LocationVerifation,LiveVideoVerification,VerificationStatus)
				 Values (@verificationID,@donorVerification,@doctorverification,@locationverifation,@liveVideoverification,@verificationStatus)
				 set @message='Your verification will be Reviewed By Our Human'
				 print @message
				commit transaction
			end try
	

			begin catch
				Rollback transaction
				print 'Stay calm. Give exact Information'
			end catch

		if @tablename='Verfication' and @operation='update'
			begin try 
				begin transaction
				 Update Verfication set DonorVerification=@donorVerification,DoctorVerification=@doctorverification,LocationVerifation=@locationverifation,LiveVideoVerification=@liveVideoverification,VerificationStatus=@verificationStatus	
				 where VerificationID=@verificationID	
				 set @message='Thanks for saying Truth '
				 print @message
				commit transaction
			end try

		begin catch
			Rollback transaction
			print 'Please, Dont Stay with Truth.Try Again!!!'
		end catch
end
go



---------------- Our Achievment
use MyDream
SELECT  H.FirstName + ' ' + H.LastName AS  Luckyname,H.Purpose,H.ApplyDate 
FROM HelplessBox as H 
INNER JOIN DonorList AS D 
On D.HeartNo = H.AppllyId  
go



Select * from HelplessBox
Select * from DonorList
Select * from Verfication

--delete HelperBox
--delete DonorList
--delete Verfication

------======================================
GO
create function fn_servicecharge
(
	@servicecharge decimal=0.20,
	@requestamount money,
	@remaingamount money
)
returns int
as 
	begin
	 set @remaingamount= @servicecharge*@requestamount
	 return @remaingamount
	end
go
Go
create function fn_sub
	(
	@balance money,
	@cost money,
	@reamining money
	)
	returns int
	as 
	begin
		
		set @reamining=@balance-@cost
		return @reamining
	end
go



create table WrongVerification
(
 SpamId int primary key,
 SpammerFromHelBox int foreign key references HelplessBox(ApplicationNo),
 PerposeOfBlock varchar (100),
 BlockAmount money
)


create table VerifiedAuthority
(
ReceiveID int primary key identity(10,2),
ReceiveFromDoner  int foreign key references DonorList(HeartNo),
ReceiveFromSpam int foreign key references WrongVerification(SpamId),
ReceiveAmountFromDonor money,
BlockAmountFromHelplessBox money,
SentAmountFromHelplessBox money,
AvailableBalance as ReceiveAmountFromDonor+BlockAmountFromHelplessBox-SentAmountFromHelplessBox
)
Go

create table AcceptedVerification
(
 PaymentRequestID int primary key,
 AcceptedPaymentFromHelpBox int foreign key references HelplessBox(ApplicationNo),
 PaymentRequestDate   DATETIME DEFAULT GETDATE(),
 PaymentAmount money
 )
 
 create table ServiceAuthority
 (
 ServiceID int Primary Key,
 RecevedCharge int foreign key references AcceptedVerification(PaymentRequestID),
 RecevedChargeDate DATETIME DEFAULT GETDATE(),
 TotallReceiveAmount money,
 SendToAdminPanel money,
 SendToDigitalMarketing money,
 SendToPiggyReservedFund money,
 SendToOwnerFund money,
 ReceivedLoan money,
 ReceivedLoanDate DATETIME DEFAULT GETDATE(),
 GiveLoan money,
 GiveLoanDate DATETIME DEFAULT GETDATE(),
 AvailableBalance money
 
 )
 ----------================
 create table FinalPayRecord
 (
 TransactionID int primary key,
 LuckyName int foreign key references ServiceAuthority(ServiceID),
 TransactionAmount money  
 )
 ---------====================
 create table AdminPanel
 (
 AdminId int primary key,
 ReceiveForAdmin int foreign key references ServiceAuthority(ServiceID),
 AdminFund money, 
 AdminName varchar(30),
 Adminaddress varchar(100),
 AdminNID image ,
 AdminPassPort image,
 AdminJiningDate DATETIME DEFAULT GETDATE(),
 AdminDesignation varchar,
 AdminSalary money,
 AdminActivity bit 
 )

create table DigitalMarketing
(
CampaignID int primary key,
ReceivedForDM int foreign key references ServiceAuthority(ServiceID),
CampaignDate DATETIME DEFAULT GETDATE(),
DigitalMarketingFund money,
FacebookBudget money,
LinkendBudget money,
TwitterBudget money,
YoutubeBudget money,
InstagramBudget money,
RefferalBudget money,
OtherSpecialEvent money
)

Create table OwnerReceived
(
ReceiveFromService int foreign key references ServiceAuthority(ServiceID),
ReceiveFromServiceDate DATETIME DEFAULT GETDATE(),
ReceiveAmount money,
ReceivingLoanAmount money,
TotallReceiveAmount money,
GivingLoanAmount money,
RemainingAmount as TotallReceiveAmount-GivingLoanAmount,
OwnerOverview varchar(100),
OverviewDate datetime,
Ovw_ServiceID int,
Ovw_RecevedCharge int,
Ovw_RecevedChargeDate date,
Ovw_TotallReceiveAmount money,
Ovw_SendToAdminPanel money,
Ovw_SendToDigitalMarketing money,
Ovw_SendToPiggyReservedFund money,
Ovw_SendToOwnerFund money,
Ovw_ReceivedLoan money,
Ovw_ReceivedLoanDate date,
Ovw_GiveLoan money,
Ovw_GiveLoanDate date,
Ovw_AvailableBalance money

)

create table Pension
(
PensionID int primary key,
PensionOwner int foreign key references AdminPanel(AdminId),
PensionAmount money,
PensionAmountEntryDate DATETIME DEFAULT GETDATE(),
TotallPensionAmount money,
WithdrawnPension money,
PensionAmountwithdrawDate DATETIME DEFAULT GETDATE(),
Availablepension as TotallPensionAmount-WithdrawnPension

)

create table PiggyReserved
(
ResevedId int primary key,
ReservedFromService int foreign key references ServiceAuthority(ServiceID),
ReservedFromServiceDate DATETIME DEFAULT GETDATE(),
ReservedFromPension int foreign key references Pension(PensionID),
ReservedFromPensionDate DATETIME DEFAULT GETDATE(),
WithDrawnForPension money,
WithdrawnForService money,
TotallReserved money
)
GO
-------========Trigger For Owner Table===============

--CREATE TRIGGER trgAfterInsert on dbo.ServiceAuthority
--FOR INSERT
--AS declare @receiveFromService int, @receiveAmount money, @receiveFromServiceDate money, @totallReceiveAmount money,@givingLoanAmount money,@ownerOverview varchar(100);
--		select @receiveFromService=i.ServiceID from inserted i;
--		select @receiveAmount=i.RecevedCharge from inserted i;
--		select @receiveFromServiceDate=i.RecevedChargeDate from inserted i;

--	set @ownerOverview='Inserted Record ';
--insert into OwnerReceived(ReceiveFromService,ReceiveFromServiceDate,ReceiveAmount)
--values (@receiveFromService,@receiveFromServiceDate,@receiveAmount,@ownerOverview,getdate());
--PRINT 'AFTER INSERT trigger fired.'
--GO

--CREATE TRIGGER trgAfterUpdate on dbo.ServiceAuthority
--FOR Update
--AS declare @receiveFromService int, @receiveAmount money, @receiveFromServiceDate money, @totallReceiveAmount money,@givingLoanAmount money,@ownerOverview varchar(100);
--		select @receiveFromService=i.ServiceID from inserted i;
--		select @receiveAmount=i.RecevedCharge from inserted i;
--		select @receiveFromServiceDate=i.RecevedChargeDate from inserted i;
--	set @ownerOverview='Updated Record ';
--insert into OwnerReceived(ReceiveFromService,ReceiveFromServiceDate,ReceiveAmount)
--values (@receiveFromService,@receiveFromServiceDate,@receiveAmount,@ownerOverview,getdate());
--PRINT 'AFTER Update trigger fired.'
--GO

--CREATE TRIGGER trgAfterDelete on dbo.ServiceAuthority
--FOR Delete
--AS 
--declare @receiveFromService int, @receiveAmount money, @receiveFromServiceDate money, @totallReceiveAmount money,@givingLoanAmount money,@ownerOverview varchar(100);
--		select @receiveFromService=d.ServiceID from deleted d;
--		select @receiveAmount=d.RecevedCharge from deleted d;
--		select @receiveFromServiceDate=d.RecevedChargeDate from deleted d;
--	set @ownerOverview='Delete Record ';
--insert into OwnerReceived(ReceiveFromService,ReceiveFromServiceDate,ReceiveAmount)
--values (@receiveFromService,@receiveFromServiceDate,@receiveAmount,@ownerOverview,getdate());
--PRINT 'AFTER Delete trigger fired.'
--GO


CREATE TRIGGER trggAfterINSERTED on mydream.dbo.ServiceAuthority
FOR insert
AS 
	declare                 @ownerOverview varchar(100),
							@overviewDate datetime,
							@ovw_ServiceID int,
							@ovw_RecevedCharge int,
							@ovw_RecevedChargeDate date,
							@ovw_TotallReceiveAmount money,
							@ovw_SendToAdminPanel money,
							@ovw_SendToDigitalMarketing money,
							@ovw_SendToPiggyReservedFund money,
							@ovw_SendToOwnerFund money,
							@ovw_ReceivedLoan money,
							@ovw_ReceivedLoanDate date,
							@ovw_GiveLoan money,
							@ovw_GiveLoanDate date,
							@ovw_AvailableBalance money;
		select @ovw_ServiceID=i.ServiceID from inserted i;
		select @ovw_RecevedCharge=i.RecevedCharge from inserted i;
		select @ovw_RecevedChargeDate=i.RecevedChargeDate from inserted i;
		select @ovw_TotallReceiveAmount=i.TotallReceiveAmount from inserted i;
		select @ovw_SendToAdminPanel=i.SendToAdminPanel from inserted i;
		select @ovw_SendToDigitalMarketing=i.SendToDigitalMarketing from inserted i;
		select @ovw_SendToPiggyReservedFund=i.SendToPiggyReservedFund from inserted i;
		select @ovw_SendToOwnerFund=i.SendToOwnerFund from inserted i;
		select @ovw_ReceivedLoan=i.ReceivedLoan from inserted i;
		select @ovw_ReceivedLoanDate=i.ReceivedLoanDate from inserted i;
		select @ovw_GiveLoan=i.GiveLoan from inserted i;
		select @ovw_GiveLoanDate=i.GiveLoanDate from inserted i;
		select @ovw_AvailableBalance=i.AvailableBalance from inserted i;

	set @ownerOverview='inserted Record ';
insert into OwnerReceived(OwnerOverview ,OverviewDate,Ovw_ServiceID,Ovw_RecevedCharge,Ovw_RecevedChargeDate,Ovw_TotallReceiveAmount,
							Ovw_SendToAdminPanel,Ovw_SendToDigitalMarketing,Ovw_SendToPiggyReservedFund,Ovw_SendToOwnerFund,Ovw_ReceivedLoan ,
							Ovw_ReceivedLoanDate ,Ovw_GiveLoan,Ovw_GiveLoanDate,Ovw_AvailableBalance)

values 
							(@ownerOverview ,
							@overviewDate ,
							@ovw_ServiceID ,
							@ovw_RecevedCharge ,
							@ovw_RecevedChargeDate ,
							@ovw_TotallReceiveAmount ,
							@ovw_SendToAdminPanel,
							@ovw_SendToDigitalMarketing ,
							@ovw_SendToPiggyReservedFund ,
							@ovw_SendToOwnerFund ,
							@ovw_ReceivedLoan ,
							@ovw_ReceivedLoanDate ,
							@ovw_GiveLoan ,
							@ovw_GiveLoanDate ,
							@ovw_AvailableBalance)

PRINT 'AFTER INSERTED trigger fired.'
GO
----------==========================
CREATE TRIGGER trggAfterUpdate on mydream.dbo.ServiceAuthority
FOR UPDATED
AS 
	declare                 @ownerOverview varchar(100),
							@overviewDate datetime,
							@ovw_ServiceID int,
							@ovw_RecevedCharge int,
							@ovw_RecevedChargeDate date,
							@ovw_TotallReceiveAmount money,
							@ovw_SendToAdminPanel money,
							@ovw_SendToDigitalMarketing money,
							@ovw_SendToPiggyReservedFund money,
							@ovw_SendToOwnerFund money,
							@ovw_ReceivedLoan money,
							@ovw_ReceivedLoanDate date,
							@ovw_GiveLoan money,
							@ovw_GiveLoanDate date,
							@ovw_AvailableBalance money;
		select @ovw_ServiceID=i.ServiceID from inserted i;
		select @ovw_RecevedCharge=i.RecevedCharge from inserted i;
		select @ovw_RecevedChargeDate=i.RecevedChargeDate from inserted i;
		select @ovw_TotallReceiveAmount=i.TotallReceiveAmount from inserted i;
		select @ovw_SendToAdminPanel=i.SendToAdminPanel from inserted i;
		select @ovw_SendToDigitalMarketing=i.SendToDigitalMarketing from inserted i;
		select @ovw_SendToPiggyReservedFund=i.SendToPiggyReservedFund from inserted i;
		select @ovw_SendToOwnerFund=i.SendToOwnerFund from inserted i;
		select @ovw_ReceivedLoan=i.ReceivedLoan from inserted i;
		select @ovw_ReceivedLoanDate=i.ReceivedLoanDate from inserted i;
		select @ovw_GiveLoan=i.GiveLoan from inserted i;
		select @ovw_GiveLoanDate=i.GiveLoanDate from inserted i;
		select @ovw_AvailableBalance=i.AvailableBalance from inserted i;

	set @ownerOverview='UPDATED Record ';
insert into OwnerReceived(OwnerOverview ,OverviewDate,Ovw_ServiceID,Ovw_RecevedCharge,Ovw_RecevedChargeDate,Ovw_TotallReceiveAmount,
							Ovw_SendToAdminPanel,Ovw_SendToDigitalMarketing,Ovw_SendToPiggyReservedFund,Ovw_SendToOwnerFund,Ovw_ReceivedLoan ,
							Ovw_ReceivedLoanDate ,Ovw_GiveLoan,Ovw_GiveLoanDate,Ovw_AvailableBalance)

values 
							(@ownerOverview ,
							@overviewDate ,
							@ovw_ServiceID ,
							@ovw_RecevedCharge ,
							@ovw_RecevedChargeDate ,
							@ovw_TotallReceiveAmount ,
							@ovw_SendToAdminPanel,
							@ovw_SendToDigitalMarketing ,
							@ovw_SendToPiggyReservedFund ,
							@ovw_SendToOwnerFund ,
							@ovw_ReceivedLoan ,
							@ovw_ReceivedLoanDate ,
							@ovw_GiveLoan ,
							@ovw_GiveLoanDate ,
							@ovw_AvailableBalance)

PRINT 'AFTER UPDATED trigger fired.'
GO

-----------===============================
CREATE TRIGGER trggAfterDELETED on mydream.dbo.ServiceAuthority
FOR DELETED
AS 
	declare                 @ownerOverview varchar(100),
							@overviewDate datetime,
							@ovw_ServiceID int,
							@ovw_RecevedCharge int,
							@ovw_RecevedChargeDate date,
							@ovw_TotallReceiveAmount money,
							@ovw_SendToAdminPanel money,
							@ovw_SendToDigitalMarketing money,
							@ovw_SendToPiggyReservedFund money,
							@ovw_SendToOwnerFund money,
							@ovw_ReceivedLoan money,
							@ovw_ReceivedLoanDate date,
							@ovw_GiveLoan money,
							@ovw_GiveLoanDate date,
							@ovw_AvailableBalance money;
		select @ovw_ServiceID=d.ServiceID from deleted d;
		select @ovw_RecevedCharge=d.RecevedCharge from deleted d;
		select @ovw_RecevedChargeDate=d.RecevedChargeDate from deleted d;
		select @ovw_TotallReceiveAmount=d.TotallReceiveAmount from deleted d;
		select @ovw_SendToAdminPanel=d.SendToAdminPanel from deleted d;
		select @ovw_SendToDigitalMarketing=d.SendToDigitalMarketing from deleted d;
		select @ovw_SendToPiggyReservedFund=d.SendToPiggyReservedFund from deleted d;
		select @ovw_SendToOwnerFund=d.SendToOwnerFund from deleted d;
		select @ovw_ReceivedLoan=d.ReceivedLoan from deleted d;
		select @ovw_ReceivedLoanDate=d.ReceivedLoanDate from deleted d;
		select @ovw_GiveLoan=d.GiveLoan from deleted d;
		select @ovw_GiveLoanDate=d.GiveLoanDate from deleted d;
		select @ovw_AvailableBalance=d.AvailableBalance from deleted d;

	set @ownerOverview='DELETED Record ';
insert into OwnerReceived(OwnerOverview ,OverviewDate,Ovw_ServiceID,Ovw_RecevedCharge,Ovw_RecevedChargeDate,Ovw_TotallReceiveAmount,
							Ovw_SendToAdminPanel,Ovw_SendToDigitalMarketing,Ovw_SendToPiggyReservedFund,Ovw_SendToOwnerFund,Ovw_ReceivedLoan ,
							Ovw_ReceivedLoanDate ,Ovw_GiveLoan,Ovw_GiveLoanDate,Ovw_AvailableBalance)

values 
							(@ownerOverview ,
							@overviewDate ,
							@ovw_ServiceID ,
							@ovw_RecevedCharge ,
							@ovw_RecevedChargeDate ,
							@ovw_TotallReceiveAmount ,
							@ovw_SendToAdminPanel,
							@ovw_SendToDigitalMarketing ,
							@ovw_SendToPiggyReservedFund ,
							@ovw_SendToOwnerFund ,
							@ovw_ReceivedLoan ,
							@ovw_ReceivedLoanDate ,
							@ovw_GiveLoan ,
							@ovw_GiveLoanDate ,
							@ovw_AvailableBalance)

PRINT 'AFTER DELETED trigger fired.'
GO

--------------===============================================


























