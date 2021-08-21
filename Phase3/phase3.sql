/*
CS4400: Introduction to Database Systems
Summer 2020
Phase III Template

Team ##
Conner Bluck (cbluck3)
Anneliese Conrad (aconrad9)
Neal Austensen (naustensen3)
Danny Johnsen (djohnsen3)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

/************** UTIL **************/
/* Feel free to add any utilty procedures you may need here */

-- Number:
-- Author: kachtani3@
-- Name: create_zero_inventory
-- Tested By: kachtani3@
DROP PROCEDURE IF EXISTS create_zero_inventory;
DELIMITER //
CREATE PROCEDURE create_zero_inventory(
    IN i_businessName VARCHAR(100),
    IN i_productId CHAR(5)
)
BEGIN
-- Type solution below
    IF (i_productId NOT IN (
        SELECT product_id FROM InventoryHasProduct WHERE inventory_business = i_businessName))
    THEN INSERT INTO InventoryHasProduct (inventory_business, product_id, count)
        VALUES (i_businessName, i_productId, 0);
    END IF;

-- End of solution
END //
DELIMITER ;


/************** INSERTS **************/

-- Number: I1
-- Author: kachtani3@
-- Name: add_usage_log
DROP PROCEDURE IF EXISTS add_usage_log;
DELIMITER //
CREATE PROCEDURE add_usage_log(
    IN i_usage_log_id CHAR(5),
    IN i_doctor_username VARCHAR(100),
    IN i_timestamp TIMESTAMP
)
BEGIN
-- Type solution below
    INSERT INTO usagelog VALUES (i_usage_log_id, i_doctor_username, i_timestamp);
-- End of solution
END //
DELIMITER ;

-- Number: I2
-- Author: ty.zhang@
-- Name: add_usage_log_entry
DROP PROCEDURE IF EXISTS add_usage_log_entry;
DELIMITER //
CREATE PROCEDURE add_usage_log_entry(
    IN i_usage_log_id CHAR(5),
    IN i_product_id CHAR(5),
    IN i_count INT
)
sp_main: BEGIN
-- Type solution below
    IF (SELECT count FROM inventoryhasproduct WHERE product_id = i_product_id and inventoryhasproduct.inventory_business = 
    (select doctor.hospital from usagelogentry join usagelog on usagelogentry.usage_log_id = usagelog.id 
    join doctor on doctor.username = usagelog.doctor where usagelogentry.usage_log_id = i_usage_log_id group by hospital)) 
    <= i_count
    then leave sp_main; end if;
    
    IF i_usage_log_id not in (select usage_log_id from usagelogentry)
    then leave sp_main; end if;
    
    IF i_product_id not in (select product_id from inventoryhasproduct where inventory_business = (select doctor.hospital from usagelogentry join usagelog on usagelogentry.usage_log_id = usagelog.id 
    join doctor on doctor.username = usagelog.doctor where usagelogentry.usage_log_id = i_usage_log_id group by hospital))
    then leave sp_main; end if;

    INSERT INTO usagelogentry VALUES (i_usage_log_id, i_product_id, i_count);
    UPDATE inventoryhasproduct SET count = (count - i_count) where product_id = i_product_id and inventory_business = (select doctor.hospital from usagelogentry join usagelog on usagelogentry.usage_log_id = usagelog.id 
    join doctor on doctor.username = usagelog.doctor where usagelogentry.usage_log_id = i_usage_log_id group by hospital);
-- End of solution
END //
DELIMITER ;

-- Number: I3
-- Author: yxie@
-- Name: add_business
DROP PROCEDURE IF EXISTS add_business;
DELIMITER //
CREATE PROCEDURE add_business(
    IN i_name VARCHAR(100),
    IN i_BusinessStreet VARCHAR(100),
    IN i_BusinessCity VARCHAR(100),
    IN i_BusinessState VARCHAR(30),
    IN i_BusinessZip CHAR(5),
    IN i_businessType ENUM('Hospital', 'Manufacturer'),
    IN i_maxDoctors INT,
    IN i_budget FLOAT(2),
    IN i_catalog_capacity INT,
    IN i_InventoryStreet VARCHAR(100),
    IN i_InventoryCity VARCHAR(100),
    IN i_InventoryState VARCHAR(30),
    IN i_InventoryZip CHAR(5)
)
BEGIN
-- Type solution below
    IF i_businessType = 'Hospital' then
    INSERT INTO business VALUES (i_name, i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip);
    INSERT INTO hospital VALUES (i_name, i_maxDoctors, i_budget);
    INSERT INTO Inventory VALUES (i_name, i_InventoryStreet, i_InventoryCity, i_InventoryState, i_InventoryZip);
    end if;
    
    IF i_businessType = 'Manufacturer' then
    INSERT INTO business VALUES (i_name, i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip);
    INSERT INTO manufacturer VALUES (i_name, i_catalog_capacity);
    INSERT INTO Inventory VALUES (i_name, i_InventoryStreet, i_InventoryCity, i_InventoryState, i_InventoryZip);
    end if;
