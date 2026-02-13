#!/bin/bash

# ==============================================================================
# PROJECT B-612: Automated Health Check & Self-Healing Script
# ------------------------------------------------------------------------------
# DESCRIPTION:
# This script monitors the status of Docker containers (TeamSpeak & Playit).
# If a service is down, it triggers a restart and logs the event.
#
# CRONTAB AUTOMATION (How to install):
# 1. Open crontab editor: crontab -e
# 2. Add the following line to run every hour:
#    00 * * * * /bin/bash /path/to/your/asteroid-b612/scripts/healthcheck.sh
# ==============================================================================

# Define the log path for documentation
LOG_FILE="/home/your-user/asteroid-b612/scripts/check.log"
COMPOSE_FILE="/home/your-user/asteroid-b612/services/teamSpeak/docker-compose.yml"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Checking the state of TeamSpeak service..." >> $LOG_FILE

# Verify if the TeamSpeak's container is running
if [ "$(docker ps -q -f name=ts-server)" ]; then
    echo "TeamSpeak: Online" >> $LOG_FILE
else
    echo "TeamSpeak: Offline - Restarting..." >> $LOG_FILE
    # Command to restart if is offline
    /usr/local/bin/docker-compose -f "$COMPOSE_FILE" up -d >> "$LOG_FILE" 2>&1
fi

echo "------------------------------------------------" >> $LOG_FILE