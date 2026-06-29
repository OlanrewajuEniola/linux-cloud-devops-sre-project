#!/bin/bash

echo "Basic Linux Troubleshooting Report"
echo "----------------------------------"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo "Date: $(date)"
echo ""
echo "Disk usage:"
df -h
echo ""
echo "Folder size:"
du -sh .
echo ""
echo "Errors found in app-status.log:"
grep "ERROR" app-status.log
