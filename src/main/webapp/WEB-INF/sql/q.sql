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
  `employee_no` VARCHAR(45) NOT NULL COMMENT '사원번호',
  `employee_pw` VARCHAR(45) NOT NULL COMMENT '비밀번호',
  `employee_name` VARCHAR(45) NULL COMMENT '사원명',
  `dept_code` VARCHAR(45) NULL COMMENT '구매/재고 관리부서',
  `team_code1` VARCHAR(45) NULL COMMENT '구매관리팀\n재고관리팀',
  `team_code2` VARCHAR(45) NULL COMMENT '발주\n입고\n반품/교환\n재고관리',
  `rank_code` VARCHAR(45) NULL COMMENT '직급코드',
  `rank_name` VARCHAR(45) NULL COMMENT '직급명',
  PRIMARY KEY (`employee_no`))
ENGINE = InnoDB
COMMENT = '사원';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`client` (
  `client_no` VARCHAR(45) NOT NULL COMMENT '거래처번호',
  `client_name` VARCHAR(45) NULL COMMENT '거래처명',
  `client_manager` VARCHAR(45) NULL COMMENT '거래처담당자명',
  `client_fax` VARCHAR(45) NULL COMMENT '팩스',
  `client_zipcode` VARCHAR(45) NULL COMMENT '우편번호',
  `client_address` VARCHAR(45) NULL COMMENT '주소',
  `client_tel` VARCHAR(45) NULL COMMENT '전화번호',
  `client_email` VARCHAR(45) NULL COMMENT 'EMAIL',
  `client_remark` VARCHAR(45) NULL COMMENT '비고',
  PRIMARY KEY (`client_no`))
ENGINE = InnoDB
COMMENT = '거래처';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`product` (
  `product_no` VARCHAR(45) NOT NULL COMMENT '품번',
  `product_name` VARCHAR(45) NOT NULL COMMENT '품명',
  `product_standard` INT NOT NULL COMMENT '규격',
  `product_unit` VARCHAR(45) NOT NULL COMMENT '단위',
  `product_unitprice` INT NULL COMMENT '단가',
  PRIMARY KEY (`product_no`))
