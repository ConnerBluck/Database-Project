-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements Template

-- Team XX
-- Anneliese Conrad (aconrad9)
-- Neal Austensen (naustensen3)
-- Conner Bluck (cbluck3)
-- Danny Johnsen (djohnsen3)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

drop database if exists Hospital_Phase2;
create database if not exists Hospital_Phase2;
use Hospital_Phase2;

drop table if exists business;
create table business (
bname varchar(70) not null,
street varchar(30) not null,
city varchar(20) not null,
state varchar(10) not null,
zip char(5) not null,
primary key (bname)
);

drop table if exists hospital;
create table hospital (
bname varchar(70) not null,
max_doctors int default null,
budget int default null,
primary key (bname),
foreign key (bname) references business(bname)
);

drop table if exists manufacturer;
create table manufacturer (
bname varchar(70) not null,
catalog_cap int default null,
primary key (bname),
foreign key (bname) references business(bname)
);

drop table if exists doctors;
create table doctors (
  username varchar(30) not null,
  email varchar(30) not null,
  acct_password varchar(20) not null,
  fname varchar(20) default null,
  lname varchar(20) default null,
  hospital varchar(50) not null,
  managed_by varchar(30) default null,
  user_role varchar(20) not null,
  primary key (username),
  foreign key (hospital) references hospital(bname),
  foreign key (managed_by) references doctors(username)
);

drop table if exists administrators;
create table administrators (
  username varchar(30) not null,
  email varchar(30) not null,
  acct_password varchar(20) not null,
  fname varchar(20) default null,
  lname varchar(20) default null,
  manages varchar(50) not null,
  user_role varchar(20) not null,
  primary key (username),
  foreign key (manages) references business(bname)
);


drop table if exists transactions;
create table transactions (
t_id char(4) not null,
tdate date not null,
hospital varchar(50) not null,
primary key(t_id),
foreign key (hospital) references hospital(bname)
);

drop table if exists usage_log;
create table usage_log (
ul_id char(5) not null,
username varchar(20) not null,
time_stamp datetime not null,
primary key (ul_id),
foreign key (username) references doctors(username)
);

drop table if exists product;
create table product (
prod_id varchar(12),
prod_type varchar(12),
color varchar(12),
primary key (prod_id)
);

drop table if exists catalog_item;
create table catalog_item (
manufacturer varchar(50) not null,
prod_id varchar(12),
price float(2) not null,
primary key (manufacturer,prod_id),
foreign key (prod_id) references product(prod_id),
foreign key (manufacturer) references manufacturer(bname)
);

drop table if exists inventory;
create table inventory (
inv_name varchar(40) not null,
inv_street varchar(20) not null,
inv_city varchar(20) not null,
inv_state varchar(120) not null,
inv_zip char(5), 
primary key (inv_name),
foreign key (inv_name) references business(bname)
);

drop table if exists has;
create table has (
bname varchar(40) not null,
prod_id varchar(12) not null,
count int not null, 
primary key (bname,prod_id),
foreign key (prod_id) references product(prod_id),
foreign key (bname) references inventory(inv_name)
);

drop table if exists used;
create table used (
prod_id varchar(12) not null,
ul_id char(5) not null,
count int not null, 
primary key (prod_id,ul_id),
foreign key (prod_id) references product(prod_id),
foreign key (ul_id) references usage_log(ul_id)
);

drop table if exists cat_contains;
create table cat_contains (
t_id char(4) not null,
prod_id varchar(12) not null,
count int not null, 
primary key (t_id,prod_id),
foreign key (t_id) references transactions(t_id),
foreign key (prod_id) references product(prod_id)
);

