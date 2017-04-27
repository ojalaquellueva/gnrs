CREATE TABLE `countyParishStaging` (
  `countyParishID` INTEGER(11) UNSIGNED NOT NULL,
  `stateProvinceID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `stateProvinceUniqueCode` VARCHAR(100) DEFAULT NULL,
  `countyParishNameStd` VARCHAR(100) DEFAULT NULL,
  `countyParishUniqueCode` VARCHAR(150) DEFAULT NULL,
  `HASC_2` VARCHAR(8) DEFAULT NULL,
  `poldivTypeEng` VARCHAR(50) DEFAULT NULL,
  KEY `cps_countyParishID`(`countyParishID`),
  KEY `cps_stateProvinceID`(`stateProvinceID`),
  KEY `cps_countyParishNameStd`(`countyParishNameStd`),
  KEY `cps_countyParishUniqueCode`(`countyParishUniqueCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `countyParishNameStaging` (
  `countyParishNameID` INTEGER(11) UNSIGNED NOT NULL,
  `countyParishID` INTEGER(11) UNSIGNED NOT NULL,
  `countyParishName` VARCHAR(100) DEFAULT NULL,
  `langCode` VARCHAR(3) DEFAULT NULL,
  KEY `cpns_countyParishNameID`(`countyParishNameID`),
  KEY `cpns_countyParishID`(`countyParishID`),
  KEY `cpns_countyParishName`(`countyParishName`),
  KEY `cpns_langCode`(`langCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `countyParish` (
  `countyParishID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `stateProvinceID` INTEGER(11) UNSIGNED NOT NULL,
  `countyParishNameStd` VARCHAR(100) DEFAULT NULL,
  `countyParishUniqueCode` VARCHAR(150) DEFAULT NULL,
  `HASC_2` VARCHAR(8) DEFAULT NULL,
  `poldivTypeEng` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`countyParishID`),
  KEY `cp_stateProvinceID`(`stateProvinceID`),
  KEY `cp_countyParishNameStd`(`countyParishNameStd`),
  UNIQUE KEY `cp_countyParishUniqueCode`(`countyParishUniqueCode`),
  KEY `cp_HASC_2`(`HASC_2`),
  KEY `cp_poldivTypeEng`(`poldivTypeEng`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `countyParishName` (
  `countyParishNameID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `countyParishID` INTEGER(11) UNSIGNED NOT NULL,
  `countyParishName` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`countyParishNameID`),
  KEY `cpn_countyParishID`(`countyParishID`),
  KEY `cpn_countyParishName`(`countyParishName`),
  CONSTRAINT `FK_cpn_countyParishID` FOREIGN KEY `FK_cpn_countyParishID`(`countyParishID`) REFERENCES `countyParish`(`countyParishID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


