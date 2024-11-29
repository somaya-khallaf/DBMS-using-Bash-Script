#! /usr/bin/bash
# Bash Shell Script Database Management System (DBMS)

to_uppercase() {
	local output_var="$1" # Name of the output variable
	eval "$output_var=\"\${$output_var^^}\""
}

is_number() {
	if [[ $1 =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
	then
		return 0
	else
		return 1
	fi
}

is_positive_integer() {
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        return 0
    else
        return 1
    fi
}

# Function to check if the input is a string (contains only letters and number but not first char)
is_string_db() {
	if [[ $1 =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]] && [[ ${#1} -le 20 ]]
	then
		return 0	
	else
		return 1
	fi
}

is_string() {
	if [[ ! -z $1 ]]
	then
		return 0
	else
		return 1  
	fi
}

if [ -e ~/DBMS ]
then	
	cd ~/DBMS
	echo "DBMS is ready"
else 
	mkdir ~/DBMS
	cd ~/DBMS
	echo "DBMS is created successfully and ready Now."
fi

while true
do
	echo "---------------------------------------"
	echo "---------------Main Menu---------------"
	echo "---------------------------------------"
	PS3="SELECT FEATURE YOU WANT TO DO IN DBMS # "
	select option in "Create Database" "List Databases" "Connect To Databases" "Drop Database" "Exit"
	do
		case $option in
		"Create Database")
			. createDB.sh	
			echo
			break
			;;

		"List Databases")
			. listDB.sh
			echo
			break
			;;
			
		"Connect To Databases")
			. connectDB.sh

			echo
			break				  
			;;

		"Drop Database")
			. dropDB.sh

			echo
			break
			;;

		"Exit")
			echo "Exiting DBMS. Goodbye $USER"
			echo
			break 2
			;;

		*)
			echo "Unknown option. Please try again."
			break 
			;;
		esac
	done
done