-- End of solution
END //
DELIMITER ;

-- Number: I4
-- Author: kachtani3@
-- Name: add_transaction
DROP PROCEDURE IF EXISTS add_transaction;
DELIMITER //
CREATE PROCEDURE add_transaction(
    IN i_transaction_id CHAR(4),
    IN i_hospital VARCHAR(100),
    IN i_date DATE
)
BEGIN
-- Type solution below

INSERT INTO Transaction(id, hospital, date) VALUES (i_transaction_id, i_hospital, i_date);

-- End of solution
END //
DELIMITER ;

-- Number: I5
-- Author: kachtani3@
-- Name: add_transaction_item
DROP PROCEDURE IF EXISTS add_transaction_item;
DELIMITER //
CREATE PROCEDURE add_transaction_item(
    IN i_transactionId CHAR(4),
    IN i_productId CHAR(5),
    IN i_manufacturerName VARCHAR(100),
    IN i_purchaseCount INT)
sp_main: BEGIN
-- Type solution below
    if (select budget from hospital join transaction on hospital.name = transaction.hospital where id = i_transactionId) 
    < (select (price * i_purchaseCount) from catalogitem where product_id = i_productId and manufacturer = i_manufacturerName)
    then leave sp_main; end if;
    
    IF (select count from inventoryhasproduct where inventory_business = i_manufacturerName and product_id = i_productId)
    < i_purchaseCount
    then leave sp_main; end if;
    
    INSERT INTO transactionitem VALUES (i_transactionId, i_manufacturerName, i_productId, i_purchaseCount);
    
    UPDATE hospital SET hospital.budget = (hospital.budget - (select (price * i_purchaseCount) as total_price from catalogitem where product_id = i_productId and manufacturer = i_manufacturerName)) 
    where hospital.name = (select hospital from transaction where id = i_transactionId);
    
    UPDATE inventoryhasproduct SET count = (count - i_purchaseCount) 
    where product_id = i_productId and inventory_business = i_manufacturerName;
    
    UPDATE inventoryhasproduct SET count = (count + i_purchaseCount) 
    where product_id = i_productId and inventory_business = (select hospital from transaction where id = i_transactionId);
-- End of solution
END //
DELIMITER ;

-- Number: I6
-- Author: yxie@
-- Name: add_user
DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
CREATE PROCEDURE add_user(
    IN i_username VARCHAR(100),
    IN i_email VARCHAR(100),
    IN i_password VARCHAR(100),
    IN i_fname VARCHAR(50),
    IN i_lname VARCHAR(50),
    IN i_userType ENUM('Doctor', 'Admin', 'Doctor-Admin'),
    IN i_managingBusiness VARCHAR(100),
    IN i_workingHospital VARCHAR(100)
)
sp_main: BEGIN
-- Type solution below
	IF (i_userType = 'Doctor' or i_userType = 'Doctor-Admin')
    and (select count(*) from hospital join doctor on doctor.hospital = hospital.name where hospital.name = i_workingHospital group by hospital.name) 
    >= (select max_doctors from hospital where name = i_workingHospital)
    then leave sp_main; end if;
    
    IF i_workingHospital not in (select name from hospital)
    then leave sp_main; end if;
    
    IF i_managingBusiness not in (select name from business)
    then leave sp_main; end if;

	IF i_userType = 'Doctor' then
	INSERT INTO user VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
    INSERT INTO doctor VALUES (i_username, i_workingHospital, NULL);
    end if;
    
    IF i_userType = 'Admin' then
	INSERT INTO user VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
    INSERT INTO administrator VALUES (i_username, i_managingBusiness);
    end if;
    
    IF i_userType = 'Doctor-Admin' then
	INSERT INTO user VALUES (i_username, i_email, SHA(i_password), i_fname, i_lname);
    INSERT INTO doctor VALUES (i_username, i_workingHospital, NULL);
    INSERT INTO administrator VALUES (i_username, i_managingBusiness);
    end if;
