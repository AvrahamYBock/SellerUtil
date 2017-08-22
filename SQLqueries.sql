CREATE DATABASE amazon;

DROP TABLE IF EXISTS `amazon`.`customTransactionReport`;
CREATE TABLE `amazon`.`custom_transaction_report`
( `date/time` DATETIME NOT NULL ,
`settlement_id` VARCHAR(11) NOT NULL ,
`type` VARCHAR(30) NOT NULL ,
`order_id` VARCHAR(20) NOT NULL ,
`sku` VARCHAR(45) NOT NULL ,
`description` VARCHAR(200) NOT NULL ,
`quantity` INT(200) NOT NULL ,
`marketplace` VARCHAR(50) NOT NULL ,
`fulfillment` VARCHAR(50) NOT NULL ,
`order_city` VARCHAR(50) NOT NULL ,
`order_state` VARCHAR(30) NOT NULL ,
`order_postal` VARCHAR(20) NOT NULL ,
`product_sales` DECIMAL(10,2) NOT NULL ,
`shipping_credits` DECIMAL(10,2) NOT NULL ,
`gift_wrap_credits` DECIMAL(10,2) NOT NULL ,
`promotional_rebates` DECIMAL(10,2) NOT NULL ,
`sales_tax_collected` DECIMAL(10,2) NOT NULL ,
`selling_fees` DECIMAL(10,2) NOT NULL ,
`fba_fees` DECIMAL(10,2) NOT NULL ,
`other_transaction_fees` DECIMAL(10,2) NOT NULL ,
`other` DECIMAL(10,2) NOT NULL ,
`total` DECIMAL(10,2) NOT NULL ) ENGINE = InnoDB;

LOAD DATA INFILE 'C:/xampp/htdocs/Amazon/Database/AmazonReports/paymentReport/2017Jan1-2017Jul31CustomTransaction.csv'
INTO TABLE custom_transaction_report
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 8 ROWS
(@datetime, settlement_id, type, order_id, sku, description, quantity, marketplace, fulfillment, order_city,	order_state, order_postal, product_sales, shipping_credits, gift_wrap_credits, promotional_rebates, sales_tax_collected, selling_fees, fba_fees, other_transaction_fees, other, total)
SET `date/time` = STR_TO_DATE(@datetime, '%M %d, %Y %h:%i:%s %p');

DROP TABLE IF EXISTS `amazon`.`sku_description`;
CREATE TABLE `amazon`.`sku_description`(
    `sku` VARCHAR(45) NOT NULL,
    `description` VARCHAR(200) NOT NULL,
    `from_date` DATETIME NOT NULL,
    `to_date` DATETIME NOT NULL,
    PRIMARY KEY (`sku`, `from_date`, `to_date`)
);

DROP TABLE IF EXISTS `amazon`.`cogs`;
CREATE TABLE `amazon`.`cogs`(
    `sku` VARCHAR(45) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    `from_date` DATETIME NOT NULL,
    `to_date` DATETIME NOT NULL,
    PRIMARY KEY (`sku`, `from_date`, `to_date`)
);

DROP TABLE IF EXISTS `amazon`.`skus_primary`;
CREATE TABLE `amazon`.`skus_primary`(
    `sku` VARCHAR(45) NOT NULL,
    asin VARCHAR(15) NOT NULL,
    fnsku VARCHAR(15) NOT NULL,
    PRIMARY KEY (`sku`)
);

INSERT INTO `skus_primary`(`sku`)
    SELECT DISTINCT sku
    FROM custom_transaction_report
    WHERE (sku <> "");

DROP TABLE IF EXISTS `amazon`.`cogs`;
CREATE TABLE `amazon`.`cogs`(
    `sku` VARCHAR(45) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    `from_date` DATETIME NOT NULL,
    `to_date` DATETIME NOT NULL,
    PRIMARY KEY (`sku`, `from_date`, `to_date`)
);

DROP TABLE IF EXISTS `amazon`.`sku_description`;
CREATE TABLE `amazon`.`sku_description`(
    `sku` VARCHAR(45) NOT NULL,
    `description` VARCHAR(200) NOT NULL,
    `from_date` DATETIME NOT NULL,
    `to_date` DATETIME NOT NULL
);

INSERT INTO `sku_description`(`sku`)
SELECT DISTINCT (sku) FROM custom_transaction_report;

INSERT INTO `sku_description`(`description`)
VALUES(
    SELECT description FROM custom_transaction_report
    WHERE sku_description.sku = custom_transaction_report.sku
)

UPDATE `sku_description`
SET `description`= 
(
    SELECT description
    FROM custom_transaction_report ctr
    RIGHT JOIN `skus_primary` sp
    ON ctr.sku = sp.sku
    WHERE sku_description.sku = ctr.sku
)

SELECT DISTINCT `sku`, `description` FROM `custom_transaction_report` WHERE (sku <> "") AND (type = "Order" OR type = "Refund")
ORDER BY sku

INSERT INTO sku_description (sku, description)
SELECT DISTINCT `sku`, `description` FROM `custom_transaction_report` WHERE (sku <> "") AND (type = "Order" OR type = "Refund")
ORDER BY sku

SELECT sp.sku, cogs.price
FROM `skus_primary` sp
LEFT JOIN cogs
ON sp.sku = cogs.sku;