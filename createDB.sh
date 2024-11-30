#! /usr/bin/bash

read -p "Please enter database name: " DBName
to_uppercase "DBName"
DBName=$(echo $DBName | tr ' ' '_')
if [ ! -z "$DBName" ]
then
	if is_string_db "$DBName"
	then
		if [ -e ~/DBMS/$DBName ]
		then
			echo "Database ($DBName) already exist"
			while true	
			do	
				read -p "Enter a different name: " DBName
				DBName=$(echo $DBName | tr ' ' '_')
				to_uppercase "DBName"
				if ! is_string_db "$DBName" 
				then
				    continue
				fi
				if [ -e ~/DBMS/$DBName ]
				then
					echo "Database ($DBName) already exist"
				else
					mkdir ~/DBMS/$DBName
					echo "Database ($DBName) created successfully"
					break
				fi
			done
		else 	
			mkdir ~/DBMS/$DBName
			echo "Database ($DBName) created successfully"
		fi
	else
		echo "Invalid name. Must start with letter, no special characters, and not be too long"		
	fi
else 
	echo "You did not enter a database name."
fi

