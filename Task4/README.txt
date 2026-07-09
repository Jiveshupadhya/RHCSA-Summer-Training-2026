RHCSA Summer Training
Task 4 - System Update Tracker

Author:
Name: Jivesh Upadhyay
Registration No.: 12412627

Objective:
This Bash script checks the system for available package updates, generates a report, maintains a timestamped log file, and supports multiple Linux package managers (APT, DNF, and YUM).

Prerequisites:

Before running the script, refresh the package metadata using the appropriate command:

Ubuntu/Debian:
sudo apt update

RHEL/Fedora:
sudo dnf makecache

CentOS:
sudo yum makecache

This ensures the script checks against the latest package information available from the repositories.


Directory Structure:
backup/
logs/
reports/
scripts/

How to Run:
1. Give execute permission:
   chmod +x task4.sh

2. Run the script:
   ./task4.sh

Features:
- Detects operating system and package manager
- Checks available updates
- Counts installed packages
- Generates update report
- Creates timestamped log
- Displays colored terminal output
- Automatically creates required directories

Output Files:
- reports/update_report.txt
- logs/system_update_tracker.log

Commands Used:
source, command, mkdir, date, grep, awk, wc, cat, apt, dnf, yum
