#! /usr/bin/bash


read -p "Please enter table name: " TNameI
to_uppercase "TNameI"
TNameI=$(echo $TNameI | tr ' ' '_')
if [ ! -z "$TNameI" ]
then
	if [ -e ~/DBMS/$DBNameC/$TNameI ]
	then
		var=$(wc -l < ~/DBMS/$DBNameC/.MetaData$TNameI)
		ColumnNames=($(awk -F: '{print $1}' ~/DBMS/$DBNameC/.MetaData$TNameI))
		DataTypes=($(awk -F: '{print $2}' ~/DBMS/$DBNameC/.MetaData$TNameI))
		
		for ((i=0;i<var;i++))	
		do
			read -p "Please enter ${ColumnNames[i]} values (Type: ${DataTypes[i]}): " inserted_val[$i]				
		done
		
		inertData=""
		error=0
		for ((i=0;i<var;i++))	
		do
			if [ "${DataTypes[i]}" = "integer" ]
			then
				if is_number "${inserted_val[i]}"
				then
					inertData+=:${inserted_val[i]}
					if [ $i -eq 0 ]
					then	
						# For primary key check
						searsh=${inserted_val[i]}
					fi
				else 
					inertData+=""
					echo "Invalid ${ColumnNames[i]} value. Must be an integer."
					((error++))
					
				fi
			elif [ "${DataTypes[i]}" = "string" ]
			then
				if is_string "${inserted_val[i]}"
				then
				inertData+=:${inserted_val[i]}
				else 
					inertData+=""
					echo "Invalid ${ColumnNames[$i]} value. Must not be empty"
					((error++))
					
				fi
			else
				inertData+=""
				((error++))
				echo "Invalid ${ColumnNames[i]} data type. Must be 'integer' or 'string'."
				
			fi		
		done
		
		countPk=$(cut -d: -f1 ~/DBMS/$DBNameC/$TNameI | grep -w "$searsh" | wc -l)
		if [ $countPk -eq 0 ] 
		then
			if [ $error -eq 0 ]
			then
				echo ${inertData:1}
				echo "${inertData:1}" >> "$HOME/DBMS/$DBNameC/$TNameI"				
				echo "Data inserted successfully into $TNameI"
			fi
			
		elif [ $error -gt 0 ]
		then
			echo "Duplicate Primary Key or Invalid Data. Insertion failed."
		else
			echo "Duplicate Primary Key. Insertion failed."
		fi
	else 
		echo "Table '$TNameI' does not exist."
	fi
	
else 
	echo "You did not enter a table name."
fi
