#!/usr/bin/bash

directories=$(find ~/DBMS -mindepth 1 -maxdepth 1 -type d)

if [ -n "$directories" ]
then
    echo "Databases available in the DBMS:"
    counter=1
    for each_element in $directories
    do
        echo "$counter : $(echo "$each_element" | cut -d/ -f5| grep -v "^$")"
        ((counter++))
    done
else
    echo "No databases found."
fi

