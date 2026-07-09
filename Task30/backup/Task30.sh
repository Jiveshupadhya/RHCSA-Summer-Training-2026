#!/bin/bash

#dir shortcut
rep_dir="../reports"
log_dir="../logs"

#file shortcut
rep_file="$rep_dir/update_report.txt"
log_file="$log_dir/update_activity.log"


#other variables
TimeStamp=$(date "+%d-%m-%Y %H:%M:%S")

OS_Name=""
Package_Manager=""

Installed_Packages=""
Installed_Count=""

Update_list=""
Update_Count=""

Updated_Packages=""
Installation_Status=""
Upgrade_Output=""

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
	   echo -e "${Red} Unsupported Linux Distribution. ${Reset}"
	     exit 1
	fi
}

display_package_information(){
	echo
	echo -e "${Cyan}==========================================${Reset}"
	echo " Package Manager Information"
 	echo -e "${Cyan}==========================================${Reset}"

	echo -e "Operating System : ${Blue}$OS_Name${Reset}"
	echo -e "Package Manager  : ${Blue}$Package_Manager${Reset}"
}

display_installed_packages(){
	if [ "$Package_Manager" = "apt" ]
	then
	    Installed_Packages=$(dpkg -l | grep ^ii | awk '{print $2,$3,"Installed"}')

	elif [ "$Package_Manager" = "dnf" ] || [ "$Package_Manager" = "yum" ]
	then
	    Installed_Packages=$(rpm -qa --queryformat '%{NAME} %{VERSION} Installed\n')
	fi

	Installed_Count=$(echo "$Installed_Packages" | wc -l)

	echo "Installed Packages:  "
	echo "$Installed_Packages"
	echo
	echo -e "${Yellow}Total Installed Packages:${Reset} $Installed_Count."
}

check_updates(){
	if [ "$Package_Manager" = "apt" ]
	then
	   if apt update -qq >/dev/null 2>&1
	   then echo -e "${Green}Package metadata refreshed.${Reset}"
	   else
	        echo -e "${Yellow}Using cached package information. Requires root access to refresh metadata. ${Reset}"
	   fi
	   Update_list=$(apt list --upgradable 2>/dev/null | grep -i "upgradable from")
	   Update_Count=$(echo "$Update_list" | wc -l)

	elif [ "$Package_Manager" = "dnf" ]
	then
	    if dnf makecache -q >/dev/null 2>&1
	    then echo -e "${Green}Package metadata refreshed.${Reset}"
            else
                 echo -e "${Yellow}Using cached package information. Requires root access to refresh metadata. ${Reset}"
            fi
	    Update_list=$(dnf check-update 2>/dev/null)
            status=$?
                                                        #to manage exit code 100 given by rhel if update is available
            if [ "$status" -eq 100 ] || [ "$status" -eq 0 ]
                then
                    :
                else
                    echo -e "${Red}Error: Unable to check for package updates.${Reset}"
                    exit 1
            fi
            Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}') #check for where number of fields(NF) are 3 then counts it

	elif [ "$Package_Manager" = "yum" ]
        then
	    if yum makecache -q >/dev/null 2>&1
            then echo -e "${Green}Package metadata refreshed.${Reset}"
            else
                 echo -e "${Yellow}Using cached package information. Requires root access to refresh metadata. ${Reset}"
            fi
            Update_list=$(yum check-update)
            Update_Count=$(echo "$Update_list" | awk 'NF==3 {count++} END {print count}')

        fi

	echo -e "${Cyan}==========================================${Reset}"
	echo "Available Updates"
	echo -e "${Cyan}==========================================${Reset}"
	if [ "$Update_Count" -eq 0 ]
	then echo -e "${Green}System is already up to date.${Reset}"
	else
	    echo "$Update_list"
	fi
	echo
	echo -e "${Yellow}Total Available Updates:${Reset} $Update_Count."

}

