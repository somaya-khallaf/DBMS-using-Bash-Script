# Bash Shell Script Database Management System (DBMS)
## Project Overview
The **Bash Shell Script Database Management System (DBMS)** is a simple, menu-driven command-line application that allows users to manage databases and tables stored on the file system.
The DBMS simulates common database operations, including creating and managing databases, creating and modifying tables, and performing CRUD (Create, Read, Update, Delete) operations.

## Features
### Main Menu:
- **Create Database**: Set up new databases as directories.
- **List Databases**: View all existing databases.
- **Connect to Database**: Connect to a specific database to manage tables within it.
- **Drop Database**: Safely delete a database when it's no longer needed.

### Database Operations (Upon Connecting to a Database):
- **Create Table**: Define a new table, including column names, data types, and primary key.
- **List Tables**: List all tables in the connected database.
- **Drop Table**: Delete tables you no longer need.
- **Insert into Table**: Add data into a table, with data type checks.
- **Select from Table**: Display data in a readable format.
- **Delete from Table**: Remove specific records.
- **Update Table**: Edit records with automatic data type checks.
- 
## Features Details:
- **Column Data Types**
When creating a table, users are prompted to define column data types (int, string), which are checked during insert and update operations to ensure the data conforms to the correct type.
- **Primary Key**
During table creation, users specify a primary key, which is used to ensure uniqueness of rows. The system will check for primary key violations when inserting data.
- **Table Display**
The Select from Table operation will display rows in a user-friendly format, making it easier to view and understand the data.
