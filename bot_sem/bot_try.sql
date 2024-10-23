-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bot_sem
-- -----------------------------------------------------
-- Esquema ERR y base de datos para BOT de Whatsapp Seminario 
-- Creado por Bruno Celada, AA Región Rosario
-- 
DROP SCHEMA IF EXISTS `bot_sem` ;

-- -----------------------------------------------------
-- Schema bot_sem
--
-- Esquema ERR y base de datos para BOT de Whatsapp Seminario 
-- Creado por Bruno Celada, AA Región Rosario
-- 
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bot_sem` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `bot_sem` ;

-- -----------------------------------------------------
-- Table `bot_sem`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`user` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`user` (
  `ID_user` INT NOT NULL AUTO_INCREMENT COMMENT 'ID del usuario (primary_key)',
  `name_user` VARCHAR(45) NOT NULL COMMENT 'Nombre del usuario',
  `rol_user` ENUM("m", "s", "c") NOT NULL COMMENT 'Rol del usuario:\nm: maestro/a de la clase (también utilizado para líderes de barrio). Puede revisar la información de los alumnos del barrio, pero no de otros barrios ni estacas\ns: supervisor/a de una estaca (también para líderes de estaca). Puede revisar información de alumnos y clases de la estaca, pero no de otras estacas\nc: coordinador de una región (también para líderes de área/región). Puede revisar información total de una región, pero no de otras regiones.',
  `phone_user` VARCHAR(15) NOT NULL COMMENT 'Teléfono del usuario.\nUtilizado para la validación del bot del usuario.',
  `email_user` VARCHAR(75) NULL COMMENT 'Opcional.\nMail del usuario',
  `creation_date` DATE NOT NULL COMMENT 'Fecha de creación del usuario',
  PRIMARY KEY (`ID_user`),
  UNIQUE INDEX `iduser_UNIQUE` (`ID_user` ASC) VISIBLE,
  UNIQUE INDEX `phone_user_UNIQUE` (`phone_user` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bot_sem`.`estaca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`estaca` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`estaca` (
  `ID_estaca` INT NOT NULL AUTO_INCREMENT,
  `name_estaca` VARCHAR(45) NOT NULL COMMENT 'Nombre de la estaca',
  PRIMARY KEY (`ID_estaca`),
  UNIQUE INDEX `ID_estaca_UNIQUE` (`ID_estaca` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bot_sem`.`barrio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`barrio` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`barrio` (
  `ID_barrio` INT NOT NULL AUTO_INCREMENT COMMENT 'ID del barrio\nUnico',
  `name_barrio` VARCHAR(45) NOT NULL COMMENT 'Nombre del barrio (texto)',
  `estaca_ID_estaca` INT NOT NULL,
  PRIMARY KEY (`ID_barrio`),
  UNIQUE INDEX `ID_barrio_UNIQUE` (`ID_barrio` ASC) VISIBLE,
  INDEX `fk_barrio_estaca1_idx` (`estaca_ID_estaca` ASC) VISIBLE,
  CONSTRAINT `fk_barrio_estaca1`
    FOREIGN KEY (`estaca_ID_estaca`)
    REFERENCES `bot_sem`.`estaca` (`ID_estaca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bot_sem`.`alumno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`alumno` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`alumno` (
  `ID_alumno` INT NOT NULL AUTO_INCREMENT COMMENT 'ID del alumno (único)',
  `name_alumno` VARCHAR(45) NOT NULL,
  `asist_alumno` INT ZEROFILL NULL COMMENT 'Asistencia del alumno:\n% de asistencia (entero)',
  `eval_alumno` TINYINT NULL COMMENT 'Evaluación del alumno:\nyes/no',
  `lect_alumno` TINYINT NULL COMMENT 'Lectura del alumno:\nyes/no',
  `barrio_ID_barrio` INT NOT NULL,
  PRIMARY KEY (`ID_alumno`),
  UNIQUE INDEX `ID_alumno_UNIQUE` (`ID_alumno` ASC) VISIBLE,
  INDEX `fk_alumno_barrio_idx` (`barrio_ID_barrio` ASC) VISIBLE,
  CONSTRAINT `fk_alumno_barrio`
    FOREIGN KEY (`barrio_ID_barrio`)
    REFERENCES `bot_sem`.`barrio` (`ID_barrio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bot_sem`.`maestros`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`maestros` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`maestros` (
  `barrio_ID_barrio` INT NOT NULL,
  `user_ID_user` INT NOT NULL,
  PRIMARY KEY (`barrio_ID_barrio`, `user_ID_user`),
  INDEX `fk_barrio_has_user_user1_idx` (`user_ID_user` ASC) VISIBLE,
  INDEX `fk_barrio_has_user_barrio1_idx` (`barrio_ID_barrio` ASC) VISIBLE,
  CONSTRAINT `fk_barrio_has_user_barrio1`
    FOREIGN KEY (`barrio_ID_barrio`)
    REFERENCES `bot_sem`.`barrio` (`ID_barrio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_barrio_has_user_user1`
    FOREIGN KEY (`user_ID_user`)
    REFERENCES `bot_sem`.`user` (`ID_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bot_sem`.`supervisores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`supervisores` ;

CREATE TABLE IF NOT EXISTS `bot_sem`.`supervisores` (
  `estaca_ID_estaca` INT NOT NULL,
  `user_ID_user` INT NOT NULL,
  PRIMARY KEY (`estaca_ID_estaca`, `user_ID_user`),
  INDEX `fk_estaca_has_user_user1_idx` (`user_ID_user` ASC) VISIBLE,
  INDEX `fk_estaca_has_user_estaca1_idx` (`estaca_ID_estaca` ASC) VISIBLE,
  CONSTRAINT `fk_estaca_has_user_estaca1`
    FOREIGN KEY (`estaca_ID_estaca`)
    REFERENCES `bot_sem`.`estaca` (`ID_estaca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estaca_has_user_user1`
    FOREIGN KEY (`user_ID_user`)
    REFERENCES `bot_sem`.`user` (`ID_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `bot_sem` ;

-- -----------------------------------------------------
-- Placeholder table for view `bot_sem`.`vista_region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bot_sem`.`vista_region` (`name_estaca` INT, `name_barrio` INT);

-- -----------------------------------------------------
-- View `bot_sem`.`vista_region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bot_sem`.`vista_region`;
DROP VIEW IF EXISTS `bot_sem`.`vista_region` ;
USE `bot_sem`;
CREATE  OR REPLACE VIEW vista_region AS
SELECT e.name_estaca, b.name_barrio
FROM estaca e
JOIN barrio b ON e.ID_estaca = b.estaca_ID_estaca
ORDER BY e.name_estaca, b.name_barrio;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
