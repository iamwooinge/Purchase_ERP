-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema purchasing_manage
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema purchasing_manage
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `purchasing_manage` DEFAULT CHARACTER SET utf8 ;
USE `purchasing_manage` ;

-- -----------------------------------------------------
-- Table `purchasing_manage`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`employee` (
  `employee_no` VARCHAR(45) NOT NULL COMMENT '�����ȣ',
  `employee_pw` VARCHAR(45) NOT NULL COMMENT '��й�ȣ',
  `employee_name` VARCHAR(45) NULL COMMENT '�����',
  `dept_code` VARCHAR(45) NULL COMMENT '����/��� �����μ�',
  `team_code1` VARCHAR(45) NULL COMMENT '���Ű�����\n��������',
  `team_code2` VARCHAR(45) NULL COMMENT '����\n�԰�\n��ǰ/��ȯ\n������',
  `rank_code` VARCHAR(45) NULL COMMENT '�����ڵ�',
  `rank_name` VARCHAR(45) NULL COMMENT '���޸�',
  PRIMARY KEY (`employee_no`))
ENGINE = InnoDB
COMMENT = '���';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`client` (
  `client_no` VARCHAR(45) NOT NULL COMMENT '�ŷ�ó��ȣ',
  `client_name` VARCHAR(45) NULL COMMENT '�ŷ�ó��',
  `client_manager` VARCHAR(45) NULL COMMENT '�ŷ�ó����ڸ�',
  `client_fax` VARCHAR(45) NULL COMMENT '�ѽ�',
  `client_zipcode` VARCHAR(45) NULL COMMENT '�����ȣ',
  `client_address` VARCHAR(45) NULL COMMENT '�ּ�',
  `client_tel` VARCHAR(45) NULL COMMENT '��ȭ��ȣ',
  `client_email` VARCHAR(45) NULL COMMENT 'EMAIL',
  `client_remark` VARCHAR(45) NULL COMMENT '���',
  PRIMARY KEY (`client_no`))
ENGINE = InnoDB
COMMENT = '�ŷ�ó';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`product` (
  `product_no` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `product_name` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `product_standard` INT NOT NULL COMMENT '�԰�',
  `product_unit` VARCHAR(45) NOT NULL COMMENT '����',
  `product_unitprice` INT NULL COMMENT '�ܰ�',
  PRIMARY KEY (`product_no`))
