#!/bin/bash

collect_cpu_usage() {
    echo "Collecting CPU usage..."
    top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4 "%"}'
}

collect_memory_usage() {
    echo "Collecting memory usage..."
    free -h | awk '/^Mem:/ {print "Memory Usage: " $3 "/" $2}'
}

collect_disk_usage() {
    echo "Collecting disk usage..."
    df -h | awk '$NF=="/"{print "Disk Usage: " $3 "/" $2}'
}

collect_top_5_processes() {
    echo "Collecting top 5 processes by CPU usage..."
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

collect_top_5_by_memory_usage() {
    echo "Collecting top 5 processes by Memory usage..."
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
}

echo "Starting server performance stats collection..."


collect_cpu_usage
collect_memory_usage
collect_disk_usage

echo "Server performance stats collection completed."