ENGINE = InnoDB
COMMENT = '물품';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`claim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`claim` (
  `claim_no` VARCHAR(45) NOT NULL COMMENT '주문번호',
  `claim_date` DATE NULL COMMENT '청구일자',
  `product_no` VARCHAR(45) NOT NULL COMMENT '품번',
  `employee_no` VARCHAR(45) NULL COMMENT '담당자',
  `product_amount` INT NULL COMMENT '수량',
  `product_standard` INT NULL COMMENT '규격',
  `product_unit` VARCHAR(45) NULL COMMENT '단위',
  `product_unitprice` INT NULL COMMENT '단가',
  `product_price` INT NULL COMMENT '금액',
  `claim_state` VARCHAR(45) NULL COMMENT '진행상태',
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
COMMENT = '청구';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`order` (
  `order_date` DATE NOT NULL COMMENT '주문일자',
  `order_no` VARCHAR(45) NOT NULL COMMENT '주문번호',
  `employee_no` VARCHAR(45) NULL COMMENT '담당자',
  `client_name` VARCHAR(45) NULL COMMENT '거래처명',
  `product_no` VARCHAR(45) NOT NULL COMMENT '품번',
  `product_standard` INT NULL COMMENT '규격',
  `product_unit` VARCHAR(45) NULL COMMENT '단위',
  `order_amount` INT NULL COMMENT '발주수량',
  `product_supply` INT NULL COMMENT '공급가액',
  `order_vat` INT NULL COMMENT '부가세',
  `order_price` INT NULL COMMENT '금액',
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
COMMENT = '주문';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`income`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`income` (
  `income_no` VARCHAR(45) NOT NULL COMMENT '주문번호',
  `income_return_no` VARCHAR(45) NULL COMMENT '반품/교환번호',
  `employee_no` VARCHAR(45) NULL COMMENT '담당자',
  `client_name` VARCHAR(45) NULL COMMENT '거래처명',
  `product_no` VARCHAR(45) NOT NULL COMMENT '품번',
  `product_standard` INT NULL COMMENT '규격',
  `product_unit` VARCHAR(45) NULL COMMENT '단위',
  `order_date` DATE NULL COMMENT '주문일자',
  `product_count` INT NULL COMMENT '주문수량',
  `income_date` DATE NULL COMMENT '입고일자',
  `income_count` INT NULL COMMENT '입고수량',
  `income_state` VARCHAR(45) NULL COMMENT '입고상태',
  `income_category` VARCHAR(45) NULL COMMENT '입고유형',
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
COMMENT = '입고';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`return_exchange`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`return_exchange` (
  `return_exchange_date` DATE NULL COMMENT '반품교환일자',
  `order_no` VARCHAR(45) NOT NULL COMMENT '주문번호',
  `order_date` DATE NULL COMMENT '주문일자',
  `product_no` VARCHAR(45) NULL COMMENT '품번',
  `client_name` VARCHAR(45) NULL COMMENT '거래처',
  `product_amount` INT NULL COMMENT '주문수량',
  `return_exchange_amount` INT NULL COMMENT '반품교환수량',
  `return_exchange_type` VARCHAR(45) NULL COMMENT '반품유형',
  `product_price` INT NULL COMMENT '총금액',
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
COMMENT = '반품/교환';


-- -----------------------------------------------------
-- Table `purchasing_manage`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchasing_manage`.`stock` (
  `product_no` VARCHAR(45) NOT NULL COMMENT '품번',
  `product_name` VARCHAR(45) NULL COMMENT '품명',
  `product_standard` INT NULL COMMENT '규격',
  `product_unit` VARCHAR(45) NULL COMMENT '단위',
  `product_amount` INT NULL COMMENT '수량',
  `product_type` VARCHAR(45) NULL COMMENT '유형(반품,교환,주문)',
  `stock_date` DATE NULL COMMENT '일자',
  PRIMARY KEY (`product_no`),
  CONSTRAINT `stock_product_no`
    FOREIGN KEY (`product_no`)
    REFERENCES `purchasing_manage`.`product` (`product_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '재고';


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
COMMENT = '배추김치 MRP';


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
COMMENT = '깍두기 MRP';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* 깍두기 MRP 테이블 */
INSERT INTO `mrp_radish` (`mrp_name`,`radish`,`salt`,`garlic`,`pear`,`apple`,`peppper_powder`,`salted_seafood`,`fish_sauce`,`icebox`,`vinly`,`boxtape`) VALUES ('깍두기 10kg',7,500,350,1,1,600,300,200,1,2,1);

/* 배추김치 MRP 테이블 */
INSERT INTO `mrp_cabbage` (`mrp_name`,`cabbage`,`salt`,`garlic`,`pear`,`apple`,`peppper_powder`,`salted_seafood`,`fish_sauce`,`icebox`,`vinly`,`boxtape`) VALUES ('배추김치 10kg',7,500,350,1,1,600,300,200,1,2,1);

/* 사원 테이블 */
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('A00a01','0','최보금','A','0','0','a','본부장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB0b01','1','박정우','A','B','0','b','팀장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1c01','2','이지예','A','B','1','c','과장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1d01','3','김선호','A','B','1','d','대리');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1e01','4','조인성','A','B','1','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB1e02','5','유연석','A','B','1','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2c01','11','임수린','A','B','2','c','과장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2d01','22','조정석','A','B','2','d','대리');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2e01','33','이익준','A','B','2','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB2e02','44','이우주','A','B','2','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3c01','55','김혜진','A','B','3','c','과장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3d01','111','정경호','A','B','3','d','대리');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3e01','222','채송화','A','B','3','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AB3e02','333','장윤복','A','B','3','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC0b01','444','김현정','A','C','0','b','팀장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1c01','555','이예닮','A','C','1','c','과장');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1d01','1111','전미도','A','C','1','d','대리');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1d02','2222','김준완','A','C','1','d','대리');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e01','3333','김대명','A','C','1','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e02','4444','장겨울','A','C','1','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e03','5555','안정원','A','C','1','e','사원');
INSERT INTO employee (`employee_no`,`employee_pw`,`employee_name`,`dept_code`,`team_code1`,`team_code2`,`rank_code`,`rank_name`) VALUES ('AC1e04','6666','양석형','A','C','1','e','사원');

/* 제품 테이블 */
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('CB','고랭지 배추',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('RD','제주 햇무',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('AP','청송 꿀 사과',5,'BOX(개)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('SA','신안 천일염',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('RP','햇 고춧가루',10,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('PE','나주 배',5,'BOX(개)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('GA','의성 햇마늘',1,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('SF','젓갈',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('FS','액젓',5,'BOX(kg)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('IB','아이스박스',15,'묶음(개)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('VI','비닐',50,'BOX(개)',NULL);
INSERT INTO product (`product_no`,`product_name`,`product_standard`,`product_unit`,`productct_unitprice`) VALUES ('BT','박스테이프',30,'BOX(개)',NULL);

/* 청구 테이블 */
INSERT INTO `claim` (`claim_no`,`claim_date`,`product_no`,`employee_no`,`product_amount`,`product_standard`,`product_unit`,`product_unitprice`,`product_price`,`claim_state`) VALUES ('210824-CB01','2021-08-24','CB','AB2d01',5,10,'BOX',200,10000,'접수');

INSERT INTO `claim` (`claim_no`,`claim_date`,`product_no`,`employee_no`,`product_amount`,`product_standard`,`product_unit`,`product_unitprice`,`product_price`,`claim_state`) VALUES ('210830-RP01','2021-08-30','RP','AB2e01',5,10,'BOX',200,10000,'접수');
