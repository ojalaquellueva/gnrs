CREATE TABLE `countryStaging` (
  `isoCode` VARCHAR(2) NOT NULL,
  `countryCode3Char` VARCHAR(3) DEFAULT NULL,
  `countryNameStd` VARCHAR(100) DEFAULT NULL,
  KEY (`isoCode`),
  KEY `countryCode3Char`(`countryCode3Char`),
  KEY `countryNameStd`(`countryNameStd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `countryNameStaging` (
  `isoCode` VARCHAR(2) NOT NULL,
  `countryName` VARCHAR(100) DEFAULT NULL,
  `langCode` VARCHAR(3) DEFAULT NULL,
  KEY `isoCode`(`isoCode`),
  KEY `countryName`(`countryName`),
  KEY `langCode`(`langCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `country` (
  `countryID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `isoCode` VARCHAR(2) NOT NULL,
  `countryCode3Char` VARCHAR(3) DEFAULT NULL,
  `countryNameStd` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`countryID`),
  UNIQUE KEY (`isoCode`),
  KEY `countryCode3Char`(`countryCode3Char`),
  KEY `countryNameStd`(`countryNameStd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `countryName` (
  `countryNameID` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `countryID` INTEGER(11) UNSIGNED NOT NULL,
  `countryName` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`countryNameID`),
  KEY `countryID`(`countryID`),
  KEY `countryName`(`countryName`),
  CONSTRAINT `FK_countryID` FOREIGN KEY `FK_countryID`(`countryID`) REFERENCES `country`(`countryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