-- End of solution
END //
DELIMITER ;

-- Number: I7
-- Author: klin83@
-- Name: add_catalog_item
DROP PROCEDURE IF EXISTS add_catalog_item;
DELIMITER //
CREATE PROCEDURE add_catalog_item(
    IN i_manufacturerName VARCHAR(100),
    IN i_product_id CHAR(5),
    IN i_price FLOAT(2)
)
sp_main: BEGIN
-- Type solution below
    if (select count(*) from catalogitem where manufacturer = i_manufacturerName) >= (select catalog_capacity from manufacturer where name = i_manufacturerName)
    then leave sp_main; end if;
    
    INSERT INTO catalogitem VALUES (i_manufacturerName, i_product_id, i_price);
-- End of solution
END //
DELIMITER ;

-- Number: I8
-- Author: ftsang3@
-- Name: add_product
DROP PROCEDURE IF EXISTS add_product;
DELIMITER //
CREATE PROCEDURE add_product(
    IN i_prod_id CHAR(5),
    IN i_color VARCHAR(30),
    IN i_name VARCHAR(30)
)
BEGIN
-- Type solution below
    INSERT INTO product VALUES (i_prod_id, i_color, i_name);
-- End of solution
END //
DELIMITER ;


/************** DELETES **************/
-- NOTE: Do not circumvent referential ON DELETE triggers by manually deleting parent rows

-- Number: D1
-- Author: ty.zhang@
-- Name: delete_product
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER //
CREATE PROCEDURE delete_product(
    IN i_product_id CHAR(5)
)
BEGIN
-- Type solution below
    DELETE FROM Product where id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: D2
-- Author: kachtani3@
-- Name: delete_zero_inventory
DROP PROCEDURE IF EXISTS delete_zero_inventory;
DELIMITER //
CREATE PROCEDURE delete_zero_inventory()
BEGIN
-- Type solution below
	DELETE FROM inventoryhasproduct where count = 0;
-- End of solution
END //
DELIMITER ;

-- Number: D3
-- Author: ftsang3@
-- Name: delete_business
DROP PROCEDURE IF EXISTS delete_business;
DELIMITER //
CREATE PROCEDURE delete_business(
    IN i_businessName VARCHAR(100)
)
BEGIN
-- Type solution below
    DELETE FROM Business where name = i_businessName;
-- End of solution
END //
DELIMITER ;

-- Number: D4
-- Author: ftsang3@
-- Name: delete_user
DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //
CREATE PROCEDURE delete_user(
    IN i_username VARCHAR(100)
)
BEGIN
-- Type solution below
    DELETE FROM User Where username = i_username;
-- End of solution
END //
DELIMITER ;

-- Number: D5
-- Author: klin83@
-- Name: delete_catalog_item
DROP PROCEDURE IF EXISTS delete_catalog_item;
DELIMITER //
CREATE PROCEDURE delete_catalog_item(
    IN i_manufacturer_name VARCHAR(100),
    IN i_product_id CHAR(5)
)
BEGIN
-- Type solution below
    DELETE FROM CatalogItem Where manufacturer = i_manufacturer_name and product_id = i_product_id;
-- End of solution
END //
DELIMITER ;


/************** UPDATES **************/

-- Number: U2
-- Author: kachtani3@
-- Name: move_inventory
DROP PROCEDURE IF EXISTS move_inventory;
DELIMITER //
CREATE PROCEDURE move_inventory(
    IN i_supplierName VARCHAR(100),
    IN i_consumerName VARCHAR(100),
    IN i_productId CHAR(5),
    IN i_count INT)
sp_main: BEGIN
-- Type solution below
	IF (select count from inventoryhasproduct where inventory_business = i_supplierName and product_id = i_productId) 
    < i_count
    then leave sp_main; end if;
    
    IF i_productId not in (select product_id from inventoryhasproduct where inventory_business = i_supplierName)
    then leave sp_main; end if;
    
    IF i_productId not in (select product_id from inventoryhasproduct where inventory_business = i_consumerName) then
    INSERT INTO inventoryhasproduct VALUES (i_consumerName, i_productId, i_count);
    UPDATE inventoryhasproduct SET count = (count - i_count) where product_id = i_productId and inventory_business = i_supplierName;
    ELSE
    UPDATE inventoryhasproduct SET count = (count - i_count) where product_id = i_productId and inventory_business = i_supplierName;
    UPDATE inventoryhasproduct SET count = (count + i_count) where product_id = i_productId and inventory_business = i_consumerName;
    end if;
    
     call delete_zero_inventory();
