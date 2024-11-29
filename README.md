# Bash Shell Script Database Management System (DBMS)
## Project Overview
The **Bash Shell Script Database Management System (DBMS)** is a simple, menu-driven command-line application that allows users to manage databases and tables stored on the file system.
The DBMS simulates common database operations, including creating and managing databases, creating and modifying tables, and performing CRUD (Create, Read, Update, Delete) operations.

## Features
### Main Menu:
- **Create Database**: Create a new database as a directory in the current script file.
- **List Databases**: List all existing databases stored in the directory.
- **Connect to Database**: Connect to a specific database to manage tables within it.
- **Drop Database**: Delete a database (remove its directory).

### Database Operations (Upon Connecting to a Database):
- **Create Table**: Define a new table, including column names, data types, and primary key.
- **List Tables**: List all tables within the current database.
- **Drop Table**: Remove an existing table from the database.
- **Insert into Table**: Add data into a table, with data type checks.
- **Select from Table**: Retrieve and display data from a table, formatted for easy reading.
- **Delete from Table**: Remove data from a table.
- **Update Table**: Modify data in a table, ensuring data types are valid.

## Features Details:
- **Column Data Types**
When creating a table, users are prompted to define column data types (int, string), which are checked during insert and update operations to ensure the data conforms to the correct type.
- **Primary Key**
During table creation, users specify a primary key, which is used to ensure uniqueness of rows. The system will check for primary key violations when inserting data.
- **Table Display**
The Select from Table operation will display rows in a user-friendly format, making it easier to view and understand the data.
