#!/bin/bash

NAME="$1"

# Pattern without quotes
OLD="<docker-username>"

NEW="${NAME}"

# Dev overlay
sed -i "s#${OLD}#${NEW}#g" k8s/overlays/dev/kustomization.yaml

# Prod overlay
sed -i "s#${OLD}#${NEW}#g" k8s/overlays/prod/kustomization.yaml

# Base frontend
sed -i "s#${OLD}#${NEW}#g" k8s/base/frontend/deployment.yaml

# Base backend
sed -i "s#${OLD}#${NEW}#g" k8s/base/backend/deployment.yaml

# Makefile
sed -i "s#${OLD}#${NEW}#g" Makefile
