#!/bin/bash

SERVICE_NAME="neptune-port-forward@"
TEMPLATE_SRC="infra/systemd/neptune-port-forward@.service"
TEMPLATE_DST="/etc/systemd/system/neptune-port-forward@.service"

USER_NAME=$(whoami)
KUBECTL_PATH=$(which kubectl)

echo "[INFO] Installing Neptune port-forward systemd service for user: $USER_NAME"

if [[ -z "$KUBECTL_PATH" ]]; then
    echo "[ERROR] kubectl not found in PATH. Install kubectl first."
    exit 1
fi

echo "[INFO] Using kubectl path: $KUBECTL_PATH"

# Copy template into systemd
sudo cp "$TEMPLATE_SRC" "$TEMPLATE_DST"

# Reload systemd
sudo systemctl daemon-reload

# Enable + start the service instance
sudo systemctl enable "${SERVICE_NAME}${USER_NAME}"
sudo systemctl restart "${SERVICE_NAME}${USER_NAME}"

echo "[INFO] Service started:"
sudo systemctl status "${SERVICE_NAME}${USER_NAME}" --no-pager

