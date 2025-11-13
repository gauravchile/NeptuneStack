#!/bin/bash

SERVICE_NAME="neptune-port-forward@"
USER_NAME=$(whoami)

echo "[INFO] Stopping Neptune port-forward service for user: $USER_NAME"

sudo systemctl stop "${SERVICE_NAME}${USER_NAME}"
sudo systemctl disable "${SERVICE_NAME}${USER_NAME}"

echo "[INFO] Removing systemd service template..."
sudo rm -f /etc/systemd/system/neptune-port-forward@.service

sudo systemctl daemon-reload

echo "[INFO] Neptune port-forward service removed successfully."

