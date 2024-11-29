#! /usr/bin/bash
read -p "Please enter database name to connect: " DBNameC
DBNameC=$(echo $DBNameC | tr ' ' '_')
to_uppercase "DBNameC"
if [ ! -z "$DBNameC" ]
then

	if [[ -e ~/DBMS/$DBNameC ]]
	then
		echo "You are now connected to $DBNameC" 
		cd ~/DBMS/$DBNameC
		while true
		do
			echo "---------------------------------------"
			echo "---------Connect Database Menu---------"
			echo "---------------------------------------"
			PS3="SELECT WHAT YOU WANT TO DO IN $DBNameC Database # "
			select option in "Create Table" "List Tables" "Drop Table" "Insert Into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
			do

				case $option in
				"Create Table")	
					. createT.sh
					echo
					break
					;;
								
				"List Tables")
					. listT.sh
					echo
					break
					;;
						
				"Drop Table")
					. dropT.sh
					echo
					break
					;;
						
				"Insert Into Table")
					. insertT.sh
					echo
					break	
					;;
					
				"Select From Table")
					. selectT.sh
					echo
					break
					;;
					
				"Delete From Table")
					. deleteT.sh
					echo
					break
					;;
						
				"Update Table")
					. updateT.sh
					echo
					break
					;;
					
				"Exit")
					echo "Exiting $DBNameC Database"
					PS3="SELECT FEATURE YOU WANT TO DO IN DBMS # "
					break 2
					;;
					
				*)
					echo "Unknown option. Please try again."
					break 
				esac		
			done
		done		
	else 
		echo "Database '$DBNameC' does not exist !"
	fi
else 
	echo "You did not enter a database name."
fi
