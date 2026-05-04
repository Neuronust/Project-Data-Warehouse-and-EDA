/*
=============================================================
Initialize Data Warehouse Schemas
=============================================================
Description:
    This script sets up the core schemas used in the data warehouse,
    namely 'bronze', 'silver', and 'gold'.

    These schemas represent different stages of the data pipeline:
        - bronze : raw data ingestion layer
        - silver : cleaned and transformed data layer
        - gold   : final, analysis-ready layer

Note:
    This script only creates schemas. The database must already exist
    before running this script.
=============================================================
*/

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;