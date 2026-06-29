
## Linux Troubleshooting Mini Lab

Created a basic Linux troubleshooting lab to practise log investigation, disk checks, permissions, and shell scripting.

### Skills practised

- Created and reviewed application log files
- Used `grep` to find `ERROR`, `WARNING`, and database-related log entries
- Used `grep -n` to show matching lines with line numbers
- Used `grep -v` to filter out unwanted log entries
- Used `df -h` to check filesystem disk usage
- Used `du -sh .` to check folder size
- Created a Bash troubleshooting script
- Made the script executable with `chmod +x`
- Ran the script using `./troubleshoot.sh`

### What the script does

The `troubleshoot.sh` script generates a basic troubleshooting report showing:

- Current user
- Current directory
- Date and time
- Disk usage
- Folder size
- Errors found inside `app-status.log`

### Why this matters

This lab demonstrates a practical Linux troubleshooting workflow. It shows how common Linux commands can be combined to investigate application issues, check system state, and automate repeated checks using a shell script.
