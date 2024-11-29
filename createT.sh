#! /usr/bin/bash
read -p "Please enter table name to be created: " TName
to_uppercase "TName"
TName=$(echo $TName | tr ' ' '_')

# Check if table name is valid
if is_string_db "$TName"
then
	# Check if the table already exists
	if [ -e ~/DBMS/$DBNameC/$TName ]
	then
		echo "Table is already exist"
	else 
		read -p "Please enter the number of columns: " numCol
		
		# Validate column count
		if is_positive_integer "$numCol" && [ "$numCol" -gt 0 ]
		then		
			PK=0
			for ((i=0;i<$numCol;i++))
			do
				data=""
				if [ $i -eq 0 ]
				then
					read -p "Please enter Primary key column name: " ColName
					to_uppercase "ColName"
					ColName=$(echo $ColName | tr ' ' '_')
					data+=:$ColName
					PK=1			
				else					
					read -p "Please enter column name: " ColName
					
					to_uppercase "ColName"
					ColName=$(echo $ColName | tr ' ' '_')
					
					# Check if the column name exists in metadata
					count=$(cut -f1 -d: $HOME/DBMS/$DBNameC/.MetaData$TName | grep -w $ColName | wc -l )
					if is_string_db "$ColName"
					then
						if [ $count -gt 0 ]
						then
							echo "Column name already exists. Please enter a new name."
							((i--)) 
							continue
						else 
						    data+=:$ColName
						fi
					else
						echo "Invalid column name. Must start with letter, no spaces or special characters, and not be too long"
						echo "Restarting column entry."	
						echo	                    
						((i--)) 
						continue
					fi		
				fi
									
				while true
				do
				    PS3="Please choose column datatype: "
				    
				    select ColDT in integer string 
				    do
					case $ColDT in
					"integer")
					    data+=:$ColDT
					    break 2 # Breaks out of both select and while loop
					    ;;
					    
					"string")
					    data+=:$ColDT
					    break 2 # Breaks out of both select and while loop
					    ;;
					    
					*)
					    echo "Unknown option. Please select a valid data type."
					    ;;
					    
					esac
				    done				    
				done
				
				if [ $PK -eq 1 ]
				then			
					data+=:Primary_Key
					PK=0
				fi											
			 							
				echo ${data:1}
				echo "${data:1}" >> "$HOME/DBMS/$DBNameC/.MetaData$TName"
			done
			touch ~/DBMS/$DBNameC/$TName
			echo "$TName is created successfully"
			PS3="SELECT WHAT YOU WANT TO DO IN $DBNameC DATABASE # "
		
		else
			echo "Invalid number of columns. You should enter number greater than 0"
		fi		
	fi
else
	echo "Invalid name. Must start with letter, no spaces or special characters, and not be too long"
fi