-- INSERT STATEMENTS BELOW
insert into business values
('Children\'s Healthcare of Atlanta','Clifton Rd NE','Atlanta','Georgia','30332'),
('Piedmont Hospital','Peachtree Rd NW','Atlanta','Georgia','30309'),
('Northside Hospital','Johnson Ferry Road NE','Sandy Springs','Georgia','30342'),
('Emory Midtown','Peachtree St NE','Atlanta','Georgia','30308'),
('Grady Hospital','Jesse Hill Jr Dr SE','Atlanta','Georgia','30303'),
('PPE Empire','Ponce De Leon Ave','Atlanta','Georgia','30308'),
('Buy Personal Protective Equipment, Inc','Spring St','Atlanta','Georgia','30313'),
('Healthcare Supplies of Atlanta','Peachstree St','Atlanta','Georgia','30308'),
('Georgia Tech Protection Lab','North Ave NW','Atlanta','Georgia',30332),
('Marietta Mask Production Company','Appletree Way','Marietta','Georgia','30061'),
('S&J Corporation','Juniper St','Atlanta','Georgia','30339');

insert into hospital values
('Children\'s Healthcare of Atlanta',6,80000),
('Piedmont Hospital',7,95000),
('Northside Hospital',9,72000),
('Emory Midtown',13,120000),
('Grady Hospital',10,81000);

insert into manufacturer values
('PPE Empire',20),
('Buy Personal Protective Equipment, Inc',25),
('Healthcare Supplies of Atlanta',20),
('Georgia Tech Protection Lab',27),
('Marietta Mask Production Company',15),
('S&J Corporation',22);

insert into doctors values 
('drCS4400','cs4400@gatech.edu','30003000','Computer','Science','Children\'s Healthcare of Atlanta',null,'Doctor'),
('doctor_moss','mmoss7@gatech.edu','12341234','Mark','Moss','Piedmont Hospital',null,'Doctor'),
('doctor1','doctor1@gatech.edu','10001000','Doctor','One','Grady Hospital',null,'Doctor'),
('drmcdaniel','mcdaniel@cc.gatech.edu','12345678','Melinda','McDaniel','Northside Hospital',null,'Doctor'),
('musaev_doc','aibek.musaev@gatech.edu','87654321','Aibek','Musaev','Emory Midtown',null,'Doctor'),
('allons_y','tenth_doctor@gatech.edu','10101010','David','Tennant','Northside Hospital','drmcdaniel','Doctor'),
('aziz_01','ehh01@gatech.edu','90821348','Amit','Aziz','Piedmont Hospital','doctor_moss','Doctor'),
('bones','doctor_mccoy@gatech.edu','11223344','Leonard','McCoy','Grady Hospital','doctor1','Doctor'),
('bow_ties _are_cool','eleventh_doctor@gatech.edu','11111111','Matt','Smith','Emory Midtown','musaev_doc','Doctor'),
('Burdell','GeorgeBurdell@gatech.edu','12345678','George','Burdell','Northside Hospital','drmcdaniel','Doctor-Admin'),
('Buzz','THWG@gatech.edu','98765432','Buzz','Tech','Piedmont Hospital','doctor_moss','Doctor-Admin'),
('doc_in_da_house','tv_doctor@gatech.edu','30854124','Gregory','House','Children\'s Healthcare of Atlanta','drCS4400','Doctor'),
('doctor2','doctor2@gatech.edu','20002000','Doctor','Two','Children\'s Healthcare of Atlanta','drCS4400','Doctor'),
('dr_dolittle','dog_doc@gatech.edu','37377373','John','Dolittle','Emory Midtown','musaev_doc','Doctor'),
('dr_mory','JackMM@gatech.edu','12093015','Jack','Mory','Northside Hospital','drmcdaniel','Doctor'),
('drake_remoray','f_r_i_e_n_d_s@gatech.edu','24598543','Joey','Tribbiani','Northside Hospital','drmcdaniel','Doctor'),
('fantastic','ninth_doctor@gatech.edu','99999999','Chris','Eccleston','Piedmont Hospital','doctor_moss','Doctor'),
('grey_jr','dr_grey@gatech.edu','87878787','Meredith','Shepard','Piedmont Hospital','doctor_moss','Doctor'),
('hannah_hills','managerEHH@gatech.edu','13485102','Hannah','Hills','Grady Hospital','doctor1','Doctor'),
('henryjk','HenryJK@gatech.edu','54238912','Henry','Kims','Children\'s Healthcare of Atlanta','drCS4400','Doctor'),
('jekyll_not_hyde','jekyll1886@gatech.edu','56775213','Henry','Jekyll','Piedmont Hospital','doctor_moss','Doctor'),
('Jones01','jones01@gatech.edu','52935481','Johnes','Boys','Emory Midtown','musaev_doc','Doctor'),
('mcdreamy','dr_shepard@gatech.edu','13311332','Derek','Shepard','Children\'s Healthcare of Atlanta','drCS4400','Doctor'),
('sonic_shades','twelfth_doctor@gatech.edu','12121212','Peter','Capaldi','Grady Hospital','doctor1','Doctor'),
('young_doc','howser@gatech.edu','80088008','Doogie','Howser','Northside Hospital','drmcdaniel','Doctor');

