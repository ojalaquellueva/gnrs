-- 
-- Adds indexes and constraints on geonames tables
-- 

-- PKs
ALTER TABLE ONLY alternatename
    ADD CONSTRAINT alternatenameid_pkey PRIMARY KEY (alternatenameid);
ALTER TABLE ONLY geoname
    ADD CONSTRAINT geonameid_pkey PRIMARY KEY (geonameid);
ALTER TABLE ONLY countryinfo
    ADD CONSTRAINT iso_alpha2_pkey PRIMARY KEY (iso_alpha2);

-- FK constraints
ALTER TABLE ONLY countryinfo
    ADD CONSTRAINT countryinfo_geonameid_fkey FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
ALTER TABLE ONLY alternatename
    ADD CONSTRAINT alternatename_geonameid_fkey FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
    
-- Indexes
CREATE INDEX countryinfo_geonameid_idx ON countryinfo USING hash (geonameid);
CREATE INDEX alternatename_geonameid_idx ON alternatename USING hash (geonameid);