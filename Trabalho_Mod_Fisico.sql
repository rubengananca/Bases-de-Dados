-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Tipo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tipo` (
  `id_tipo` INT NOT NULL,
  `designacao` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id_tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Dono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Dono` (
  `id_dono` INT NOT NULL,
  `designacao` VARCHAR(400) NOT NULL,
  PRIMARY KEY (`id_dono`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Hospital` (
  `id_hospital` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `telemovel` VARCHAR(12) NOT NULL,
  `emergencia` VARCHAR(45) NOT NULL,
  `ehr` VARCHAR(45) NULL,
  `cod_postal` INT NOT NULL,
  `estado` VARCHAR(2) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `morada` VARCHAR(1000) NOT NULL,
  `id_tipo` INT NOT NULL,
  `id_dono` INT NOT NULL,
  PRIMARY KEY (`id_hospital`),
  INDEX `tipo_fk1_idx` (`id_tipo` ASC) VISIBLE,
  INDEX `dono_fk2_idx` (`id_dono` ASC) VISIBLE,
  CONSTRAINT `tipo_fk1`
    FOREIGN KEY (`id_tipo`)
    REFERENCES `mydb`.`Tipo` (`id_tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `dono_fk2`
    FOREIGN KEY (`id_dono`)
    REFERENCES `mydb`.`Dono` (`id_dono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Classificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Classificacao` (
  `id_class` INT NOT NULL AUTO_INCREMENT,
  `id_hospital` INT NOT NULL,
  `rating` INT NOT NULL,
  `comentario` LONGTEXT NULL,
  `data_classificacao` DATE NOT NULL,
  PRIMARY KEY (`id_class`, `id_hospital`),
  INDEX `class_fk1_idx` (`id_hospital` ASC) VISIBLE,
  CONSTRAINT `class_fk1`
    FOREIGN KEY (`id_hospital`)
    REFERENCES `mydb`.`Hospital` (`id_hospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Comparacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Comparacao` (
  `id_comparacao` INT NOT NULL AUTO_INCREMENT,
  `id_hospital` INT NOT NULL,
  `imag_medica` VARCHAR(30) NOT NULL,
  `tempo_espera` VARCHAR(30) NOT NULL,
  `cuidados` VARCHAR(30) NOT NULL,
  `exp_pacientes` VARCHAR(30) NOT NULL,
  `read_nacional` VARCHAR(30) NOT NULL,
  `seguranca_nac` VARCHAR(30) NOT NULL,
  `mortalidade_nac` VARCHAR(30) NOT NULL,
  `data_comparacao` DATE NOT NULL,
  PRIMARY KEY (`id_comparacao`, `id_hospital`),
  INDEX `comp_fk1_idx` (`id_hospital` ASC) VISIBLE,
  CONSTRAINT `comp_fk1`
    FOREIGN KEY (`id_hospital`)
    REFERENCES `mydb`.`Hospital` (`id_hospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