insert into administrators values
('bppe_admin','bppe_admin@gatech.edu','35045790','Admin','Two','Buy Personal Protective Equipment, Inc','Admin'),
('Burdell','GeorgeBurdell@gatech.edu','12345678','George','Burdell','Northside Hospital','Doctor-Admin'),
('Buzz','THWG@gatech.edu','98765432','Buzz','Tech','Piedmont Hospital','Doctor-Admin'),
('choa_admin','choa_admin@gatech.edu','35045790','Addison','Ambulance','Children\'s Healthcare of Atlanta','Admin'),
('emory_admin','emory_admin@gatech.edu','33202257','Elizabeth','Tucker','Emory Midtown','Admin'),
('grady_admin','grady_admin@gatech.edu','67181125','Taylor','Booker','Grady Hospital','Admin'),
('gtpl_admin','gtpl_admin@gatech.edu','14506524','Shaundra','Apple','Georgia Tech Protection Lab','Admin'),
('hsa_admin','hsa_admin@gatech.edu','75733271','Jennifer','Tree','Healthcare Supplies of Atlanta','Admin'),
('mmpc_admin','mmpc_admin@gatech.edu','22193897','Nicholas','Cage','Marietta Mask Production Company','Admin'),
('northside_admin','northside_admin@gatech.edu','38613312','Johnathan','Smith','Northside Hospital','Admin'),
('piedmont_admin','piedmont_admin@gatech.edu','36846830','Rohan','Right','Piedmont Hospital','Admin'),
('ppee_admin','ppee_admin@gatech.edu','27536292','Admin','One','PPE Empire','Admin'),
('sjc_admin','sjc_admin@gatech.edu','74454118','Trey','Germs','S&J Corporation','Admin');