-- End of solution
END //
DELIMITER ;


-- Number: U3
-- Author: ty.zhang@
-- Name: rename_product_id
DROP PROCEDURE IF EXISTS rename_product_id;
DELIMITER //
CREATE PROCEDURE rename_product_id(
    IN i_product_id CHAR(5),
    IN i_new_product_id CHAR(5)
)
BEGIN
-- Type solution below
    UPDATE Product SET id = i_new_product_id where id = i_product_id;
END //
DELIMITER ;

-- Number: U4
-- Author: ty.zhang@
-- Name: update_business_address
DROP PROCEDURE IF EXISTS update_business_address;
DELIMITER //
CREATE PROCEDURE update_business_address(
    IN i_name VARCHAR(100),
    IN i_address_street VARCHAR(100),
    IN i_address_city VARCHAR(100),
    IN i_address_state VARCHAR(30),
    IN i_address_zip CHAR(5)
)
BEGIN
-- Type solution below
    UPDATE Business SET address_street = i_address_street, address_city = i_address_city, address_state = i_address_state, address_zip = i_address_zip Where i_name = name;
-- End of solution
END //
DELIMITER ;

-- Number: U5
-- Author: kachtani3@
-- Name: charge_hospital
DROP PROCEDURE IF EXISTS charge_hospital;
DELIMITER //
CREATE PROCEDURE charge_hospital(
    IN i_hospital_name VARCHAR(100),
    IN i_amount FLOAT(2)
)
BEGIN
-- Type solution below
UPDATE Hospital SET budget = (budget - i_amount) where (name = i_hospital_name and (budget >= i_amount)); 
-- End of solution
END //
DELIMITER ;

-- Number: U6
-- Author: yxie@
-- Name: update_business_admin
DROP PROCEDURE IF EXISTS update_business_admin;
DELIMITER //
CREATE PROCEDURE update_business_admin(
    IN i_admin_username VARCHAR(100),
    IN i_business_name VARCHAR(100)
)
BEGIN
-- Type solution below
if (select count(*) from administrator where business in (select business from administrator where username = i_admin_username)) > 1 and i_business_name in (select name from business) 
then update administrator set administrator.business = i_business_name where administrator.username = i_admin_username;
end if ; 
-- End of solution
END //
DELIMITER ;

-- Number: U7
-- Author: ftsang3@
-- Name: update_doctor_manager
DROP PROCEDURE IF EXISTS update_doctor_manager;
DELIMITER //
CREATE PROCEDURE update_doctor_manager(
    IN i_doctor_username VARCHAR(100),
    IN i_manager_username VARCHAR(100)
)
BEGIN
-- Type solution below
IF i_doctor_username <> i_manager_username
    THEN
        UPDATE Doctor SET manager = i_manager_username WHERE username = i_doctor_username;
    END IF;
-- End of solution
END //
DELIMITER ;

-- Number: U8
-- Author: ftsang3@
-- Name: update_user_password
DROP PROCEDURE IF EXISTS update_user_password;
DELIMITER //
CREATE PROCEDURE update_user_password(
    IN i_username VARCHAR(100),
    IN i_new_password VARCHAR(100)
)
BEGIN
-- Type solution below
    UPDATE User SET password = SHA(i_new_password) WHERE i_username = username;
-- End of solution
END //
DELIMITER ;

-- Number: U9
-- Author: klin83@
-- Name: batch_update_catalog_item
DROP PROCEDURE IF EXISTS batch_update_catalog_item;
DELIMITER //
CREATE PROCEDURE batch_update_catalog_item(
    IN i_manufacturer_name VARCHAR(100),
    IN i_factor FLOAT(2))
BEGIN
-- Type solution below
    UPDATE CatalogItem SET price = (price*i_factor) WHERE i_manufacturer_name = manufacturer;
-- End of solution
END //
DELIMITER ;

/************** SELECTS **************/
-- NOTE: "SELECT * FROM USER" is just a dummy query
-- to get the script to run. You will need to replace that line
-- with your solution.

