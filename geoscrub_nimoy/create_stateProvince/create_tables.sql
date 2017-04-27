CREATE TABLE `stateProvinceStaging` (
  `stateProvinceID` INTEGER(11) UNSIGNED NOT NULL,
  `countryIsoCode` VARCHAR(2) NOT NULL,
  `stateProvinceNameStd` VARCHAR(100) DEFAULT NULL,
  `stateProvinceCode` VARCHAR(3) DEFAULT NULL,
  `stateProvinceUniqueCode` VARCHAR(50) DEFAULT NULL,
  `HASC_1` VARCHAR(8) DEFAULT NULL,
  KEY `sps_stateProvinceID`(`stateProvinceID`),
  KEY `sps_countryIsoCode`(`countryIsoCode`),
  KEY `sps_stateProvinceNameStd`(`stateProvinceNameStd`),
  KEY `sps_stateProvinceCode`(`stateProvinceCode`),
  KEY `sps_stateProvinceUniqueCode`(`stateProvinceUniqueCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `stateProvinceNameStaging` (
  `stateProvinceNameID` INTEGER(11) UNSIGNED NOT NULL,
  `stateProvinceID` INTEGER(11) UNSIGNED NOT NULL,
  `stateProvinceName` VARCHAR(100) DEFAULT NULL,
  `langCode` VARCHAR(3) DEFAULT NULL,
  KEY `spns_stateProvinceNameID`(`stateProvinceNameID`),
  KEY `spns_stateProvinceID`(`stateProvinceID`),
  KEY `spns_stateProvinceName`(`stateProvinceName`),
  KEY `spns_langCode`(`langCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `stateProvince` (
  `stateProvinceID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `countryID` INTEGER(11) UNSIGNED NOT NULL,
  `stateProvinceNameStd` VARCHAR(100) DEFAULT NULL,
  `stateProvinceCode` VARCHAR(3) DEFAULT NULL,
  `HASC_1` VARCHAR(8) DEFAULT NULL,
  PRIMARY KEY (`stateProvinceID`),
  KEY `sp_countryID`(`countryID`),
  KEY `sp_stateProvinceNameStd`(`stateProvinceNameStd`),
  KEY `sp_stateProvinceCode`(`stateProvinceCode`),
  KEY `sp_HASC_1`(`HASC_1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `stateProvinceName` (
  `stateProvinceNameID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `stateProvinceID` INTEGER(11) UNSIGNED NOT NULL,
  `stateProvinceName` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`stateProvinceNameID`),
  KEY `spn_stateProvinceID`(`stateProvinceID`),
  KEY `spn_stateProvinceName`(`stateProvinceName`),
  CONSTRAINT `FK_spn_stateProvinceID` FOREIGN KEY `FK_spn_stateProvinceID`(`stateProvinceID`) REFERENCES `stateProvince`(`stateProvinceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


