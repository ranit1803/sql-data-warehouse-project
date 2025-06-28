/*
=============================================================
Create Database and Simulate Schemas
=============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse'. 
    Additionally, it creates three separate databases named 'Bronze', 'Silver', and 'Gold' 
    to simulate schema layers within a MySQL environment.

WARNING:
    Running this script will drop the 'DataWarehouse', 'Bronze', 'Silver', and 'Gold' 
    databases if they already exist. All data in these databases will be permanently deleted. 
    Proceed with caution and ensure you have proper backups before running this script.
*/

-- Drop databases if they exist
DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS Bronze;
DROP DATABASE IF EXISTS Silver;
DROP DATABASE IF EXISTS Gold;

-- Create the main database
CREATE DATABASE DataWarehouse;
USE DataWarehouse;

-- Create simulated schema layer databases
CREATE DATABASE Bronze;
CREATE DATABASE Silver;
CREATE DATABASE Gold;
