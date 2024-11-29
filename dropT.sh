#! /usr/bin/bash

read -p "Please enter table name to be dropped: " TNameD
to_uppercase "TNameD"
TNameD=$(echo $TNameD | tr ' ' '_')

if [ -e ~/DBMS/$DBNameC/$TNameD ]
then
	rm -i ~/DBMS/$DBNameC/$TNameD 
	if [ -e ~/DBMS/$DBNameC/$TNameD ]
	then 
		echo "Table drop operation cancelled."
	else 
		echo "Table '$TNameD' removed successfully"	
	fi
	
	rm -i ~/DBMS/$DBNameC/".MetaData$TNameD" 
	if [ -e ~/DBMS/$DBNameC/".MetaData$TNameD" ]
	then
		echo "MetaData drop operation cancelled."
	else	
		echo "Metadata for '$TNameD' removed successfully."
	fi
else 
	echo "Table '$TNameD' does not exist."
fi
