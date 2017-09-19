CREATE TABLE `stateProvinceScrubbed` (
  `stateProvinceVerbatim` VARCHAR(100) NOT NULL,
  `countryID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `stateProvinceScrubbed` VARCHAR(100) DEFAULT NULL,
  `stateProvinceScrubbedPlainAscii` VARCHAR(100) DEFAULT NULL,
  `stateProvinceID` INTEGER(11) UNSIGNED DEFAULT NULL,
  `message` VARCHAR(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

