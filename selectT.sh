#! /usr/bin/bash

print_separator() {
    local columns=$1
    for ((j = 1; j <= columns; j++)); do
        printf "%-15s" "---------------"
    done
    echo
}
print_header() {
    local columns=$1
    local column_names=("${@:2}")
    for ((j = 0; j < columns; j++)); do
        printf "%-15s" "|${column_names[j]}"
    done
    echo
}

read -p "Please enter table name: " TNameS
to_uppercase "TNameS"
TNameS=$(echo $TNameS | tr ' ' '_')
if [ ! -z "$TNameS" ]
then
	if [ -e ~/DBMS/$DBNameC/$TNameS ]
	then
		ColumnNames=($(awk -F: '{print $1}' ~/DBMS/$DBNameC/.MetaData$TNameS))
		DataTypes=($(awk -F: '{print $2}' ~/DBMS/$DBNameC/.MetaData$TNameS))
		
		while true
		do
			echo "---------------------------------------"
			echo "-----------Select Table Menu-----------"
			echo "---------------------------------------"
			PS3="Choose an option for selection: "
		select option in "Select All Data" "Select with Condition" "Select Specific Columns" "Select Specific Column with Condition" "Exit"

		do
		case $option in
		
		# select all rows with all columns
		"Select All Data")
			var_col=$(wc -l < ~/DBMS/$DBNameC/.MetaData$TNameS)
			var_row=$(wc -l < ~/DBMS/$DBNameC/$TNameS)

			print_separator "$var_col"

			print_header "$var_col" "${ColumnNames[@]}"

			print_separator "$var_col"

			for ((i=1;i<=var_row;i++))	
			do		
				for ((j=1;j<=var_col;j++))
				do
					value=$(sed -n "${i}p" ~/DBMS/$DBNameC/$TNameS | cut -d: -f$j)
					printf "%-15s" "| $value"
				done	
				echo
			done
			echo
			break
		;;
			
		# select all columns with condition
		"Select with Condition")
			varD=$(wc -l < ~/DBMS/$DBNameC/.MetaData$TNameS)

			PS3="Choose a column for the condition: "
			select choice in "${ColumnNames[@]}" "Exit"
			do
				if [ "$choice" = "Exit" ]; then
					echo "Exiting condition selection."
					PS3="Choose an option for selection: "
					break
				fi

				if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]; then
					echo "You selected: $choice ($REPLY)"
					read -p "Enter value for $choice : " Con_value
					
					dt_COL=${DataTypes[$REPLY-1]}
					column_index=$REPLY
					
					if { [ "$dt_COL" = "integer" ] && is_number "$Con_value"; } || { [ "$dt_COL" = "string" ] && is_string "$Con_value"; }
					then
						RowNumbers=($(awk -v col="$column_index" -v val="$Con_value" -F: '$col == val {print $1}' ~/DBMS/$DBNameC/$TNameS))

						if [ ${#RowNumbers[@]} -eq 0 ]
						then
							echo "No matching rows found for value '$Col_value'."
						else
							print_separator "$var_col"

							print_header "$var_col" "${ColumnNames[@]}"

							print_separator "$var_col"

							for row in "${RowNumbers[@]}"
							do
								for ((j = 1; j <= var_col; j++))
								do	
									value=$(sed -n "/^${row}:/p" ~/DBMS/$DBNameC/$TNameS | cut -d: -f$j)
									printf "%-15s" "| $value"
								done
								echo
							done

						fi
					else
					        echo "Invalid value for column $choice. Must be of type $dt."
					fi
				else
					echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
				fi
				break
			done
			echo
			break
		;;
		
				
		# select all rows with specific columns		
		"Select Specific Columns")
			read -p "Enter the number of columns to select: " num_Col
			if [ "$num_Col" -gt "${#ColumnNames[@]}" ]
			then
				echo "Invalid number of columns. Maximum is ${#ColumnNames[@]}."
			else
				selected_columns=()
				for ((i=0; i<num_Col; i++))
				do
					PS3="Please Choose Column Name (Remaining: $((num_Col - i))): "
					select choice in "${ColumnNames[@]}" "Exit"
					do
						if [ "$choice" = "Exit" ]
						then
							echo "Exiting column selection."
							PS3="Choose an option for selection: "
							break 2  # Break both the select loop and the for loop
						fi

						# Check if the input is a valid number and within range
						if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]
						then
							if [[ " ${selected_columns[@]} " =~ " $((REPLY-1)) " ]]
							then
								echo "You already selected: ${ColumnNames[$REPLY-1]}. Please choose another column."
								continue
							else
								selected_columns[$i]=$(($REPLY-1)) 
								break 
							fi

						else
							echo "Invalid choice: $REPLY. Please select from [1 - ${#ColumnNames[@]}]"
						fi
					done
				done

				print_separator "$num_Col"

				for col_index in ${selected_columns[@]}
				do
					printf "%-15s" "|${ColumnNames[$col_index]}"
				done
				echo

				print_separator "$num_Col"

				for ((i=1;i<=var_row;i++))	
				do		
					for col_index in ${selected_columns[@]}
					do
						value=$(sed -n "${i}p" ~/DBMS/$DBNameC/$TNameS | cut -d: -f$((col_index+1)))
						printf "%-15s" "| $value"
					done	
					echo
				done
				PS3="Choose selection option # "
			fi
			echo
			break
		;;
		
		# select specific rows with specific columns	
		"Select Specific Column with Condition")
			read -p "Please Enter Number of columns: " num_Col
			if [ "$num_Col" -gt "${#ColumnNames[@]}" ]
			then
				echo "Invalid number of columns. You should enter a number <= ${#ColumnNames[@]}"
			else
				selected_columns=()

				for ((i=0; i<num_Col; i++))
				do
					PS3="Please Choose Column Name (Remaining: $((num_Col - i))): "
					select choice in "${ColumnNames[@]}" "Exit"
					do
						if [ "$choice" = "Exit" ]; then
							echo "Exiting column selection."
							PS3="Choose an option for selection: "
							break 2  # Break both the select loop and the for loop
						fi

						if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]
						then
							if [[ " ${selected_columns[@]} " =~ " $((REPLY-1)) " ]]; then
								echo "You already selected: ${ColumnNames[$REPLY-1]}. Please choose another column."
								continue
							else
								selected_columns[$i]=$(($REPLY-1)) 
								break  
							fi

						else
							echo "Invalid choice: $REPLY. Please select from [1 - ${#ColumnNames[@]}]"
						fi
					done
				done
				
				varD=$(wc -l < ~/DBMS/$DBNameC/.MetaData$TNameS)

				PS3="Choose a column for the condition: "
				select choice in "${ColumnNames[@]}" "Exit"
				do
					if [ "$choice" = "Exit" ]; then
						echo "Exiting column selection."
						PS3="Choose an option for selection: "
						break
					fi

					if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le "${#ColumnNames[@]}" ]
					then
						read -p "Please Enter $choice Value: " Con_value
						dt_COL=${DataTypes[$REPLY-1]}
						
						column_index=$REPLY

						if { [ "$dt_COL" = "integer" ] && is_number "$Con_value"; } || { [ "$dt_COL" = "string" ] && is_string "$Con_value"; }
						then
							echo "Correct input"


							RowNumbers=($(awk -v col="$column_index" -v val="$Con_value" -F: '$col == val {print $1}' ~/DBMS/$DBNameC/$TNameS))

					


							if [ ${#RowNumbers[@]} -eq 0 ]; then
								echo "No matching rows found for value '$Col_value'."
							else
								

								print_separator "$num_Col"


								for col_index in ${selected_columns[@]}
								do
									printf "%-15s" "|${ColumnNames[$col_index]}"
								done
								echo


								print_separator "$num_Col"

								for row in "${RowNumbers[@]}"
								do		
									for col_index in ${selected_columns[@]}
									do
										value=$(sed -n "/^${row}:/p" ~/DBMS/$DBNameC/$TNameS | cut -d: -f$((col_index+1)))
										printf "%-15s" "| $value"
									done	
									echo
								done
								PS3="Choose an option for selection: "
							fi
						else
							echo "Invalid value for column $choice. Must be $dt."
						fi
					else
						echo "Invalid choice: $REPLY. Please select from [1 - $(( ${#ColumnNames[@]} + 1 ))]"
						
					fi
					break
				done
			fi
			echo
			break 
		;;

		"Exit")
			echo "Exiting selection menu "
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
		echo "Table is not exist"
	fi	
else 
	echo "You did not enter a table name."
fi
