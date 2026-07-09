RHCSA Summer Training
Task 17 - Software Package Inventory Manager

Author:
Name: Jivesh Upadhyay
Registration No.: 12412627

Objective:
This Bash script automatically detects the Linux distribution and package manager, retrieves information about installed software packages, allows searching for installed packages, optionally checks for available updates, generates an inventory report, and maintains a log file.

Prerequisites:

Refresh the package metadata before running the script.

Ubuntu/Debian:
sudo apt update

RHEL/Fedora:
sudo dnf makecache

CentOS:
sudo yum makecache

Directory Structure:

backup/
scripts/
reports/
logs/

How to Run:

1. Give execute permission:
chmod +x Task17.sh

2. Run the script:
./Task17.sh

Features:

- Detects operating system automatically
- Detects package manager (APT, DNF, YUM)
- Retrieves installed package information
- Displays package name, version and installation status
- Counts total installed packages
- Searches for a specific installed package
- Optionally identifies available updates
- Generates inventory report
- Creates log file
- Displays colored terminal output
- Automatically creates required directories

-Search Feature:

After generating the inventory report, the user is asked whether they want to search for a specific installed package.
If selected, the script displays the package information if it exists.

Output Files:

- reports/software_inventory_report.txt
- logs/software_inventory.log

Commands Used:

source
command
mkdir
date
dpkg
rpm
grep
awk
wc
echo
cat
apt
dnf
yum
