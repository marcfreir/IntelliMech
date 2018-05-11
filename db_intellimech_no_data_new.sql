-- SUBJECT: DATABASE PROJECT - INTELLIMECH PROJECT
-- AUTHOR: MARC FREIR
-- LICENCE: This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.

-- CREATING DATABASE
CREATE DATABASE db_intellimech_no_data;

-- USING THE DB
USE db_intellimech_no_data;

-- DROPING THE DB
DROP DATABASE db_intellimech;

-- CREATING THE TABLES

-- CREATING LOGIN TABLE - FIRST TEST
CREATE TABLE tb_login
(
  login_adm VARCHAR (45),
  password_adm VARCHAR (45)
) Engine = InnoDB DEFAULT CHARSET = UTF8;

-- CREATING A WRONG USER TABLE
CREATE TABLE tb_wronguser
(
  -- THIS IS THE PROTOCOL CODE FOR THE WRONG USER
  wronguserid INT NOT NULL AUTO_INCREMENT,
  wrongusercode VARCHAR (7),
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_wronguserid PRIMARY KEY(wronguserid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;

-- CREATING A USER SESSION TABLE
CREATE TABLE tb_usersession
(
  -- THIS IS THE PROTOCOL CODE FOR THE SESSION
  sessionuserid INT NOT NULL AUTO_INCREMENT,
  protocolusercode VARCHAR (7),
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_sessionuserid PRIMARY KEY(sessionuserid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;

-- CREATING USERS TABLE
CREATE TABLE tb_users
(
  -- MAIN (PRINCIPAL)
  userid INT NOT NULL AUTO_INCREMENT,
  username VARCHAR (80) NOT NULL,
  useremail VARCHAR (50) NOT NULL,
  -- IF THE USER PROFILE IS OPERATOR/TECHNICIAN 2 WILL ENABLE PRIVILEGED FUNCTIONS
  userprofile VARCHAR (10) NOT NULL,
  
  -- CREDENTIALS (CREDENCIAIS) IF THE USER PROFILE IS OPERATOR/TECHNICIAN 2 WILL ENABLE PRIVILEGED FUNCTIONS
  userlogin VARCHAR (45) NOT NULL UNIQUE,
  userpassword VARCHAR (20) NOT NULL,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_userid PRIMARY KEY(userid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING EMPLOYEE TABLE
CREATE TABLE tb_employee
(
-- DATA AS EMPLOYEE (DADOS COMO FUNCIONÁRIO)
  empid INT NOT NULL AUTO_INCREMENT,
  empname VARCHAR (80) NOT NULL,
  empemail VARCHAR (50) NOT NULL,
  empaddress VARCHAR (100),
  empbirthdate VARCHAR (10),
  empphone VARCHAR (30),
  empoccupation VARCHAR (45),
  empsector VARCHAR (45),
  emphiredate VARCHAR (10),
  empdismissaldate VARCHAR (10),
  empstatus VARCHAR (20),
  empgrosssalary DOUBLE,
  empnetsalary DOUBLE,
  empovertime VARCHAR (8),
  empobservation TEXT,
  -- ENABLED ONLY FOR MAINTENANCE TECHNICIAN
  empextracommitment VARCHAR (45),
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_empid PRIMARY KEY(empid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING MANPOWER TABLE
CREATE TABLE tb_manpower
(
  mpcode INT NOT NULL,
  mpcodesuffix CHAR (1),
  mpdescription VARCHAR (90) NOT NULL,
  mphourprice DOUBLE NOT NULL,
  mphourpricecents DOUBLE,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_mpcode PRIMARY KEY(mpcode)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING SERVICE TABLE
CREATE TABLE tb_service
(
  serviceid INT NOT NULL,
  servicetype VARCHAR (50),
  serviceprice DOUBLE,
  servicempcode INT NOT NULL,
  servicempdescription VARCHAR (90) NOT NULL,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_serviceid PRIMARY KEY(serviceid),
  CONSTRAINT fk_servicempcode FOREIGN KEY(servicempcode)
  REFERENCES tb_manpower(mpcode)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING PART TABLE
CREATE TABLE tb_part
(
  partid INT NOT NULL AUTO_INCREMENT,
  parttype VARCHAR (80) NOT NULL,
  partdescription VARCHAR (80),
  partprice DOUBLE,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_partid PRIMARY KEY(partid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING CUSTOMER TABLE
CREATE TABLE tb_customer
(
  customerid INT NOT NULL AUTO_INCREMENT,
  customername VARCHAR (80) NOT NULL,
  customeraddress VARCHAR (90) NOT NULL,
  customerphone VARCHAR (30),
  customerentrydate VARCHAR (10),
  customerperformedservices TEXT,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_customerid PRIMARY KEY(customerid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING CAR TABLE
CREATE TABLE tb_car
(
  carid INT NOT NULL AUTO_INCREMENT,
  carcustomerid INT NOT NULL,
  carregistrationplate VARCHAR (30) NOT NULL,
  carbrand VARCHAR (80) NOT NULL,
  carcolor VARCHAR (50) NOT NULL,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_carid PRIMARY KEY(carid),
  CONSTRAINT fk_carcustomerid FOREIGN KEY(carcustomerid)
  REFERENCES tb_customer(customerid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING CUSTOMER NATURAL PERSON TABLE
CREATE TABLE tb_custnaturalperson
(
  customernpdocumentation INT NOT NULL UNIQUE,
  customernpid INT NOT NULL,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_customernpdocumentation PRIMARY KEY(customernpdocumentation),
  CONSTRAINT fk_customernpid FOREIGN KEY(customernpid)
  REFERENCES tb_customer(customerid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING CUSTOMER LEGAL PERSON TABLE
CREATE TABLE tb_custlegalperson
(
  customerlpdocumentation INT NOT NULL UNIQUE,
  customerlpid INT NOT NULL,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_customerlpdocumentation PRIMARY KEY(customerlpdocumentation),
  CONSTRAINT fk_customerlpid FOREIGN KEY(customerlpid)
  REFERENCES tb_customer(customerid)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING DISCOUNT POLICY TABLE
CREATE TABLE tb_discountpolicy
(
  dpdiscountcode INT NOT NULL UNIQUE,
  dptotalprice DOUBLE,
  dpdiscount DOUBLE,
  
  -- CREATING CONSTRAINT
  CONSTRAINT pk_dpdiscountcode PRIMARY KEY(dpdiscountcode)
) Engine = InnoDB DEFAULT CHARSET = UTF8;


-- CREATING SERVICE ORDER TABLE
CREATE TABLE tb_serviceorder
(
  soid INT NOT NULL AUTO_INCREMENT,
  souserid INT NOT NULL,
  soidtechnician INT NOT NULL,
  sousernametechnician VARCHAR (80) NOT NULL,
  socustomerid INT NOT NULL,
  socustomername VARCHAR (80) NOT NULL,
  socustomeraddress VARCHAR (90) NOT NULL,
  socustomerphone VARCHAR (30),
  socarid INT NOT NULL,
  socarregistrationplate VARCHAR (30) NOT NULL,
  soissuedate VARCHAR (10),
  soscheduling VARCHAR (30),
  soserviceid INT NOT NULL,
  soservice VARCHAR (90),
  sopartid INT NOT NULL,
  sopart VARCHAR (90),
  sototalwithoudiscount DOUBLE,
  sodiscountcode INT NOT NULL,
  sodiscount DOUBLE,
  sototalwithdiscount DOUBLE,
  
  -- CREATING CONSTRAINTS
  CONSTRAINT pk_soid PRIMARY KEY(soid),
  CONSTRAINT fk_souserid FOREIGN KEY(souserid)
  REFERENCES tb_users(userid),
  CONSTRAINT fk_soidtechnician FOREIGN KEY(soidtechnician)
  REFERENCES tb_employee(empid),
  CONSTRAINT fk_socarid FOREIGN KEY(socarid)
  REFERENCES tb_car(carid),
  CONSTRAINT fk_socustomerid FOREIGN KEY(socustomerid)
  REFERENCES tb_customer(customerid),
  CONSTRAINT fk_soserviceid FOREIGN KEY(soserviceid)
  REFERENCES tb_service(serviceid),
  CONSTRAINT fk_sopartid FOREIGN KEY(sopartid)
  REFERENCES tb_part(partid),
  CONSTRAINT fk_sodiscountcode FOREIGN KEY(sodiscountcode)
  REFERENCES tb_discountpolicy(dpdiscountcode)
  
) Engine = InnoDB DEFAULT CHARSET = UTF8;



-- CREATING A FUNCTION
DELIMITER //

CREATE FUNCTION f_calctotalwithdiscount (totalwithoutdiscount DOUBLE(7, 2), discount DOUBLE(7, 2))
RETURNS INT

BEGIN
       
   RETURN totalwithoutdiscount - (totalwithoutdiscount * discount / 100);
   
END; //

DELIMITER ;

-- CALLING THE FUNCTION
SELECT f_calctotalwithdiscount (10.00, 90.00) AS TotalwithDiscount ;

-- OR, OPTIONALLY...
-- CREATING TRIGGER DISCOUNT (UPDATE)
DELIMITER //
CREATE TRIGGER tr_discount BEFORE UPDATE
ON tb_serviceorder
FOR EACH ROW
SET NEW.sototalwithdiscount = (NEW.sototalwithoudiscount * 0.30);
//
DELIMITER ;