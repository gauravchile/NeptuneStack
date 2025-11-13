#!/bin/bash

NAME="$1"

# Pattern without quotes
OLD_WEB="<docker-username>/neptune-web"
OLD_API="<docker-username>/neptune-api"

NEW_WEB="${NAME}/neptune-web"
NEW_API="${NAME}/neptune-api"

# Dev overlay
sed -i "s#${OLD_WEB}#${NEW_WEB}#g" k8s/overlays/dev/kustomization.yaml
sed -i "s#${OLD_API}#${NEW_API}#g" k8s/overlays/dev/kustomization.yaml

# Prod overlay
sed -i "s#${OLD_WEB}#${NEW_WEB}#g" k8s/overlays/prod/kustomization.yaml
sed -i "s#${OLD_API}#${NEW_API}#g" k8s/overlays/prod/kustomization.yaml

# Base frontend
sed -i "s#${OLD_WEB}#${NEW_WEB}#g" k8s/base/frontend/deployment.yaml
sed -i "s#${OLD_API}#${NEW_API}#g" k8s/base/frontend/deployment.yaml

# Base backend
sed -i "s#${OLD_WEB}#${NEW_WEB}#g" k8s/base/backend/deployment.yaml
sed -i "s#${OLD_API}#${NEW_API}#g" k8s/base/backend/deployment.yaml

