CREATE TABLE `stateProvinceScrubbed` (
  `stateProvinceVerbatim` VARCHAR(100) NOT NULL,
  `countryID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `stateProvinceScrubbed` VARCHAR(100) DEFAULT NULL,
  `stateProvinceScrubbedPlainAscii` VARCHAR(100) DEFAULT NULL,
  `stateProvinceID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `message` VARCHAR(100) DEFAULT NULL,
  UNIQUE KEY `sps_country_stateProvince_PK`(`countryID`,`stateProvinceVerbatim`),
  KEY `sps_stateProvinceVerbatim_NDX`(`stateProvinceVerbatim`),
  KEY `sps_countryID_NDX`(`countryID`),
  KEY `sps_stateProvinceScrubbed_NDX`(`stateProvinceScrubbed`),
  KEY `sps_stateProvinceScrubbedPlainAscii_NDX`(`stateProvinceScrubbedPlainAscii`),
  KEY `sps_stateProvinceID_NDX`(`stateProvinceID`),
  KEY `sps_message_NDX`(`message`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

