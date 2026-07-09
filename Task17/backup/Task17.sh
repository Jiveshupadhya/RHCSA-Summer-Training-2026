#!/bin/bash

#Dir shortcut
rep_dir="../reports"
log_dir="../logs"

#file shortcuts
rep_file="$rep_dir/software_inventory_report.txt"
log_file="$log_dir/software_inventory.log"

#other variables
TimeStamp=$(date "+%d-%m-%Y %H:%M:%S")
Package_Manager=""
OS_Name=""

Installed_Packages=""
Installed_Count=""

Search_Package=""
Search_Result=""

Update_list=""
Update_Count=""


#Color
Green="\e[32m"
Red="\e[31m"
Yellow="\e[33m"
Blue="\e[34m"
Cyan="\e[35m"
Reset="\e[0m"


setup(){
	mkdir -p  "$rep_dir"
	mkdir -p  "$log_dir"
}

detect_package_manager(){
	source /etc/os-release
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

get_installed_packages(){
	if [ "$Package_Manager" = "apt" ]
	then
	   Installed_Packages=$(dpkg -l | grep ^ii | awk '{print $2,$3,"Installed"}')
	elif [ "$Package_Manager" = "dnf" ] || [ "$Package_Manager" = "yum" ]
	then
	   Installed_Packages=$(rpm -qa --queryformat '%{NAME} %{VERSION} Installed\n')
	fi

	Installed_Count=$(echo "$Installed_Packages" | wc -l)
}

search_package(){
	read -p "Enter the Package Name : " Search_Package
	Search_Result=$(echo "$Installed_Packages" | grep -iw "$Search_Package")
	if  [ -n "$Search_Result" ]
	then
	    echo
	    echo "Search Result:"
	    echo "----------------------"
	    echo "$Search_Result"
	else
	    echo "Package not Found."
	fi
}

check_updates(){ #code block reused from task4
	if [ "$Package_Manager" = "apt" ]
        then
            Update_list=$(apt list --upgradable 2>/dev/null)
            #Total_Package=$(apt list --installed 2>/dev/null | wc -l)
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
            #Total_Package=$(dnf list installed | wc -l)
            Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}') #check for where number of fields(NF) are 3 then counts it

        elif [ "$Package_Manager" = "yum" ]
        then
            Update_list=$(yum check-update)
            #Total_Package=$(yum list installed | wc -l)
            Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}')

        fi
        TimeStamp=$(date "+%d-%m-%Y %H:%M:%S")
}

create_report(){
	echo "==========================================" > "$rep_file"
	echo "SOFTWARE PACKAGE INVENTORY REPORT" >> "$rep_file"
	echo "==========================================" >> "$rep_file"
	echo "TimeStamp           : $TimeStamp"  >> "$rep_file"
	echo "Operating System    : $OS_Name"    >> "$rep_file"
	echo "Package Manager     : $Package_Manager" >> "$rep_file"
	echo "Installed Packages  : $Installed_Count" >> "$rep_file"
	echo "Available Updates   : $Update_Count"   >>  "$rep_file"
	echo >> "$rep_file"

	echo "==========================================" >> "$rep_file"
	echo "INSTALLED PACKAGE LIST" >> "$rep_file"
	echo "==========================================" >> "$rep_file"

	echo "$Installed_Packages" >> "$rep_file"
}

create_log(){

   	 echo "==========================================" >> "$log_file"
    	echo "Timestamp          : $TimeStamp" >> "$log_file"
    	echo "Operating System   : $OS_Name" >> "$log_file"
    	echo "Package Manager    : $Package_Manager" >> "$log_file"
    	echo "Installed Packages : $Installed_Count" >> "$log_file"
	echo "Available Updates  : $Update_Count"  >>  "$log_file"
    	echo "Inventory Report   : Generated" >> "$log_file"
    	echo "==========================================" >> "$log_file"
    	echo >> "$log_file"


}

display(){

    	echo -e "${Cyan}==========================================${Reset}"
    	echo "SOFTWARE PACKAGE INVENTORY"
    	echo -e "${Cyan}==========================================${Reset}"
    	echo "Operating System    : $OS_Name"
    	echo "Package Manager     : $Package_Manager"
    	echo "Installed Packages  : $Installed_Count"
	echo "Available Updates   : $Update_Count"
    	echo
    	echo -e "${Green}Inventory report generated successfully.${Reset}"
    	echo "Detailed package information is stored in:"
    	echo "$rep_file"
	echo -e "${Cyan}==========================================${Reset}"
}

main(){
   	 setup

    	detect_package_manager

    	get_installed_packages

	check_updates

    	display

    	read -p "Do you want to search for a package? (y/n): " choice

	if [ "$choice" = "y" ] || [ "$choice" = "Y" ]
	then search_package

	elif [ "$choice" = "n" ] || [ "$choice" = "N" ]
        then :

        else
           echo "Invalid choice. Skipping search."

	fi

	create_report

	create_log

}

main
