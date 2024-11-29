#! /usr/bin/bash 

read -p "Please enter database name: " DBNameD
to_uppercase "DBNameD"
DBNameD=$(echo $DBNameD | tr ' ' '_')
if [ ! -z "$DBNameD" ]
then
	if [ -e ~/DBMS/$DBNameD ]
	then
		rm -ir ~/DBMS/$DBNameD
		if [ -e ~/DBMS/$DBNameD ]
		then
			echo "Database drop operation cancelled."
		else
			echo "Database '$DBNameD' is removed successfully."
		fi
	else 
		echo "Database '$DBNameD' does not exis."
	fi
else 
	echo "You did not enter a database name."
fi
	
