#!/bin/bash

#dir_shortcut
rep_dir="../reports"
log_dir="../logs"

#file shortcut
rep_file="$rep_dir/backup_verification_report.txt"
log_file="$log_dir/backup_verification.log"

#main var
Source_Dir=""
Backup_Dir=""
Archive_Name=""
Archive_Path=""
Temp_Dir=""

Verification_Status=""
Comparison_Output=""

Total_Source_Files=0
Matching_Files=0
Missing_Files=0
Additional_Files=0
Modified_Files=0

TimeStamp=$(date "+%d-%m-%Y %H:%M:%S")

#color
Green="\e[32m"
Red="\e[31m"
Yellow="\e[33m"
Blue="\e[34m"
Cyan="\e[35m"
Reset="\e[0m"


setup(){

	mkdir -p "$rep_dir"
	mkdir -p "$log_dir"
}

verify_inputs(){
	if [ ! -d "$Source_Dir" ]
	then echo -e "${Red}Error: Source Directory not found.${Reset}"
	return 1
	fi

	if [ ! -d "$Backup_Dir" ]
	then echo -e "${Red}Error: Backup Directory not found.${Reset}"
	return 1
	fi

	return 0
}

verify_archive(){
	Archive_Path="$Backup_Dir/$Archive_Name"

	if [ ! -f "$Archive_Path" ]
	then echo -e "${Red}Error: Backup Archive not found.${Reset}"
	return 1
	fi

	return 0
}

check_integrity(){
	if gzip -t "$Archive_Path" 2>/dev/null
	then return 0
	else
	    echo -e "${Red}Error: Backup archive is corrupted.${Reset}"
	    return 1
	fi
}

extract_archive(){
	Temp_Dir=$(mktemp -d)

	if tar -xzf "$Archive_Path" -C "$Temp_Dir"
	then return 0
	else
	    echo -e "${Red}Error: Failed to extract.${Reset}"
	    return 1
	fi
}

compare_backup(){
	extracted_path="$Temp_Dir/$(basename "$Source_Dir")"

	Comparison_Output=$(diff -qr "$Source_Dir" "$extracted_path")

	Missing_Files=$(echo "$Comparison_Output" | grep -c "Only in $Source_Dir")

	Additional_Files=$(echo "$Comparison_Output" | grep -c "Only in $extracted_path")

	Modified_Files=$(echo "$Comparison_Output" | grep -c "^Files")

	Total_Source_Files=$(find "$Source_Dir" -type f | wc -l)

	Matching_Files=$((Total_Source_Files - Missing_Files - Modified_Files))

	if [ "$Missing_Files" -eq 0 ] &&
      	   [ "$Modified_Files" -eq 0 ] &&
       	   [ "$Additional_Files" -eq 0 ]
    	then
           Verification_Status="Passed"
    	else
           Verification_Status="Failed"
    	fi
}

create_report(){

    	echo "==========================================" > "$rep_file"
    	echo "BACKUP VERIFICATION REPORT" >> "$rep_file"
    	echo "==========================================" >> "$rep_file"

    	echo "Timestamp            : $TimeStamp" >> "$rep_file"
    	echo "Source Directory     : $Source_Dir" >> "$rep_file"
    	echo "Backup Directory     : $Backup_Dir" >> "$rep_file"
    	echo "Archive Name         : $Archive_Name" >> "$rep_file"

    	echo >> "$rep_file"

    	echo "Verification Status  : $Verification_Status" >> "$rep_file"

    	echo "Total Source Files   : $Total_Source_Files" >> "$rep_file"
    	echo "Matching Files       : $Matching_Files" >> "$rep_file"
    	echo "Modified Files       : $Modified_Files" >> "$rep_file"
    	echo "Missing Files        : $Missing_Files" >> "$rep_file"
    	echo "Additional Files     : $Additional_Files" >> "$rep_file"

    	echo >> "$rep_file"

	echo "==========================================" >> "$rep_file"
    	echo "COMPARISON DETAILS" >> "$rep_file"
   	echo "==========================================" >> "$rep_file"

    	if [ -z "$Comparison_Output" ]
    	then
    	    echo "No differences found." >> "$rep_file"
	else
            echo "$Comparison_Output" >> "$rep_file"
	fi

}

create_log(){

   	echo "==========================================" > "$log_file"
    	echo "BACKUP VERIFICATION LOG" >> "$log_file"
    	echo "==========================================" >> "$log_file"

    	echo "Timestamp            : $TimeStamp" >> "$log_file"
    	echo "Verification Status  : $Verification_Status" >> "$log_file"

    	echo "Total Source Files   : $Total_Source_Files" >> "$log_file"
    	echo "Matching Files       : $Matching_Files" >> "$log_file"
    	echo "Modified Files       : $Modified_Files" >> "$log_file"
    	echo "Missing Files        : $Missing_Files" >> "$log_file"
    	echo "Additional Files     : $Additional_Files" >> "$log_file"

}

cleanup(){

    rm -rf "$Temp_Dir"

}

main(){

	setup

	read -p "Enter Source Directory : " Source_Dir
	read -p "Enter Backup Directory : " Backup_Dir
	read -p "Enter Backup Archive Name : " Archive_Name

	verify_inputs || exit 1
	verify_archive || exit 1  #i have used exit here instead of using it every where in each fucntions

	check_integrity || exit 1

	extract_archive || exit 1

	compare_backup

	create_report

	create_log

	echo -e "${Green}Backup verification completed successfully.${Reset}"
	echo "Report : $rep_file"
	echo "Log    : $log_file"

	cleanup

}

main

