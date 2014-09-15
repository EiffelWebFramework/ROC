SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema cms
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cms` DEFAULT CHARACTER SET latin1 ;
USE `cms` ;

-- -----------------------------------------------------
-- Table `cms`.`nodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cms`.`nodes` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `publication_date` DATE NOT NULL,
  `creation_date` DATE NOT NULL,
  `modification_date` DATE NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `summary` TEXT NOT NULL,
  `content` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `cms`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cms`.`roles` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `role` (`role` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `cms`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cms`.`users` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `salt` VARCHAR(100) NOT NULL,
  `email` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `cms`.`users_nodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cms`.`users_nodes` (
  `users_id` INT(10) UNSIGNED NOT NULL,
  `nodes_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`users_id`, `nodes_id`),
  INDEX `fk_users_has_nodes_nodes1_idx` (`nodes_id` ASC),
  INDEX `fk_users_has_nodes_users_idx` (`users_id` ASC),
  CONSTRAINT `fk_users_has_nodes_nodes1`
    FOREIGN KEY (`nodes_id`)
    REFERENCES `cms`.`nodes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_nodes_users`
    FOREIGN KEY (`users_id`)
    REFERENCES `cms`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `cms`.`users_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cms`.`users_roles` (
  `users_id` INT(10) UNSIGNED NOT NULL,
  `roles_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`users_id`, `roles_id`),
  INDEX `fk_users_has_roles_roles1_idx` (`roles_id` ASC),
  INDEX `fk_users_has_roles_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_users_has_roles_roles1`
    FOREIGN KEY (`roles_id`)
    REFERENCES `cms`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_roles_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `cms`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
