#!/bin/bash

declare -a Source_Dir

#dir shortcut
rep_dir="../reports"
log_dir="../logs"
checksum_dir="../checksums"
backup_dir="../backup"

#file shortcut
rep_file="$rep_dir/backup_manager_report.txt"
log_file="$log_dir/backup_manager.log"

#variables
Backup_Name=""
Backup_Path=""
Checksum_File=""
Restore_Dir=""
TimeStamp=""
Backup_size=""
Total_backup=0
Verification_Status=""
Restore_Status=""
Retention_limit=5


#color


setup(){
	mkdir -p "$rep_dir"
	mkdir -p "$log_dir"
	mkdir -p "$checksum_dir"
	mkdir -p "$backup_dir"

}

create_backup(){
	read -a Source_Dir -p "Enter the directory (space separated): "
	if [ "${#Source_Dir[@]}" -eq 0 ]
	then
	   echo "No directory entered."
           return
	fi

	for dir in "${Source_Dir[@]}"
	do
	   if [ ! -d "$dir" ]
	   then echo "Directory '$dir' doesn't exits."
	      return
	   fi
	done

	TimeStamp=$(date "+%Y%m%d_%H%M%S")

	Backup_Name="backup_$TimeStamp.tar.gz"

	Backup_Path="$backup_dir/$Backup_Name"

	Tar_args=()

	for dir in "${Source_Dir[@]}"
    	do
           Tar_args+=(
               -C "$(dirname "$dir")"
               "$(basename "$dir")"
           )
    	done

	tar -czf "$Backup_Path" "${Tar_args[@]}"

	status=$?

	if [ "$status" -ne 0 ]
	then echo "Backup creation failed."
	   return
	fi

	Checksum_File="$checksum_dir/$Backup_Name.sha256"

	sha256sum "$Backup_Path" > "$Checksum_File"

	Backup_size=$(du -h "$Backup_Path" | cut -f1) #only extracting human readable size and unit

	create_log

    	echo
    	echo "Backup created successfully."
    	echo "Backup Name : $Backup_Name"
    	echo "Backup Size : $Backup_size"
}

view_backup(){
	if [ -z "$(ls -A "$backup_dir")" ]
	then echo "Backup is empty."
	return
	fi

	echo "=========================================="
    	echo "Available Backups"
    	echo "=========================================="

	ls "$backup_dir"
}

verify_backup(){
	Verification_Status="Failed"


	if [ -z "$(ls -A "$backup_dir")" ]
	then echo "No backup Available."
	return
	fi

	ls "$backup_dir"

	read -p "Enter backup name: " Backup_Name

	Backup_Path="$backup_dir/$Backup_Name"
	Checksum_File="$checksum_dir/$Backup_Name.sha256"

	if [ ! -f "$Backup_Path" ]
	then
	   echo "Backup not found"
	return
	fi

	if [ ! -f "$Checksum_File" ]
	then
	   echo "Checksum file not found"
	return
	fi

	current_dir=$(pwd)

	cd "$backup_dir"  #to check check we have to be in that directory

	sha256sum -c "../checksums/$Backup_Name.sha256"  >/dev/null 2>&1

	status=$?

	cd "$current_dir"

	if [ "$status" -eq 0 ]
    	then
           Verification_Status="Successful"
           echo "Backup verification successful."
    	else
           Verification_Status="Failed"
           echo "Backup verification failed."
    	fi

	create_log
}

restore_backup(){
	verify_backup

	if [ "$Verification_Status" = "Failed" ]
	then return
	fi

	read -p "Enter Restore Directory: " Restore_Dir

	if [ ! -d "$Restore_Dir" ]
	then echo "Directory not found."
	   return
	fi

	 tar -xzf "$Backup_Path" -C "$Restore_Dir"

    	status=$?

    	if [ "$status" -eq 0 ]
    	then
           Restore_Status="Successful"
	   create_log
           echo "Backup restored successfully."
    	else
           Restore_Status="Failed"
	   create_log
           echo "Restore failed."
           return
    	fi


}


delete_old_backup(){
	if [ -z "$(ls -A "$backup_dir")" ]
	then
	   echo "No backup found."
	   return
	fi

	read -p "Enter number of latest backups to keep(numeric value): " Retention_limit

	Total_backup="$(ls "$backup_dir" | wc -l)"

	if [ "$Total_backup" -le "$Retention_limit" ]
	then echo "No old backups to delete."
	   return
	fi

	Delete_count=$((Total_backup-Retention_limit))

	for Backup_Name in $(ls -tr "$backup_dir" | head -n "$Delete_count")
	do
	   rm "$backup_dir/$Backup_Name"
	   rm "$checksum_dir/$Backup_Name.sha256"
	done

	create_log

	echo "$Delete_count old backups deleted successfully"

}

create_report(){

    	Total_backup=$(ls "$backup_dir" | wc -l)

    	if [ "$Total_backup" -eq 0 ]
    	then
           echo "No backups available."
           return
    	fi

    	TimeStamp=$(date "+%d-%m-%Y %I:%M:%S %p")

    	Latest_Backup=$(ls -t "$backup_dir" | head -n 1)

    	Latest_Backup_Size=$(du -h "$backup_dir/$Latest_Backup" | cut -f1)

    	echo "==========================================" > "$rep_file"
    	echo "         Backup Manager Report" >> "$rep_file"
    	echo "==========================================" >> "$rep_file"
    	echo "Generated On        : $TimeStamp" >> "$rep_file"
    	echo "Total Backups       : $Total_backup" >> "$rep_file"
    	echo "Latest Backup       : $Latest_Backup" >> "$rep_file"
    	echo "Latest Backup Size  : $Latest_Backup_Size" >> "$rep_file"
    	echo "Verification Status : $Verification_Status" >> "$rep_file"
    	echo "Restore Status      : $Restore_Status" >> "$rep_file"
   	echo "Retention Limit     : $Retention_limit" >> "$rep_file"

    	echo "Report generated successfully."

}


create_log(){

    	TimeStamp=$(date "+%d-%m-%Y %I:%M:%S %p")

    	echo "==========================================" >> "$log_file"
    	echo "Time : $TimeStamp" >> "$log_file"
    	echo "Backup : $Backup_Name" >> "$log_file"
    	echo "Verification Status : $Verification_Status" >> "$log_file"
    	echo "Restore Status : $Restore_Status" >> "$log_file"
    	echo "==========================================" >> "$log_file"

}

menu(){
	clear

	echo "=========================================="
	echo "          BACKUP MANAGER"
	echo "=========================================="
	echo "1. Create Backup"
	echo "2. View Available Backups"
    	echo "3. Verify Backup Integrity"
    	echo "4. Restore Backup"
    	echo "5. Delete Old Backups"
    	echo "6. Generate Report"
    	echo "7. Exit"
    	echo "=========================================="
}

main(){
	setup

	while true
	do
	  menu

	read -p "Enter your choice: " choice

	   case "$choice" in

		1) create_backup ;;
		2) view_backup ;;
		3) verify_backup ;;
		4) restore_backup ;;
		5) delete_old_backup ;;
		6) create_report ;;
		7) echo "Exiting..."
	   	   exit 0 ;;
		*) echo "Invalid Choice."
	 	   ;;
	   esac

	   read -p "Press Enter to continue..."
	done
}

main
