CREATE TABLE `countryScrubbed` (
  `countryVerbatim` VARCHAR(100) NOT NULL,
  `countryScrubbed` VARCHAR(100) DEFAULT NULL,
  `countryScrubbedPlainAscii` VARCHAR(100) DEFAULT NULL,
  `countryID` INTEGER(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`countryVerbatim`),
  KEY `countryScrubbed_NDX`(`countryScrubbed`),
  KEY `countryScrubbedPlainAscii_NDX`(`countryScrubbedPlainAscii`),
  KEY `countryID_NDX`(`countryID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

