#! /usr/bin/bash

read -p "Please enter table name: " TNameD
to_uppercase "TNameD"
TNameD=$(echo $TNameD | tr ' ' '_')

if [ ! -z "$TNameD" ]
then
	if [ -e ~/DBMS/$DBNameC/$TNameD ]
	then
		while true
		do
			echo "---------------------------------------"
			echo "-----------Delete Table Menu-----------"
			echo "---------------------------------------"
			PS3="SELECT deletion option # "
			select option in "By Primary Key" "By Column Value" "Delete all data" "Exit"
			do

			case $option in
			"By Primary Key")
				read -p "Please enter Primary Key Value: " PK_value
				dt_PK=$(head -1 ~/DBMS/$DBNameC/.MetaData$TNameD | cut -d: -f2 )
				 if { [ "$dt_PK" = "integer" ] && is_number "$PK_value"; } || { [ "$dt_PK" = "string" ] && is_string "$PK_value"; }
				 then
					val=$(cut -d: -f1 ~/DBMS/$DBNameC/$TNameD | grep -w $PK_value | wc -l)
						if [ "$val" -gt 0 ]
						then
							sed -i "/^$PK_value:/d" ~/DBMS/$DBNameC/$TNameD
			                            	echo "Record with primary key = $PK_value deleted successfully."

						else
							echo "Primary key $PK_value does not exit "
						fi
				else
			    		echo "Invalid primary key value. Must be of type $dt_PK."
				fi
				echo
				break
				
				;;
				
					
			"By Column Value")
			
				ColumnNames=($(awk -F: '{print $1}' ~/DBMS/$DBNameC/.MetaData$TNameS))
				DataTypes=($(awk -F: '{print $2}' ~/DBMS/$DBNameC/.MetaData$TNameS))

				PS3="Choose a column for the condition: "
				select choice in "${ColumnNames[@]}" "Exit"
				do
				if [ "$choice" = "Exit" ]
				then
				    echo "Exiting column selection."
				    PS3="SELECT deletion option # "
				    break
				fi

				if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]; then

				    read -p "Please Enter $choice Value: " Col_value
				    dt=${DataTypes[$REPLY-1]}
				    echo "Data type: $dt"
				    if { [ "$dt" = "integer" ] && is_number "$Col_value"; } || { [ "$dt" = "string" ] && is_string "$Col_value"; }
				    then
					column_index=$REPLY

					RowNumbers=($(awk -v col="$column_index" -v val="$Col_value" -F: '$col == val {print $1}' ~/DBMS/$DBNameC/$TNameD))

					if [ ${#RowNumbers[@]} -eq 0 ]; then
					    echo "No matching rows found for value '$Col_value'."
					else
					    for row in "${RowNumbers[@]}"; do
						sed -i "/^${row}:/d" ~/DBMS/$DBNameC/$TNameD
						echo "Record with primary key = $row deleted successfully."
					    done					  
					fi
				    else
					echo "Invalid value for column $choice. Must be $dt."
				    fi
				else
				    echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
				    continue
				fi
				break
				done
				echo
				break
			    ;;
			    
			"Delete all data")
	                   	read -p "Are you sure you want to delete all data in the $TNameD table? (yes/no): " ans
				if [[ "$ans" =~ ^[yY](es|ES|eS|Es|e|E|s|S)?$ ]]
				then
					sed -i '1,$d' ~/DBMS/$DBNameC/$TNameD
					echo "All data deleted successfully."
				else
					echo "Delete operation cancelled."
				fi
				echo	
				break
				
				;;
				
				
			"Exit")
				echo "Exiting delete menu "
				PS3="SELECT WHAT YOU WANT TO DO IN $DBNameC Database # "
				break 2
				;;
				
			*)
				echo "Unknown option. Please try again."
				break
			esac
			done
		done
	else 
		echo "Table '$TNameD' does not exist."
	fi
else 
	echo "You did not enter a table name."
fi
