# Neptune Stack - Kubernetes Project
# Build, Push, and Deploy Automation for Local + Remote Clusters

REG ?= <docker-username>
APP_API = $(REG)/neptune-api
APP_WEB = $(REG)/neptune-web

.PHONY: build push apply-dev apply-prod clean secrets namespace

## 🔨 Build Docker Images
build:
	docker build -t $(APP_API) ./app/backend
	docker build -t $(APP_WEB) ./app/frontend


## Test Locally
compose:
	docker compose up -d --build


## 🚀 Push Images to Registry
push:
	docker push $(APP_API)
	docker push $(APP_WEB)


##  Installing kubectl
kind:
	curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
	chmod +x kind
	sudo mv kind /usr/local/bin/

##  Create Cluster
create:
	kind create cluster --name neptune

## 🧱 Create Namespace
namespace:
	kubectl apply -f k8s/base/namespace.yaml

## 🔐 Apply Secrets
secrets:
	kubectl -n neptune apply -f k8s/base/secret-app.yaml

## 🧩 Deploy Development Environment
apply-dev: namespace secrets
	kubectl apply -k k8s/overlays/dev

## 🌐 Deploy Production Environment
apply-prod: namespace secrets
	kubectl apply -k k8s/overlays/prod

### 8️⃣ Validate Deployment
validate:
	kubectl -n neptune get pods,svc,ingress,hpa,pdb

## 🧹 Cleanup All Resources
clean:
	kubectl delete ns neptune --ignore-not-found

## 🔍 Check All Resources
status:
	kubectl -n neptune get all

