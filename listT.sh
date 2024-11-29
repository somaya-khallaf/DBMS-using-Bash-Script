#! /usr/bin/bash

files=$(find ~/DBMS/$DBNameC -mindepth 1 -maxdepth 1 -type f ! -name ".*")

if [ -n "$files" ]
then
	counter=1
	echo "Tables available in the $DBNameC :"
	for each_element in $files
	do
		echo "$counter : $(echo "$each_element" | cut -d/ -f6 | grep -v "^$")"
		((counter++))
	done
else
	echo "No Tables found."
fi


