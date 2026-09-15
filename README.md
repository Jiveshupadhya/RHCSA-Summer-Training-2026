# RHCSA Summer Training 2026

A collection of **Bash shell scripts for Linux system administration**,
developed as part of the **RHCSA Summer Training 2026** programme at
Lovely Professional University.

The repository contains five practical Linux administration utilities
covering system updates, software inventory, patch management, backup
verification, and automated backup and restoration.

## 📌 Project Overview

The project applies Linux administration concepts through practical Bash
scripting.

Key areas covered:

-   Linux package management
-   Bash shell scripting
-   File and directory management
-   Software update and patch management
-   Backup creation and verification
-   SHA-256 checksum verification
-   Archive and compression operations
-   Logging and report generation
-   Error handling
-   Cron-based automation

## 📂 Project Structure

``` text
RHCSA-Summer-Training-2026/
├── Task4/
├── Task17/
├── Task30/
├── Task33/
├── Task41/
└── README.md
```

## 🛠️ Tasks

### Task 4 --- System Update Tracker

A Bash utility for monitoring the update status of a Linux system.

**Features** - Detects the available package manager - Supports APT,
DNF, and YUM - Checks for available software updates - Reports installed
and available package counts - Handles systems with no pending updates -
Generates an update report - Maintains an activity log - Can be
scheduled using Cron

**Main tools:** `apt`, `dnf`, `yum`, `dpkg`, `rpm`, `grep`, `awk`,
`date`

### Task 17 --- Software Package Inventory Manager

A package-inventory utility for collecting and reporting installed
software.

**Features** - Detects the package manager - Retrieves installed package
information - Counts installed packages - Checks for available updates -
Searches for specific packages - Generates an inventory report -
Maintains an activity log - Supports scheduled inventory generation

**Main tools:** `dpkg`, `rpm`, `apt`, `dnf`, `yum`, `grep`, `awk`, `wc`

### Task 30 --- Linux Software Update and Patch Management Utility

A menu-driven utility for checking and managing Linux software updates.

**Features** - Detects APT, DNF, or YUM - Displays package-manager
information - Displays installed packages - Checks for available
updates - Requests confirmation before installing updates - Performs
package updates - Checks administrative privileges - Checks network
availability - Generates update reports - Maintains activity logs

**Main tools:** `apt`, `dnf`, `yum`, `dpkg`, `rpm`, `ping`, `grep`,
`awk`

### Task 33 --- Linux Scheduled Backup Verification System

A backup-verification utility that checks whether an archive accurately
represents its source directory.

**Features** - Extracts archives into a temporary directory -
Recursively compares backup contents with the source - Detects missing,
additional, and modified files - Generates verification results -
Maintains verification logs - Cleans up temporary data

**Main tools:** `tar`, `diff`, `mktemp`, `mkdir`, `rm`, `basename`,
`dirname`

### Task 41 --- Linux Automated System Backup and Restore Manager

A complete menu-driven backup and restoration utility.

**Features** - Creates compressed backups - Accepts one or more source
directories - Views available backups - Verifies backup integrity -
Generates SHA-256 checksums - Restores verified backups - Restores to a
user-specified location - Manages older backups using a retention
limit - Generates backup reports - Maintains activity logs

**Menu**

``` text
1. Create Backup
2. View Available Backups
3. Verify Backup Integrity
4. Restore Backup
5. Delete Old Backups
6. Generate Backup Report
7. Exit
```

**Main tools:** `tar`, `gzip`, `sha256sum`, `diff`, `mktemp`, `find`,
`du`, `date`, `rm`

## 💻 Technologies & Tools

  Technology / Tool   Purpose
  ------------------- -----------------------------------------
  Linux               Operating-system environment
  Bash                Shell scripting and automation
  APT                 Debian/Ubuntu package management
  DNF                 RPM-based package management
  YUM                 Package management on supported systems
  tar                 Archive creation and extraction
  gzip                Archive compression
  sha256sum           Checksum generation and verification
  diff                Directory/content comparison
  find                File and backup discovery
  du                  Backup size information
  grep                Filtering and searching
  awk                 Command-output processing
  Cron                Task scheduling

## ▶️ Running the Scripts

Clone the repository:

``` bash
git clone https://github.com/Jiveshupadhya/RHCSA-Summer-Training-2026.git
```

Enter the repository:

``` bash
cd RHCSA-Summer-Training-2026
```

Navigate to the required task directory, make the script executable, and
run it:

``` bash
chmod +x <script-name>.sh
./<script-name>.sh
```

> **Note:** Some system-administration operations, especially package
> installation or system-level changes, may require `sudo` privileges.

## 🧪 Testing

The scripts are intended to be executed in a Linux environment and
tested against conditions relevant to each task, including:

-   Package-manager detection
-   Available and unavailable updates
-   Installed package inventory
-   Package searching
-   Update installation with confirmation
-   Insufficient privileges
-   Network availability
-   Backup creation
-   Backup integrity verification
-   Source/backup comparison
-   Backup restoration
-   Backup retention management
-   Report and log generation

## 📊 Reports & Logging

The scripts generate reports and activity logs containing information
relevant to each operation, such as:

-   Execution date and time
-   Operating-system information
-   Package-manager information
-   Installed package counts
-   Available updates
-   Backup information
-   Verification results
-   Installation status
-   Restore status
-   Activity history

## 🎯 Learning Outcomes

This project provided practical experience with:

-   Linux command-line administration
-   Bash scripting
-   Functions and modular script design
-   Conditional statements and loops
-   User input and menu-driven interfaces
-   Command substitution and exit-status handling
-   Package management
-   File and directory operations
-   Archive creation and extraction
-   SHA-256 integrity verification
-   Backup and restoration workflows
-   Logging and report generation
-   Error handling
-   Cron-based automation

## 📚 Project Context

This repository was developed as part of the **RHCSA Summer Training
2026** programme at **Lovely Professional University**.

      Task Project
  -------- ----------------------------------------------------
     **4** System Update Tracker
    **17** Software Package Inventory Manager
    **30** Linux Software Update and Patch Management Utility
    **33** Linux Scheduled Backup Verification System
    **41** Linux Automated System Backup and Restore Manager

The project focuses on applying Linux system-administration concepts
through practical Bash scripting.

## 👤 Author

**Jivesh Upadhyay**

B.Tech --- Computer Science & Engineering\
Lovely Professional University

## 📄 Academic Note

This repository contains work completed as part of an academic
training/project programme and is intended primarily for educational and
demonstration purposes.

Review the source code before running system-administration scripts on
an important machine, especially operations that modify packages,
restore files, or remove older backups.

## 🔗 Repository

[GitHub
Repository](https://github.com/Jiveshupadhya/RHCSA-Summer-Training-2026)
<img width="1597" height="783" alt="image" src="https://github.com/user-attachments/assets/8ff0917f-86f0-4bae-8e85-485716d45778" />
