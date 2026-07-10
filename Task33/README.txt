Task 33 : Backup Verification Utility

Description
-----------
This Bash script verifies a backup archive by extracting it into a temporary
directory and comparing it with the source directory. It generates a detailed
verification report and an activity log.

Prerequisites
-------------
- Linux Operating System
- tar
- gzip
- diff

How to Run
----------
1. Give execute permission:
   chmod +x Task33.sh

2. Run:
   ./Task33.sh

Features
--------
- Verify source and backup directories.
- Verify backup archive existence.
- Check archive integrity.
- Extract archive into a temporary directory.
- Compare extracted files with the source directory.
- Detect missing, modified and additional files.
- Generate verification report.
- Create activity log.
- Remove temporary directory after verification.

Output
------
Report:
../reports/backup_verification_report.txt

Log:
../logs/backup_verification.log

Author
------
Jivesh Upadhyay
