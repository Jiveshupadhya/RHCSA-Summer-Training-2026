Task 30 : Linux Software Update Utility

Description
-----------
This Bash script manages software updates on Linux systems using the available
package manager (APT, DNF or YUM). It provides a menu-driven interface to
display package information, check available updates, install updates,
generate reports and create logs.

Prerequisites
-------------
Refresh package information before checking or installing updates.

Ubuntu / Debian:
sudo apt update

Red Hat / Fedora:
sudo dnf makecache

Older RHEL / CentOS:
sudo yum makecache

How to Run
----------
1. Give execute permission:
   chmod +x Task30.sh

2. Run the script:
   ./Task30.sh

3. To install updates, run with administrative privileges:
   sudo ./Task30.sh

Features
--------
- Detect package manager automatically.
- Display operating system and package manager information.
- Display installed packages.
- Check available updates.
- Install updates after user confirmation.
- Generate update report.
- Create update activity log.
- Handle insufficient privileges and network failures.

Output
------
Report:
reports/update_report.txt

Log:
logs/update_activity.log

Author
------
Jivesh Upadhyay
