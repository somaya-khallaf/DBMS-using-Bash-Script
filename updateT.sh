#! /usr/bin/bash

read -p "Please Enter Table Name: " TNameU
to_uppercase "TNameU"
TNameU=$(echo $TNameU | tr ' ' '_')
if [ ! -z "$TNameU" ]
then
	if [ -e ~/DBMS/$DBNameC/$TNameU ]
	then
		ColumnNames=($(awk -F: '{print $1}' ~/DBMS/$DBNameC/.MetaData$TNameU))
		DataTypes=($(awk -F: '{print $2}' ~/DBMS/$DBNameC/.MetaData$TNameU))
		while true
		do
			echo "---------------------------------------"
			echo "-----------Update Table Menu-----------"
			echo "---------------------------------------"
			PS3="Choose update option # "
			select option in "Update By Primary Key" "Update By Specific Column" "Exit"
			do
			
			case $option in
			"Update By Primary Key")
				read -p "Please Enter Primary Key Value (condition): " PK_value
				 dt_PK=$(head -1 ~/DBMS/$DBNameC/.MetaData$TNameU | cut -d: -f2 )
				 if { [ "$dt_PK" = "integer" ] && is_number "$PK_value"; } || { [ "$dt_PK" = "string" ] && is_string "$PK_value"; }
				 then
					val=$(cut -d: -f1 ~/DBMS/$DBNameC/$TNameU | grep -w "$PK_value" | wc -l)
						if [ "$val" -gt 0 ]
						then
							PS3="Please Choose Column Name (set column): "
							select choice in "${ColumnNames[@]}" "Exit"
							do
							if [ "$choice" = "Exit" ]; then
							    echo "Exiting column selection."
							    PS3="SELECT update option # "
							    break
							fi

							if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]
							then
							 
							    read -p "Please Enter $choice (set value): " value
							    dt=${DataTypes[$REPLY-1]}
							
							 if { [ "$dt" = "integer" ] && is_number "$value"; } || { [ "$dt" = "string" ] && is_string "$value"; }; then		
								val_new=$(cut -d: -f1 ~/DBMS/$DBNameC/$TNameU | grep -w "$value" | wc -l)
								if [ "$val_new" -eq 0 ]
								then
									column_index=$REPLY
									old_val=$(awk -v col="$column_index" -v pk="$PK_value" -F: '$1 == pk {print $col}' ~/DBMS/$DBNameC/$TNameU)
									awk -v col="$column_index" -v val="$value" -v pk="$PK_value" -F: '$1 == pk { $col = val }1'                                                                 OFS=: ~/DBMS/$DBNameC/$TNameU > temp && mv temp ~/DBMS/$DBNameC/$TNameU
									echo "Updated successfully!"
					
									PS3="Choose update option # "
									break
								else
									echo "Update failed: Duplicate primary key $PK_value. Use a unique value."
									echo
									
								fi                               
							    else
								echo "Invalid value for column $choice. Must be $dt."
							    fi
							else
							    echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
							fi
							break
							done
							
						else
							echo "primary key $PK_value is not exit "
						fi
				else
			    		echo "Invalid primary key value."
				fi
				echo
				break
				
				;;
			
					
			"Update By Specific Column")
			    PS3="Please Choose Column Name (condition column): "				
				select choice1 in "${ColumnNames[@]}" "Exit"; do
				if [ "$choice1" = "Exit" ]; then
				    echo "Exiting condition column selection."
				    PS3="SELECT update option # "
				    break
				fi
				
				if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]; then

				    read -p "Please Enter $choice1 (condition value): " valuecolcon
				    dt_condition=${DataTypes[$REPLY-1]}
					columnContion_index=$REPLY
					# set Column and value
					PS3="Please Choose Column Name (set column): "				
					select choice2 in "${ColumnNames[@]}" "Exit"
					do
					if [ "$choice2" = "Exit" ]; then
					    echo "Exiting set column selection."
					     PS3="Please Choose Column Name (condition column): "
					    break
					fi
					columnSet_index=$REPLY
					if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]; then
					    echo "You selected: $choice2 ($REPLY)"
					    read -p "Please Enter $choice2 (condition value): " valuecolset
					    dt_set=${DataTypes[$REPLY-1]}
					    
				    		if { [ "$dt_condition" = "integer" ] && is_number "$valuecolcon"; } || { [ "$dt_condition" = "string" ] && is_string "$valuecolcon"; } && { [ "$dt_set" = "integer" ] && is_number "$valuecolset"; } || { [ "$dt_set" = "string" ] && is_string "$valuecolset"; }		    	
									    			
				    			then
							val_new=$(cut -d: -f$columnContion_index ~/DBMS/$DBNameC/$TNameU | grep -w "$valuecolcon" | wc -l)
							if [ "$val_new" -gt 0 ]
							then
								pk=($(awk -v col="$columnContion_index" -v val="$valuecolcon" -F: '$col == val {print $1}' ~/DBMS/$DBNameC/$TNameU))
								for row in ${pk[@]}
								do
									awk -v col="$columnSet_index" -v val="$valuecolset" -v pk="$row" -F: '$1 == pk { $col = val }1'                                                      OFS=: ~/DBMS/$DBNameC/$TNameU > temp && mv temp ~/DBMS/$DBNameC/$TNameU
									
								done
								echo "Updated successfully!"
							
								PS3="Choose update option # "
								break
							else
								echo "No matching rows found for value '$valuecolcon' in column $choice1."
							fi                               
					    else
						echo "Invalid value for column $choice1. Must be $dt_condition and $choice2. Must be $dt_set."
						break
					    fi				 
					else
					    echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
					fi
					break
					done   
				else
				    echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
				fi
				break
				done   
				echo
			    break
			    ;;

				
			"Exit")
				echo "Exiting update menu "
				PS3="SELECT WHAT YOU WANT TO DO IN $DBNameC Database #"
				break 2
				;;
				
			*)
				echo "Unknown option. Please try again."
				break
			esac
			done
		done
	else 
		echo "Table '$TNameU' does not exist."
	fi
else 
	echo "You did not enter a table name."
fi