install_updates(){
	if [ "$EUID" -ne 0 ]  #checking for root
	then
	    echo -e "${Red}Administrative privileges required.${Reset}"
	    return
	fi

	if ping -c 1 8.8.8.8 >/dev/null 2>&1   #checking network only
	then echo
	else
	   echo -e "${Red}Network unavailable.${Reset}"
	   return
	fi

	check_updates

	if [ "$Update_Count" -eq 0 ]
	then
	    echo -e "${Green}System is already up to date.${Reset}"
	    return
	fi

	read -p "Proceed with installing updates? (y/n): " choice

	if [ "$choice" != "y" ] && [ "$choice" != "Y" ]
	then
	    echo -e "${Yellow}Update cancelled.${Reset}"
	    return
	fi

	if [ "$Package_Manager" = "apt" ]
	then Upgrade_Output=$(apt full-upgrade -y 2>&1)
	elif [ "$Package_Manager" = "dnf" ]
	then Upgrade_Output=$(dnf upgrade -y 2>&1)
	elif [ "$Package_Manager" = "yum" ]
	then Upgrade_Output=$(yum update -y 2>&1)
	fi

	status=$?

	if [ "$status" -eq 0 ]
	then
	    Installation_Status="Successful"
	    echo -e "${Green}Updates installed successfully.${Reset}"

	else
	     Installation_Status="Completed with Errors"
	     echo -e "${Yellow}Some updates could not be installed.${Reset}"

	fi

	Updated_Packages="$Update_list"
}

create_report(){
	echo "==========================================" > "$rep_file"
	echo "LINUX SOFTWARE UPDATE REPORT" >> "$rep_file"
	echo "==========================================" >> "$rep_file"

   	echo "Timestamp            : $TimeStamp" >> "$rep_file"
   	echo "Operating System     : $OS_Name" >> "$rep_file"
   	echo "Package Manager      : $Package_Manager" >> "$rep_file"

   	echo "Available Updates    : $Update_Count" >> "$rep_file"
   	echo "Installation Status  : $Installation_Status" >> "$rep_file"

   	echo >> "$rep_file"

   	echo "==========================================" >> "$rep_file"
   	echo "UPDATED PACKAGES" >> "$rep_file"
   	echo "==========================================" >> "$rep_file"

   	echo "$Updated_Packages" >> "$rep_file"

   	echo >> "$rep_file"

   	echo "==========================================" >> "$rep_file"
   	echo "COMMAND OUTPUT" >> "$rep_file"
   	echo "==========================================" >> "$rep_file"

   	echo "$Upgrade_Output" >> "$rep_file"

   	echo
   	echo "Report generated successfully."
}

create_log(){

    echo "==========================================" > "$log_file"
    echo "UPDATE ACTIVITY LOG" >> "$log_file"
    echo "==========================================" >> "$log_file"

    echo "Timestamp            : $TimeStamp" >> "$log_file"
    echo "Operating System     : $OS_Name" >> "$log_file"
    echo "Package Manager      : $Package_Manager" >> "$log_file"

    echo "Available Updates    : $Update_Count" >> "$log_file"
    echo "Installation Status  : $Installation_Status" >> "$log_file"

    echo "==========================================" >> "$log_file"

}

menu(){
	echo -e "${Cyan}==========================================${Reset}"
	echo " Linux Software Update Utility"
        echo -e "${Cyan}==========================================${Reset}"
        echo "1. Display Package Manager Information"
	echo "2. Check for Available Updates"
	echo "3. Display Installed Packages"
	echo "4. Install Available Updates"
	echo "5. Generate Update Report"
	echo "6. Exit"
	echo -e "${Cyan}==========================================${Reset}"
}

main(){

	setup

	detect_package_manager

	while true
	do
	   echo
	   menu

	   read -p "Enter your choice: " choice
	   echo

	   case "$choice" in
	        1)
	           display_package_information
		   ;;

	   	2)
		   check_updates
		   ;;

		3)
		   display_installed_packages
		   ;;

		4)
		   install_updates
		   ;;

		5)
		   check_updates
		   create_report
		   create_log
		   ;;

		6)
		   echo "Exiting..."
		   break
		   ;;

		*)
		   echo -e "${Red}Invalid Choice.${Reset}"
		   ;;

	  esac
	done

}

main
