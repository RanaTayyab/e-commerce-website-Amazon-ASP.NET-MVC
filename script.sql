USE [master]
GO
/****** Object:  Database [MyAmazonDB]    Script Date: 12/11/2016 6:25:47 AM ******/
CREATE DATABASE [MyAmazonDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyAmazonDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\MyAmazonDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MyAmazonDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\MyAmazonDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [MyAmazonDB] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MyAmazonDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MyAmazonDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyAmazonDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyAmazonDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyAmazonDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyAmazonDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyAmazonDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MyAmazonDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyAmazonDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyAmazonDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyAmazonDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyAmazonDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyAmazonDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyAmazonDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyAmazonDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyAmazonDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MyAmazonDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyAmazonDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyAmazonDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MyAmazonDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MyAmazonDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyAmazonDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyAmazonDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MyAmazonDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MyAmazonDB] SET  MULTI_USER 
GO
ALTER DATABASE [MyAmazonDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyAmazonDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MyAmazonDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MyAmazonDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MyAmazonDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MyAmazonDB] SET QUERY_STORE = OFF
GO
USE [MyAmazonDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [MyAmazonDB]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Description] [varchar](1000) NULL,
	[Price] [varchar](50) NULL,
	[ImageUrl] [varchar](500) NULL,
	[CategoryID] [int] NULL,
	[ProductQuantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerProducts]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerProducts](
	[CustomerID] [int] NULL,
	[ProductID] [int] NULL,
	[TotalProduct] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[GettingProductsAll]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[GettingProductsAll]
as
select * from (
	
	select P.CategoryID,


		P.ProductID,P.Name,P.Price,
		P.ImageUrl, C.CategoryName ,
		P.ProductQuantity,
		Isnull (Sum(CP.TotalProduct),0) As ProductSold,
		(P.ProductQuantity- Isnull(Sum(CP.TotalProduct) ,0) )as AvailableStock
		From Products P
		inner join Category C
		on C.CategoryID=P.CategoryID
		left join CustomerProducts CP
		on CP.ProductID=P.ProductID
	group by
	P.ProductID,P.Name,P.Price,
	P.ImageUrl, 
	C.CategoryName,
	P.ProductQuantity,
	P.CategoryID)as   StockTable
	
	where AvailableStock>0



GO
/****** Object:  Table [dbo].[CustomerDetails]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](100) NULL,
	[CustomerEmailID] [varchar](100) NULL,
	[CustomerPhoneNo] [varchar](20) NULL,
	[CustomerAddress] [varchar](500) NULL,
	[TotalProducts] [int] NULL,
	[TotalPrice] [int] NULL,
	[OrderDateTime] [datetime] NULL,
	[PaymentMethod] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[EverythingInCustomers]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[EverythingInCustomers]
as
select * from CustomerDetails join CustomerProducts
on CustomerDetails.Id=CustomerProducts.CustomerID
GO
/****** Object:  View [dbo].[getallcategory]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[getallcategory] AS
select * from Category
GO
/****** Object:  Table [dbo].[DeliveryStatus]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TransactionNo] [int] NULL,
	[StatusMessage] [varchar](100) NULL,
	[DataEntry] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Members]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Members](
	[MemberID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](30) NULL,
	[LastName] [varchar](30) NULL,
	[Password] [varchar](30) NULL,
	[ConfirmPassword] [varchar](30) NULL,
	[Email] [varchar](30) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [varchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[MemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CustomerDetails] ADD  DEFAULT (getdate()) FOR [OrderDateTime]
GO
ALTER TABLE [dbo].[DeliveryStatus] ADD  DEFAULT (getdate()) FOR [DataEntry]
GO
/****** Object:  StoredProcedure [dbo].[Adding_orderstat]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Adding_orderstat]
(
@TransactionNo int,
@OrderStatus varchar(300),
@Flag int
)
AS
BEGIN
BEGIN TRY

if(@Flag=1)
begin
insert into DeliveryStatus(TransactionNo,StatusMessage ) values
(
@TransactionNo,
@OrderStatus
)
end

select StatusMessage as ShipmentStatus,DataEntry as UpdatedOn from DeliveryStatus where TransactionNo=@TransactionNo
 
 END TRY
BEGIN CATCH
---INSERT INTO dbo.Errorlog
--VALUES(ERROR_HESSAGE(),'sp_GetAllDate')
PRINT( ERROR_MESSAGE() )
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AddingCustomer]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_AddingCustomer]
(
@FName varchar(30),
@LName varchar(30),
@Pwd1 varchar (30),
@Pwd2 varchar (30),
@Emailing varchar (30),
@DOB1 varchar (30),
@Gender varchar (2)


)
AS
BEGIN
BEGIN TRY
Insert into Members (FirstName,LastName, [Password], ConfirmPassword, Email,DateOfBirth,Gender)
values(
@FName,@LName,@Pwd1,@Pwd2,@Emailing,@DOB1,@Gender)
End try
BEGIN CATCH
-----INSERT INTO dbo.ErrorLog _VALUES(ERROR_HESSAGE(),'sp_GetAllData')
 PRINT( 'Error occured' )
END CATCH
END



GO
/****** Object:  StoredProcedure [dbo].[SP_Addingone]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Addingone]
(
@ProductName varchar(300),
@ProductPrice int,
@ProductDescription varchar (1000),
@CategoryID int,
@ImageUrl varchar (500),
@ProductQuantity int

)
AS
BEGIN tran

if( @ProductName is not null and  @ProductPrice is not null and  @ProductDescription is not null and  @CategoryID is not null and  @ImageUrl is not null and @ProductQuantity is not null )
begin
Insert into Products (Name, Price, [Description], CategoryID, ImageUrl,ProductQuantity)
values(
@ProductName,@ProductPrice, @ProductDescription, @CategoryID, @ImageUrl,@ProductQuantity)

commit tran
end
else
begin
rollback tran
end

GO
/****** Object:  StoredProcedure [dbo].[SP_AddNewCategory]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_AddNewCategory]
( 
@CategoryName varchar(200)

)
AS
BEGIN
BEGIN TRY
	insert into Category 
	values (@CategoryName)
END TRY
BEGIN CATCH

 PRINT( 'Error occured' )
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CheckLogin]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CheckLogin]
(

@Emailing varchar (100),
@Pwd1  varchar (100)

)
AS
BEGIN
BEGIN Tran


if (exists(
select Email, [Password] from Members
where Email = @Emailing and [Password] = @Pwd1)
)

begin
	commit tran
end

else
begin
	rollback tran
	end


end
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteCategory]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[SP_DeleteCategory]
( 
@CategoryName varchar(200)

)
AS
BEGIN
BEGIN TRY
	delete from Category
	where CategoryName=@CategoryName
END TRY
BEGIN CATCH

 PRINT( 'Error occured' )
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteTheProduct]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[SP_DeleteTheProduct]
( 
@ProductName varchar(200)

)
AS
BEGIN
BEGIN TRY
	delete from Products
	where [Name]=@ProductName
END TRY
BEGIN CATCH

 PRINT( 'Error occured' )
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllCategories]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetAllCategories]
AS
BEGIN
BEGIN TRY
select * from getallcategory
 END TRY
BEGIN CATCH
-----INSERT INTO dbo.ErrorLog _VALUES(ERROR_HESSAGE(),'sp_GetAllData')
 PRINT( 'Error occured' )
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllProducts]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_GetAllProducts]
(@CategoryID int)
as begin
begin try
	if(@CategoryID <> 0)
	begin

	
	select * from (select P.CategoryID,
		P.ProductID,P.Name,P.Price,
		P.ImageUrl, C.CategoryName ,
		P.ProductQuantity,
		Isnull (Sum(CP.TotalProduct),0) As ProductSold,
		(P.ProductQuantity- Isnull(Sum(CP.TotalProduct) ,0) )as AvailableStock
		From Products P
		inner join Category C
		on C.CategoryID=P.CategoryID
		left join CustomerProducts CP
		on CP.ProductID=P.ProductID
	group by
	P.ProductID,P.Name,P.Price,
	P.ImageUrl, 
	C.CategoryName,
	P.ProductQuantity,
	P.CategoryID) as StockTable
	
	where AvailableStock>0
	and  CategoryID=@CategoryID


	End


	else 
	begin

	select * from dbo.GettingProductsAll

	end

	End try
	BEGIN CATCH
-----INSERT INTO dbo.ErrorLog _VALUES(ERROR_HESSAGE(),'sp_GetAllData')
 PRINT( 'Error occured' )
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAvailableStock]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[SP_GetAvailableStock]
(@StockType int,
@CategoryID int)
as
begin

begin try 
declare @StartRange int;
declare @EndRange int;

	if(@StockType=0)
	begin
	set @StartRange=0;
	set  @EndRange=0; 
	end

	if(@StockType=1)
	begin
	set @StartRange=1;
	set  @EndRange=10; 
	end


	if(@StockType=2)
	begin
	set @StartRange=11;
	set  @EndRange=10000; 
	end


	if(@CategoryID=0)
	begin
	select * from
	(
		select p.[name],p.price,p.imageurl,c.categoryname,
		p.productquantity, ISNULL(SUM(cp.totalproduct),0) as Product_Sold,
		( p.productquantity - ISNULL(SUM(cp.totalproduct),0) ) as AvailableStock
		from products p
		inner join Category c on c.CategoryID= p.CategoryID
		left join CustomerProducts cp
		on cp.ProductID = p.productid
		group by cp.ProductID,
		p.[name],p.price,p.imageurl,c.CategoryName,p.productquantity) StockTable
	  where AvailableStock between @StartRange and @EndRange
	end
	else
	begin
	select * from
	(
		select p.[name],p.price,p.imageurl,c.categoryname,
		p.productquantity, ISNULL(SUM(cp.totalproduct),0) as Product_Sold,
		(p.productquantity - ISNULL(SUM(cp.totalproduct),0) ) as AvailableStock
		from products p
		inner join Category c on c.CategoryID= p.CategoryID
		left join CustomerProducts cp
		on cp.ProductID = p.productid
		where c.CategoryID=@CategoryID
		group by cp.ProductID,
		p.[name],p.price,p.imageurl,c.CategoryName,p.productquantity) StockTable
	  where AvailableStock between @StartRange and @EndRange

	end

	end try 

BEGIN CATCH
PRINT ('Error occured' ) 
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetIncomeReport]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_GetIncomeReport]
(
@ReportType int
)
as
 begin


begin try
Declare @Today varchar(50 )=Day(getdate());


Declare @Month varchar(50)=Month(getdate());
Declare @Year varchar(50)= year(getdate());;


--select @Today =Day(getdate()),@Month=(getdate()),@Year=(getdate())



if (@ReportType=1)
begin 
		select * from (select *, Day(OrderDateTime) as TodayDay ,Month(OrderDateTime) as ThisMonth, YEAR(OrderDateTime) as ThisYear
		from CustomerDetails) IncomeTable where @Today=TodayDay and @Month=ThisMonth and @Year = ThisYear

end

if (@ReportType=2)
begin

select * from (select *, Day(OrderDateTime) as TodayDay ,Month(OrderDateTime) as ThisMonth, YEAR(OrderDateTime) as ThisYear
		from CustomerDetails) IncomeTable where  @Month=ThisMonth and @Year = ThisYear

end

if (@ReportType=3)
begin
select * from (select *, Day(OrderDateTime) as TodayDay ,Month(OrderDateTime) as ThisMonth, YEAR(OrderDateTime) as ThisYear
		from CustomerDetails) IncomeTable where  @Year = ThisYear


end


end try 

BEGIN CATCH
PRINT ('Error occured' ) 
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetOrderList]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_GetOrderList]
(

@Flag int
)
as
begin 


begin try
if(@flag<>0)
begin 
select * from CustomerDetails where id=@Flag;

end
else
begin 
select * from CustomerDetails
end
end try 

BEGIN CATCH
PRINT ('Error occured' ) 
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetTransactionDetails]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SP_GetTransactionDetails]
(

@TransactionNo int
)
AS
BEGIN	
BEGIN TRY

select P.[Name],P.ImageUrl,P.Price,CP.TotalProduct as

 ProductQuantity from Products P inner join CustomerProducts CP

on CP.ProductID=P.ProductID
where CP.CustomerID=@TransactionNo
END TRY
BEGIN CATCH
---INSERT INTO dbo.Errorlog
--VALUES(ERROR_HESSAGE(),'sp_GetAllDate')
PRINT( ERROR_MESSAGE() )
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SaveCustomerDetails]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[SP_SaveCustomerDetails]
(
@CustomerName varchar(100), 
@CustomerEmailID varchar(100), 
@CustomerPhoneNo varchar(20), 
@CustomerAddress varchar(500), 
@TotalProducts int,
@TotalPrice int,
@PaymentMethod varchar(100)
)
AS
BEGIN
BEGIN TRY
insert into CustomerDetails(CustomerName,CustomerEmailID,CustomerPhoneNo,CustomerAddress,TotalProducts,TotalPrice,PaymentMethod)

 values(@CustomerName,@CustomerEmailID,@CustomerPhoneNo,@CustomerAddress,@TotalProducts,@TotalPrice,@PaymentMethod)
--select Id as CustomerlD from CustomerOetails
--where CustomerName4rustomerName and CustomerEmailID4CustomerEmailID
select @@IDENTITY as CustomerID
 END TRY
BEGIN CATCH
PRINT( 'Error occured' )
 END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SaveCustomerProducts]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_SaveCustomerProducts]
(
@CustomerID int, 
@ProductID int,
 @TotalProduct int
 )
AS
BEGIN
BEGIN TRY
insert into CustomerProducts( CustomerID,ProductID,TotalProduct) values (@CustomerID,@ProductID,@TotalProduct)
END TRY 
BEGIN CATCH
PRINT ('Error occured' ) 
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateCategory]    Script Date: 12/11/2016 6:25:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[SP_UpdateCategory]
( 
@CategoryName varchar(200),
@CategoryName2 varchar(200)

)
AS
BEGIN
BEGIN TRY
	update Category
	set CategoryName = @CategoryName2
	where CategoryName=@CategoryName
END TRY
BEGIN CATCH

 PRINT( 'Error occured' )
END CATCH
END

GO
USE [master]
GO
ALTER DATABASE [MyAmazonDB] SET  READ_WRITE 
GO