-- Number: S2
-- Author: ty.zhang@
-- Name: num_of_admin_list
DROP PROCEDURE IF EXISTS num_of_admin_list;
DELIMITER //
CREATE PROCEDURE num_of_admin_list()
BEGIN
    DROP TABLE IF EXISTS num_of_admin_list_result;
    CREATE TABLE num_of_admin_list_result(
        businessName VARCHAR(100),
        businessType VARCHAR(100),
        numOfAdmin INT);

    INSERT INTO num_of_admin_list_result
-- Type solution below
    SELECT H.name, 'Hospital', count(*)
    FROM Hospital AS H, Administrator AS A
    WHERE name = business
    GROUP BY H.name
    UNION
    SELECT M.name, 'Manufacturer', count(*)
    FROM Manufacturer AS M, Administrator AS A
    WHERE name = business
    GROUP BY M.name;
-- End of solution
END //
DELIMITER ;

-- Number: S3
-- Author: ty.zhang@
-- Name: product_usage_list
DROP PROCEDURE IF EXISTS product_usage_list;
DELIMITER //
CREATE PROCEDURE product_usage_list()

BEGIN
    DROP TABLE IF EXISTS product_usage_list_result;
    CREATE TABLE product_usage_list_result(
        product_id CHAR(5),
        product_color VARCHAR(30),
        product_type VARCHAR(30),
        num INT);

    INSERT INTO product_usage_list_result
-- Type solution below
    SELECT product.id,product.name_color,product.name_type, sum(IFNULL(count,0)) FROM product
    left outer join usagelogentry on product.id = usagelogentry.product_id
    group by product.id
    order by sum(count) DESC;
-- End of solution
END //
DELIMITER ;

-- Number: S4
-- Author: ty.zhang@
-- Name: hospital_total_expenditure
DROP PROCEDURE IF EXISTS hospital_total_expenditure;
DELIMITER //
CREATE PROCEDURE hospital_total_expenditure()

BEGIN
    DROP TABLE IF EXISTS hospital_total_expenditure_result;
    CREATE TABLE hospital_total_expenditure_result(
        hospitalName VARCHAR(100),
        totalExpenditure FLOAT,
        transaction_count INT,
        avg_cost FLOAT);

    INSERT INTO hospital_total_expenditure_result
-- Type solution below
    select hospital.name, ifnull(round(sum(transTotal),2),0) as 'Total Expenditures', ifnull(count(id),0) as 'Number of Transactions', ifnull(round(sum(transTotal)/count(id),2),0) as 'Avg per Transaction' from
        (select id,hospital,sum(total) as 'transTotal' from transaction
          join
            (SELECT transaction_id, transactionitem.manufacturer, transactionitem.product_id,count, count * price as 'total' FROM ga_ppe.transactionitem
            join catalogitem on catalogitem.manufacturer = transactionitem.manufacturer and catalogitem.product_id = transactionitem.product_id) as tab
        on transaction.id = tab.transaction_id
        group by transaction.id) as tab2
        right outer join hospital on hospital.name = hospital
        group by hospital.name;
-- End of solution
END //
DELIMITER ;