INSERT INTO transactions VALUES ('0001',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Children\'s Healthcare of Atlanta'),
('0002',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Children\'s Healthcare of Atlanta'),
('0003',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Emory Midtown'),
('0004',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Grady Hospital'),
('0005',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Northside Hospital'),
('0006',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Children\'s Healthcare of Atlanta'),
('0007',STR_TO_DATE('3/10/2020','%m/%d/%Y'),'Piedmont Hospital'),
('0008',STR_TO_DATE('5/1/2020','%m/%d/%Y'),'Northside Hospital'),
('0009',STR_TO_DATE('5/1/2020','%m/%d/%Y'),'Children\'s Healthcare of Atlanta'),
('0010',STR_TO_DATE('5/1/2020','%m/%d/%Y'),'Northside Hospital'),
('0011',STR_TO_DATE('5/1/2020','%m/%d/%Y'),'Northside Hospital'),
('0012',STR_TO_DATE('5/25/2020','%m/%d/%Y'),'Emory Midtown'),
('0013',STR_TO_DATE('5/25/2020','%m/%d/%Y'),'Children\'s Healthcare of Atlanta'),
('0014',STR_TO_DATE('5/25/2020','%m/%d/%Y'),'Emory Midtown'),
('0015',STR_TO_DATE('5/25/2020','%m/%d/%Y'),'Emory Midtown'),
('0016',STR_TO_DATE('5/25/2020','%m/%d/%Y'),'Northside Hospital'),
('0017',STR_TO_DATE('6/3/2020','%m/%d/%Y'),'Grady Hospital'),
('0018',STR_TO_DATE('6/3/2020','%m/%d/%Y'),'Grady Hospital'),
('0019',STR_TO_DATE('6/3/2020','%m/%d/%Y'),'Grady Hospital'),
('0020',STR_TO_DATE('6/3/2020','%m/%d/%Y'),'Piedmont Hospital'),
('0021',STR_TO_DATE('6/4/2020','%m/%d/%Y'),'Piedmont Hospital');

insert into usage_log values (10000, 'fantastic', STR_TO_DATE('6/11/2020 16:30','%m/%d/%Y %H:%i')),
(10001, 'jekyll_not_hyde', STR_TO_DATE('6/11/2020 17:00','%m/%d/%Y %H:%i')),
(10002, 'young_doc',STR_TO_DATE('6/11/2020 17:03','%m/%d/%Y %H:%i')),
(10003, 'fantastic',STR_TO_DATE('6/12/2020 8:23','%m/%d/%Y %H:%i')),
(10004, 'hannah_hills',STR_TO_DATE('6/12/2020 8:42','%m/%d/%Y %H:%i')),
(10005, 'mcdreamy',STR_TO_DATE('6/12/2020 9:00','%m/%d/%Y %H:%i')),
(10006, 'fantastic',STR_TO_DATE('6/12/2020 9:43','%m/%d/%Y %H:%i')),
(10007, 'doctor1',STR_TO_DATE('6/12/2020 10:11','%m/%d/%Y %H:%i')),
(10008, 'Jones01',STR_TO_DATE('6/12/2020 10:12','%m/%d/%Y %H:%i')),
(10009, 'henryjk',STR_TO_DATE('6/12/2020 10:23','%m/%d/%Y %H:%i')),
(10010, 'bones',STR_TO_DATE('6/12/2020 10:32','%m/%d/%Y %H:%i')),
(10011, 'dr_dolittle',STR_TO_DATE('6/12/2020 11:00','%m/%d/%Y %H:%i')),
(10012, 'drake_remoray',STR_TO_DATE('6/12/2020 11:14','%m/%d/%Y %H:%i')),
(10013, 'allons_y',STR_TO_DATE('6/12/2020 12:11','%m/%d/%Y %H:%i')),
(10014, 'dr_mory',STR_TO_DATE('6/12/2020 13:23','%m/%d/%Y %H:%i')),
(10015, 'Jones01',STR_TO_DATE('6/12/2020 13:52','%m/%d/%Y %H:%i'));

insert into product values ('BKGLO','black','gloves'),
('BKGOG','black','goggles'),
('BKSTE','black','stethoscope'),
('BLGWN','blue','gown'),
('BLHOD','blue','hood'),
('BLMSK','blue','mask'),
('BLSHC','blue','shoe cover'),
('CLSHD','clear','shield'),
('GRGLO','green','gloves'),
('GRGOG','green','goggles'),
('GRGWN','green','gown'),
('GRHOD','green','hood'),
('GRMSK','green','mask'),
('GRSHC','green','shoe cover'),
('GYGWN','grey','gown'),
('GYHOD','grey','hood'),
('GYSHC','grey','shoe cover'),
('ORGOG','orange','goggles'),
('ORRES','orange','repirator'),
('RDMSK','red','mask'),
('SISTE','silver','stethoscope'),
('WHGLO','white','gloves'),
('WHGOG','white','goggles'),
('WHGWN','white','gown'),
('WHHOD','white','hood'),
('WHMSK','white','mask'),
('WHRES','white','respirator'),
('WHSHC','white','shoe cover'),
('WHSTE','white','stethoscope'),
('YLRES','yellow','respirator');

insert into catalog_item values 
('Buy Personal Protective Equipment, Inc','BLGWN', 3.15),
('Buy Personal Protective Equipment, Inc','BLHOD', 2.10),
('Buy Personal Protective Equipment, Inc','BLSHC', 0.9),
('Buy Personal Protective Equipment, Inc','GRGWN', 3.15),
('Buy Personal Protective Equipment, Inc','GRHOD', 2.10),
('Buy Personal Protective Equipment, Inc','GRSHC', 0.9),
('Buy Personal Protective Equipment, Inc','GYGWN', 3.15),
('Buy Personal Protective Equipment, Inc','GYHOD', 2.10),
('Buy Personal Protective Equipment, Inc','GYSHC', 0.9),
('Buy Personal Protective Equipment, Inc','WHGWN', 3.15),
('Buy Personal Protective Equipment, Inc','WHHOD', 2.1),
('Buy Personal Protective Equipment, Inc','WHSHC', 0.9),
('Georgia Tech Protection Lab','BKGOG', 3.20),
('Georgia Tech Protection Lab','CLSHD', 5.95),
('Georgia Tech Protection Lab','GYGWN', 3.25),
('Georgia Tech Protection Lab','GYHOD', 1.80),
('Georgia Tech Protection Lab','GYSHC', 0.75),
('Georgia Tech Protection Lab','ORGOG', 3.20),
('Georgia Tech Protection Lab','WHGOG', 3.20),
('Healthcare Supplies of Atlanta','BLGWN', 3.00),
('Healthcare Supplies of Atlanta','BLHOD', 2.00),
('Healthcare Supplies of Atlanta','BLMSK', 1.05),
('Healthcare Supplies of Atlanta','BLSHC', 1.00),
('Healthcare Supplies of Atlanta','CLSHD', 6.05),
('Healthcare Supplies of Atlanta','ORGOG', 3.00),
('Healthcare Supplies of Atlanta','RDMSK', 1.45),
('Healthcare Supplies of Atlanta','WHMSK', 1.10),
('Healthcare Supplies of Atlanta','YLRES', 5.50),
('Marietta Mask Production Company','GRGOG', 3.25),
('Marietta Mask Production Company','GRGWN', 2.95),
('Marietta Mask Production Company','GRHOD', 1.65),
('Marietta Mask Production Company','GRMSK', 1.25),
('Marietta Mask Production Company','GRSHC', 0.80),
('PPE Empire','BLMSK', 1.35),
('PPE Empire','GRMSK', 1.45),
('PPE Empire','ORRES', 4.50),
('PPE Empire','RDMSK', 1.30),
('PPE Empire','WHMSK', 1.25),
('PPE Empire','WHRES', 4.80),
('PPE Empire','YLRES', 5.10),
('S&J Corporation','BKGLO', 0.30),
('S&J Corporation','BKSTE', 5.20),
('S&J Corporation','GRGLO', 0.30),
('S&J Corporation','SISTE', 5.10),
('S&J Corporation','WHGLO', 0.30),
('S&J Corporation','WHSTE', 5.00);

insert into inventory values
('Children\'s Healthcare of Atlanta','Storage St','Atlanta','Georgia','30309'),
('Piedmont Hospital','Warehouse Way','Atlanta','Georgia','30332'),
('Northside Hospital','Depot Dr','Dunwoody','Georgia','30338'),
('Emory Midtown','Inventory Ct','Atlanta','Georgia','30308'),
('Grady Hospital','Storehouse Pkwy','Atlanta','Georgia','30313'),
('PPE Empire','Cache Ct','Lawrenceville','Georgia','30043'),
('Buy Personal Protective Equipment, Inc','Stockpile St','Decatur','Georgia','30030'),
('Healthcare Supplies of Atlanta','Depository Dr','Atlanta','Georgia','30303'),
('Georgia Tech Protection Lab','Storehouse St','Atlanta','Georgia','30332'),
('Marietta Mask Production Company','Repository Way','Marietta','Georgia','30008'),
('S&J Corporation','Stash St','Suwanee','Georgia','30024');

INSERT INTO has VALUES ('Children\'s Healthcare of Atlanta', 'WHMSK', 5), ('Children\'s Healthcare of Atlanta', 'BLMSK', 220), ('Children\'s Healthcare of Atlanta', 'WHRES', 280), 
('Children\'s Healthcare of Atlanta', 'CLSHD', 100), ('Children\'s Healthcare of Atlanta', 'GRGOG', 780), ('Children\'s Healthcare of Atlanta', 'ORGOG', 100), 
('Children\'s Healthcare of Atlanta', 'BLSHC', 460), ('Children\'s Healthcare of Atlanta', 'BLHOD', 100), ('Children\'s Healthcare of Atlanta', 'BLGWN', 80), 
('Children\'s Healthcare of Atlanta', 'GRSHC', 5), ('Children\'s Healthcare of Atlanta', 'WHSTE', 330), ('Children\'s Healthcare of Atlanta', 'BKGLO', 410), 
('Piedmont Hospital', 'BLSHC', 3000), ('Piedmont Hospital', 'BLHOD', 3000), ('Piedmont Hospital', 'BLGWN', 420), ('Piedmont Hospital', 'GRSHC', 740), 
('Piedmont Hospital', 'GRHOD', 560), ('Piedmont Hospital', 'GRGWN', 840), ('Piedmont Hospital', 'SISTE', 460), ('Piedmont Hospital', 'BKGLO', 4210), 
('Northside Hospital', 'WHRES', 110), ('Northside Hospital', 'YLRES', 170), ('Northside Hospital', 'ORRES', 350), ('Northside Hospital', 'CLSHD', 410), 
('Northside Hospital', 'GRGOG', 1), ('Northside Hospital', 'ORGOG', 100), ('Emory Midtown', 'WHMSK', 80), ('Emory Midtown', 'BLMSK', 210), 
('Emory Midtown', 'RDMSK', 320), ('Emory Midtown', 'GRMSK', 40), ('Emory Midtown', 'WHRES', 760), ('Emory Midtown', 'YLRES', 140), 
('Emory Midtown', 'ORRES', 20), ('Emory Midtown', 'CLSHD', 50), ('Emory Midtown', 'GRGOG', 70), ('Emory Midtown', 'ORGOG', 320), 
('Emory Midtown', 'WHGOG', 140), ('Emory Midtown', 'BKGOG', 210), ('Emory Midtown', 'BLSHC', 630), ('Grady Hospital', 'BLHOD', 970), 
('Grady Hospital', 'BLGWN', 310), ('Grady Hospital', 'GRSHC', 340), ('Grady Hospital', 'GRHOD', 570), ('Grady Hospital', 'GRGWN', 10), 
('Grady Hospital', 'GYSHC', 20), ('Grady Hospital', 'GYHOD', 280), ('Grady Hospital', 'GYGWN', 240), ('Grady Hospital', 'WHSHC', 180), 
('Grady Hospital', 'WHHOD', 140), ('Grady Hospital', 'WHGWN', 150), ('Grady Hospital', 'BKSTE', 210), ('Grady Hospital', 'WHSTE', 170), 
('Grady Hospital', 'SISTE', 180), ('Grady Hospital', 'BKGLO', 70), ('Grady Hospital', 'WHGLO', 140), ('Grady Hospital', 'GRGLO', 80), 
('PPE Empire', 'WHMSK', 850), ('PPE Empire', 'BLMSK', 1320), ('PPE Empire', 'RDMSK', 540), ('PPE Empire', 'GRMSK', 870), ('PPE Empire', 'WHRES', 500), 
('PPE Empire', 'ORRES', 320), ('Buy Personal Protective Equipment, Inc', 'BLSHC', 900), ('Buy Personal Protective Equipment, Inc', 'BLGWN', 820), 
('Buy Personal Protective Equipment, Inc', 'GRSHC', 700), ('Buy Personal Protective Equipment, Inc', 'GRHOD', 770), ('Buy Personal Protective Equipment, Inc', 'GYSHC', 250), 
('Buy Personal Protective Equipment, Inc', 'GYHOD', 350), ('Buy Personal Protective Equipment, Inc', 'GYGWN', 850), ('Buy Personal Protective Equipment, Inc', 'WHSHC', 860), 
('Buy Personal Protective Equipment, Inc', 'WHHOD', 700), ('Buy Personal Protective Equipment, Inc', 'WHGWN', 500), ('Healthcare Supplies of Atlanta', 'ORGOG', 860), 
('Healthcare Supplies of Atlanta', 'RDMSK', 370), ('Healthcare Supplies of Atlanta', 'CLSHD', 990), ('Healthcare Supplies of Atlanta', 'BLSHC', 1370), 
('Healthcare Supplies of Atlanta', 'BLHOD', 210), ('Healthcare Supplies of Atlanta', 'BLGWN', 680), ('Healthcare Supplies of Atlanta', 'YLRES', 890), 
('Healthcare Supplies of Atlanta', 'WHMSK', 980), ('Healthcare Supplies of Atlanta', 'BLMSK', 5000), ('Georgia Tech Protection Lab', 'CLSHD', 620), 
('Georgia Tech Protection Lab', 'ORGOG', 970), ('Georgia Tech Protection Lab', 'WHGOG', 940), ('Georgia Tech Protection Lab', 'BKGOG', 840), 
('Georgia Tech Protection Lab', 'GYSHC', 610), ('Georgia Tech Protection Lab', 'GYHOD', 940), ('Georgia Tech Protection Lab', 'GYGWN', 700), ('Marietta Mask Production Company', 'GRSHC', 970), 
('Marietta Mask Production Company', 'GRHOD', 750), ('Marietta Mask Production Company', 'GRMSK', 750), ('Marietta Mask Production Company', 'GRGOG', 320), ('S&J Corporation', 'BKSTE', 200), 
('S&J Corporation', 'WHSTE', 860), ('S&J Corporation', 'WHGLO', 500), ('S&J Corporation', 'GRGLO', 420), ('S&J Corporation', 'BKGLO', 740);

insert into used values
('GRMSK','10000', 3),
('GRGOG','10000',3), 
('WHSTE','10000', 1),
('GRMSK','10001', 5), 
('BKSTE','10001', 1),
('WHMSK','10002', 4),
('CLSHD','10003', 2), 
('ORGOG','10003', 1), 
('GRMSK','10003', 2), 
('GRGOG','10003', 1), 
('BKSTE','10003', 1),
('ORGOG','10004', 2), 
('RDMSK','10004', 4), 
('CLSHD','10004', 2), 
('BLSHC','10004', 4),
('WHMSK','10005', 4), 
('BLMSK','10005', 4), 
('BLSHC','10005', 8),
('GRMSK','10006', 2),
('RDMSK','10007', 3), 
('CLSHD','10007', 3),
('BLMSK','10008', 5),
('GRSHC','10009', 4), 
('GRHOD','10009', 4), 
('WHMSK','10009', 4),
('RDMSK','10010', 3), 
('BLSHC','10010', 3),
('BLMSK','10011', 8),
('ORGOG','10012', 1), 
('WHGOG','10012', 1), 
('WHGLO','10012', 2),
('WHHOD','10013', 2),
('WHGOG','10014', 2), 
('WHGWN','10014', 2),
('BLMSK','10015', 4);

insert into cat_contains values
('0001','WHMSK',500),
('0001','BLMSK',500),
('0002','BLSHC',300),
('0003','BLMSK',500),
('0004','ORGOG',150),
('0004','RDMSK',150),
('0004','CLSHD',200),
('0004','BLSHC',100),
('0005','WHMSK',300),
('0006','BLSHC',400),
('0007','GRMSK',100),
('0007','GRGOG',300),
('0008','ORGOG',200),
('0008','WHGOG',200),
('0009','GRSHC',500),
('0009','GRHOD',500),
('0010','WHGLO',500),
('0011','WHHOD',200),
('0011','WHGWN',200),
('0012','BLSHC',50),
('0013','BLHOD',100),
('0013','BLGWN',100),
('0014','WHRES',300),
('0014','YLRES',200),
('0014','ORRES',300),
('0015','GYGWN',50),
('0016','CLSHD',20),
('0016','ORGOG',300),
('0016','BLHOD',100),
('0017','RDMSK',200),
('0017','CLSHD',180),
('0018','WHHOD',500),
('0019','GYGWN',300),
('0020','BKSTE',50),
('0020','WHSTE',50),
('0021','CLSHD',100),
('0021','ORGOG',200);

