CREATE TABLE `countyParishScrubbed` (
  `countyParishVerbatim` VARCHAR(100) NOT NULL,
  `stateProvinceID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `countyParishScrubbed` VARCHAR(100) DEFAULT NULL,
  `countyParishScrubbedPlainAscii` VARCHAR(100) DEFAULT NULL,
  `countyParishID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `message` VARCHAR(100) DEFAULT NULL,
  UNIQUE KEY `cps_stateProvince_countyParish_PK`(`stateProvinceID`,`countyParishVerbatim`),
  KEY `cps_countyParishVerbatim_NDX`(`countyParishVerbatim`),
  KEY `cps_stateProvinceID_NDX`(`stateProvinceID`),
  KEY `cps_countyParishScrubbed_NDX`(`countyParishScrubbed`),
  KEY `cps_countyParishScrubbedPlainAscii_NDX`(`countyParishScrubbedPlainAscii`),
  KEY `cps_countyParishID_NDX`(`countyParishID`),
  KEY `cps_message_NDX`(`message`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