-- Number: S5
-- Author: kachtani3@
-- Name: manufacturer_catalog_report
DROP PROCEDURE IF EXISTS manufacturer_catalog_report;
DELIMITER //
CREATE PROCEDURE manufacturer_catalog_report(
    IN i_manufacturer VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS manufacturer_catalog_report_result;
    CREATE TABLE manufacturer_catalog_report_result(
        name_color VARCHAR(30),
        name_type VARCHAR(30),
        price FLOAT(2),
        num_sold INT,
        revenue FLOAT(2));

    INSERT INTO manufacturer_catalog_report_result
-- Type solution below
    SELECT product.name_color, product.name_type,price, ifnull(tab.num_sold,0), ifnull(round(tab.num_sold*price,2),0) as 'revenue' from catalogitem
    left outer join product on product.id = catalogitem.product_id
    left outer join
   (select product_id, sum(count) as 'num_sold' from transactionitem
            where manufacturer = i_manufacturer
            group by product_id) as tab
 on tab.product_id = catalogitem.product_id
    where manufacturer = i_manufacturer
    order by revenue DESC
    ;
-- End of solution
END //
DELIMITER ;

-- Number: S6
-- Author: kachtani3@
-- Name: doctor_subordinate_usage_log_report
DROP PROCEDURE IF EXISTS doctor_subordinate_usage_log_report;
DELIMITER //
CREATE PROCEDURE doctor_subordinate_usage_log_report(
    IN i_drUsername VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS doctor_subordinate_usage_log_report_result;
    CREATE TABLE doctor_subordinate_usage_log_report_result(
        id CHAR(5),
        doctor VARCHAR(100),
        timestamp TIMESTAMP,
        product_id CHAR(5),
        count INT);

    INSERT INTO doctor_subordinate_usage_log_report_result
-- Type solution below
    select usagelog.id, usagelog.doctor, usagelog.timestamp, usagelogentry.product_id, usagelogentry.count from usagelog
    join usagelogentry on usagelog.id = usagelogentry.usage_log_id
    where doctor in (select username FROM ga_ppe.doctor where username = i_drUsername or manager = i_drUsername);
-- End of solution
END //
DELIMITER ;

-- Number: S7
-- Author: klin83@
-- Name: explore_product
DROP PROCEDURE IF EXISTS explore_product;
DELIMITER //
CREATE PROCEDURE explore_product(
    IN i_product_id CHAR(5))
BEGIN
    DROP TABLE IF EXISTS explore_product_result;
    CREATE TABLE explore_product_result(
        manufacturer VARCHAR(100),
        count INT,
        price FLOAT(2));

    INSERT INTO explore_product_result
-- Type solution below
    SELECT manufacturer, count, price FROM catalogitem
    join inventoryhasproduct on catalogitem.manufacturer = inventoryhasproduct.inventory_business and catalogitem.product_id = inventoryhasproduct.product_id
    where catalogitem.product_id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: S8
-- Author: klin83@
-- Name: show_product_usage
DROP PROCEDURE IF EXISTS show_product_usage;
DELIMITER //
CREATE PROCEDURE show_product_usage()
BEGIN
    DROP TABLE IF EXISTS show_product_usage_result;
    CREATE TABLE show_product_usage_result(
        product_id CHAR(5),
        num_used INT,
        num_available INT,
        ratio FLOAT);

    INSERT INTO show_product_usage_result
-- Type solution below
select id, ifnull(tab.count,0), ifnull(tab2.count,0), ifnull(round(tab.count/tab2.count,2),0) from product
 left outer join
  (select product_id, sum(count) as 'count' from usagelogentry
  group by product_id) as tab
 on tab.product_id = id
    left outer join
  (select product_id, sum(count) as 'count' from inventoryhasproduct
  where inventory_business in (select name from manufacturer)
  group by product_id) as tab2
 on tab2.product_id = id;
-- End of solution
END //
DELIMITER ;

-- Number: S9
-- Author: klin83@
-- Name: show_hospital_aggregate_usage
DROP PROCEDURE IF EXISTS show_hospital_aggregate_usage;
DELIMITER //
CREATE PROCEDURE show_hospital_aggregate_usage()
BEGIN
    DROP TABLE IF EXISTS show_hospital_aggregate_usage_result;
    CREATE TABLE show_hospital_aggregate_usage_result(
        hospital VARCHAR(100),
        items_used INT);

    INSERT INTO show_hospital_aggregate_usage_result
-- Type solution below
	SELECT doctor.hospital, ifnull(sum(usagelogentry.count),0) FROM doctor
    left outer join usagelog on doctor.username = usagelog.doctor
    left outer join usagelogentry on usagelog.id = usagelogentry.usage_log_id
    group by doctor.hospital;
-- End of solution
END //
DELIMITER ;

-- Number: S11
-- Author: ftsang3@
-- Name: manufacturer_transaction_report
DROP PROCEDURE IF EXISTS manufacturer_transaction_report;
DELIMITER //
CREATE PROCEDURE manufacturer_transaction_report(
    IN i_manufacturer VARCHAR(100))

BEGIN
    DROP TABLE IF EXISTS manufacturer_transaction_report_result;
    CREATE TABLE manufacturer_transaction_report_result(
        id CHAR(4),
        hospital VARCHAR(100),
        `date` DATE,
        cost FLOAT(2),
        total_count INT);

    INSERT INTO manufacturer_transaction_report_result
-- Type solution below
    SELECT transaction.id, transaction.hospital, transaction.date, sum(catalogitem.price * transactionitem.count) as cost, sum(transactionitem.count) as total_count  
    FROM transaction join transactionitem on transaction.id = transactionitem.transaction_id 
    JOIN catalogitem on transactionitem.manufacturer = catalogitem.manufacturer and transactionitem.product_id = catalogitem.product_id
    where transactionitem.manufacturer = i_manufacturer
    group by transaction.id;
-- End of solution
END //
DELIMITER ;
