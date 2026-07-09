#!/bin/bash

#Dir shotcut
rep_dir="../reports"
log_dir="../logs"

#file shortcut
rep_file="$rep_dir/update_report.txt"
log_file="$log_dir/system_update_tracker.log"

#main variables
OS_Name=""
Package_Manager=""
Update_list=""
Update_Count=0
Total_Package=0
TimeStamp=""

setup(){
	mkdir -p "$log_dir"
        mkdir -p "$rep_dir"
}

detect_package_manager(){
	source /etc/os-release #takes the whole os-release file as a source
	OS_Name="$PRETTY_NAME"

	if command -v apt > /dev/null 2>&1
	then Package_Manager="apt"

	elif command -v dnf > /dev/null 2>&1
	then Package_Manager="dnf"

	elif command -v yum > /dev/null 2>&1
	then Package_Manager="yum"

	else
	   echo "Unsupported Linux Distribution"
	  exit 1

	fi
}

check_updates(){
	if [ "$Package_Manager" = "apt" ]
	then
	    Update_list=$(apt list --upgradable 2>/dev/null)
	    Total_Package=$(apt list --installed 2>/dev/null | wc -l)
	    Update_Count=$(echo "$Update_list" | grep -i "upgradable from" | wc -l)

	elif [ "$Package_Manager" = "dnf" ]
	then
	    Update_list=$(dnf check-update 2>/dev/null)
	    status=$?
							#to manage exit code 100 given by rhel if update is available
	    if [ "$status" -eq 100 ] || [ "$status" -eq 0 ]
		then
   		    :
		else
    		    echo "Error: Unable to check for package updates."
    		    exit 1
	    fi
            Total_Package=$(dnf list installed | wc -l)
	    Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}') #check for where number of fields(NF) are 3 then counts it

	elif [ "$Package_Manager" = "yum" ]
        then
            Update_list=$(yum check-update)
            Total_Package=$(yum list installed | wc -l)
	    Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}')

	fi
	TimeStamp=$(date "+%d-%m-%Y %H:%M:%S")
}

create_report(){
	echo "=========================================" > "$rep_file"
	echo "       SYSTEM UPDATE REPORT" >> "$rep_file"
	echo "=========================================" >> "$rep_file"
	echo "" >> "$rep_file"

	echo "Generated On    : $TimeStamp" >> "$rep_file"
	echo "Operating System : $OS_Name" >> "$rep_file"
	echo "Package Manager : $Package_Manager" >> "$rep_file"
	echo "Total Packages : $Total_Package" >> "$rep_file"
	echo "Updates Available : $Update_Count" >> "$rep_file"

	echo "" >> "$rep_file"

	if [ "$Update_Count" -eq 0 ]
	then
	   echo "System is up to date." >> "$rep_file"
	else
	   echo "Packages Requiring Updates" >> "$rep_file"
           echo "-----------------------------------------" >> "$rep_file"

           if [ "$Package_Manager" = "apt" ]
	      then
    		echo "$Update_list" | grep "upgradable from" >> "$rep_file"
	   else
    		echo "$Update_list" >> "$rep_file"
	   fi
	fi

	echo "" >> "$rep_file"
        echo "=========================================" >> "$rep_file"

}

create_log(){
	echo "=========================================" >> "$log_file"
        echo "Log Entry : $TimeStamp" >> "$log_file"
	echo "=========================================" >> "$log_file"

	cat "$rep_file" >> "$log_file"

	echo "" >> "$log_file"
}

display(){
	cat "$rep_file"
}

main(){

    setup

    detect_package_manager

    check_updates

    create_report

    display

    create_log
}

main
