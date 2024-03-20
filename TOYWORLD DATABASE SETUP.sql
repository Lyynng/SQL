--câu 1--
CREATE DATABASE TOY2
ON PRIMARY
  ( NAME='TOY_DATA',
    FILENAME=
       'T:\NguyenThiKhanhLinh\TOY2.mdf',
    SIZE=5MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP TOYWORLD_FG1
  ( NAME = 'TOYWORLD_FG1_Dat1',
    FILENAME =
       'T:\NguyenThiKhanhLinh\TOYWORLD_FG1_1.ndf',
    SIZE = 2MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP FileTOY2
  ( NAME = 'TOYWORLD2_FG',
    FILENAME = 'T:\NguyenThiKhanhLinh\FILEWORLD')
LOG ON
  ( NAME='TOY2_log',
    FILENAME =
       'T:\NguyenThiKhanhLinh\TOY2_LOG.ldf',
    SIZE=2MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB);
--câu 2--
CREATE TYPE [dbo].[Category_Type] FROM [char](3) NULL
CREATE TYPE [dbo].[OrderNumber] FROM [nvarchar](25) NULL
CREATE TYPE [dbo].[Phone] FROM [char](12) NULL
--câu 3--
create table Toys
	(ToyId char(6) primary key,
	 ToyName varchar(20),
	 ToyDescription varchar(250),
	 CategoryId char(3),
	 ToyRate money,
	 BrandId char(3),
	 Photo image null ,
	 ToyQoh smallint,
	 LowerAge smallint default 1,
	 UpperAge smallint,
	 ToyWeight smallint,
	 ToyImgPath varchar(50) null ,
	 constraint check_ToyQoH check (ToyQoH between 0 and 200),
	 FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId),
	 FOREIGN KEY (BrandId) REFERENCES ToyBrand(BrandId),
	 )
create table Category
	(CategoryId char(3) primary key,
	 Category char(20) unique,
	 iDescription varchar(100) null)
create table ToyBrand
	(BrandId char(3) primary key,
	 BrandName char(20) unique)