ENGINE = InnoDB
COMMENT = '��ǰ';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`claim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`claim` (
  `claim_no` VARCHAR(45) NOT NULL COMMENT '�ֹ���ȣ',
  `claim_date` DATE NULL COMMENT 'û������',
  `product_no` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `employee_no` VARCHAR(45) NULL COMMENT '�����',
  `product_amount` INT NULL COMMENT '����',
  `product_standard` INT NULL COMMENT '�԰�',
  `product_unit` VARCHAR(45) NULL COMMENT '����',
  `product_unitprice` INT NULL COMMENT '�ܰ�',
  `product_price` INT NULL COMMENT '�ݾ�',
  `claim_state` VARCHAR(45) NULL COMMENT '�������',
  PRIMARY KEY (`claim_no`),
  INDEX `product_no_idx` (`product_no` ASC) VISIBLE,
  INDEX `claim_employee_no_idx` (`employee_no` ASC) VISIBLE,
  CONSTRAINT `claim_product_no`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `claim_employee_no`
    FOREIGN KEY (`employee_no`)
    REFERENCES `purchasing_manage`.`employee` (`employee_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'û��';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`order` (
  `order_date` DATE NOT NULL COMMENT '�ֹ�����',
  `order_no` VARCHAR(45) NOT NULL COMMENT '�ֹ���ȣ',
  `employee_no` VARCHAR(45) NULL COMMENT '�����',
  `client_name` VARCHAR(45) NULL COMMENT '�ŷ�ó��',
  `product_no` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `product_standard` INT NULL COMMENT '�԰�',
  `product_unit` VARCHAR(45) NULL COMMENT '����',
  `order_amount` INT NULL COMMENT '���ּ���',
  `product_supply` INT NULL COMMENT '���ް���',
  `order_vat` INT NULL COMMENT '�ΰ���',
  `order_price` INT NULL COMMENT '�ݾ�',
  PRIMARY KEY (`order_no`),
  INDEX `product_no_idx` (`product_no` ASC) VISIBLE,
  INDEX `order_employee_no_idx` (`employee_no` ASC) VISIBLE,
  CONSTRAINT `o_product_no`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_claim_no`
    FOREIGN KEY (`order_no`)
    REFERENCES `purchasing_manage`.`claim` (`claim_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_employee_no`
    FOREIGN KEY (`employee_no`)
    REFERENCES `purchasing_manage`.`employee` (`employee_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '�ֹ�';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`income`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`income` (
  `income_no` VARCHAR(45) NOT NULL COMMENT '�ֹ���ȣ',
  `income_return_no` VARCHAR(45) NULL COMMENT '��ǰ/��ȯ��ȣ',
  `employee_no` VARCHAR(45) NULL COMMENT '�����',
  `client_name` VARCHAR(45) NULL COMMENT '�ŷ�ó��',
  `product_no` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `product_standard` INT NULL COMMENT '�԰�',
  `product_unit` VARCHAR(45) NULL COMMENT '����',
  `order_date` DATE NULL COMMENT '�ֹ�����',
  `product_count` INT NULL COMMENT '�ֹ�����',
  `income_date` DATE NULL COMMENT '�԰�����',
  `income_count` INT NULL COMMENT '�԰����',
  `income_state` VARCHAR(45) NULL COMMENT '�԰����',
  `income_category` VARCHAR(45) NULL COMMENT '�԰�����',
  PRIMARY KEY (`income_no`),
  INDEX `o_pro_num_idx` (`product_no` ASC) VISIBLE,
  INDEX `income_employee_no_idx` (`employee_no` ASC) VISIBLE,
  CONSTRAINT `o_pro_num`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `income_claim_no`
    FOREIGN KEY (`income_no`)
    REFERENCES `purchasing_manage`.`claim` (`claim_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `income_employee_no`
    FOREIGN KEY (`employee_no`)
    REFERENCES `purchasing_manage`.`employee` (`employee_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '�԰�';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`return_exchange`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`return_exchange` (
  `return_exchange_date` DATE NULL COMMENT '��ǰ��ȯ����',
  `order_no` VARCHAR(45) NOT NULL COMMENT '�ֹ���ȣ',
  `order_date` DATE NULL COMMENT '�ֹ�����',
  `product_no` VARCHAR(45) NULL COMMENT 'ǰ��',
  `client_name` VARCHAR(45) NULL COMMENT '�ŷ�ó',
  `product_amount` INT NULL COMMENT '�ֹ�����',
  `return_exchange_amount` INT NULL COMMENT '��ǰ��ȯ����',
  `return_exchange_type` VARCHAR(45) NULL COMMENT '��ǰ����',
  `product_price` INT NULL COMMENT '�ѱݾ�',
  INDEX `product_no_idx` (`product_no` ASC) VISIBLE,
  PRIMARY KEY (`order_no`),
  CONSTRAINT `re_order_no`
    FOREIGN KEY (`order_no`)
    REFERENCES `purchasing_manage`.`claim` (`claim_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `re_product_no`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '��ǰ/��ȯ';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`stock` (
  `product_no` VARCHAR(45) NOT NULL COMMENT 'ǰ��',
  `product_name` VARCHAR(45) NULL COMMENT 'ǰ��',
  `product_standard` INT NULL COMMENT '�԰�',
  `product_unit` VARCHAR(45) NULL COMMENT '����',
  `product_amount` INT NULL COMMENT '����',
  `product_type` VARCHAR(45) NULL COMMENT '����(��ǰ,��ȯ,�ֹ�)',
  `stock_date` DATE NULL COMMENT '����',
  PRIMARY KEY (`product_no`),
  CONSTRAINT `stock_product_no`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '���';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`mrp_cabbage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`mrp_cabbage` (
  `mrp_name` VARCHAR(45) NOT NULL,
  `cabbage` INT NULL,
  `salt` INT NULL,
  `garlic` INT NULL,
  `pear` INT NULL,
  `apple` INT NULL,
  `peppper_powder` INT NULL,
  `salted_seafood` INT NULL,
  `fish_sauce` INT NULL,
  `icebox` INT NULL,
  `vinly` INT NULL,
  `boxtape` INT NULL,
  PRIMARY KEY (`mrp_name`))
ENGINE = InnoDB
COMMENT = '���߱�ġ MRP';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`mrp_radish`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`mrp_radish` (
  `mrp_name` VARCHAR(45) NOT NULL,
  `radish` INT NULL,
  `salt` INT NULL,
  `garlic` INT NULL,
  `pear` INT NULL,
  `apple` INT NULL,
  `peppper_powder` INT NULL,
  `salted_seafood` INT NULL,
  `fish_sauce` INT NULL,
  `icebox` INT NULL,
  `vinly` INT NULL,
  `boxtape` INT NULL,
  PRIMARY KEY (`mrp_name`))
ENGINE = InnoDB
COMMENT = '��α� MRP';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* ��α� MRP ���̺� */
INSERT INTO `mrp_radish` (`mrp_name`,`radish`,`salt`,`garlic`,`pear`,`apple`,`peppper_powder`,`salted_seafood`,`fish_sauce`,`icebox`,`vinly`,`boxtape`) VALUES ('��α� 10kg',7,500,350,1,1,600,300,200,1,2,1);

/* ���߱�ġ MRP ���̺� */
INSERT INTO `mrp_cabbage` (`mrp_name`,`cabbage`,`salt`,`garlic`,`pear`,`apple`,`peppper_powder`,`salted_seafood`,`fish_sauce`,`icebox`,`vinly`,`boxtape`) VALUES ('���߱�ġ 10kg',7,500,350,1,1,600,300,200,1,2,1);

/* ��� ���̺� */
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('A00a01','0','�ֺ���','A','0','0','a','������');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB0b01','1','������','A','B','0','b','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1c01','2','������','A','B','1','c','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1d01','3','�輱ȣ','A','B','1','d','�븮');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1e01','4','���μ�','A','B','1','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1e02','5','������','A','B','1','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2c01','11','�Ӽ���','A','B','2','c','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2d01','22','������','A','B','2','d','�븮');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2e01','33','������','A','B','2','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2e02','44','�̿���','A','B','2','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3c01','55','������','A','B','3','c','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3d01','111','����ȣ','A','B','3','d','�븮');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3e01','222','ä��ȭ','A','B','3','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3e02','333','������','A','B','3','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC0b01','444','������','A','C','0','b','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1c01','555','�̿���','A','C','1','c','����');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1d01','1111','���̵�','A','C','1','d','�븮');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1d02','2222','���ؿ�','A','C','1','d','�븮');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e01','3333','����','A','C','1','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e02','4444','��ܿ�','A','C','1','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e03','5555','������','A','C','1','e','���');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e04','6666','�缮��','A','C','1','e','���');

/* ��ǰ ���̺� */
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('CB','���� ����',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('RD','���� �޹�',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('AP','û�� �� ���',5,'BOX(��)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('SA','�ž� õ�Ͽ�',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('RP','�� ���尡��',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('PE','���� ��',5,'BOX(��)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('GA','�Ǽ� �޸���',1,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('SF','����',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('FS','����',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('IB','���̽��ڽ�',15,'����(��)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('VI','���',50,'BOX(��)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('BT','�ڽ�������',30,'BOX(��)',NULL);

/* û�� ���̺� */
INSERT INTO `claim` (`claim_no`,`claim_date`,`product_no`,`employee_no`,`product_amount`,`product_standard`,`product_unit`,`product_unitprice`,`product_price`,`claim_state`) VALUES ('210824-CB01','2021-08-24','CB','AB2d01',5,10,'BOX',200,10000,'����');

INSERT INTO `claim` (`claim_no`,`claim_date`,`product_no`,`employee_no`,`product_amount`,`product_standard`,`product_unit`,`product_unitprice`,`product_price`,`claim_state`) VALUES ('210830-RP01','2021-08-30','RP','AB2e01',5,10,'BOX',200,10000,'����');
