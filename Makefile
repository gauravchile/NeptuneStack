# Neptune Stack - Kubernetes Project
# Build, Push, and Deploy Automation for Local + Remote Clusters

REG ?= gauravchile
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
	@echo "Removing old Kubernetes repo..."
	sudo rm -f /etc/apt/sources.list.d/kubernetes.list
	sudo rm -f /usr/share/keyrings/kubernetes-archive-keyring.gpg

	@echo "Adding Kubernetes GPG key..."
	curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
		sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg

	@echo "Adding Kubernetes APT source..."
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
		sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

	@echo "Updating package index..."
	sudo apt update

	@echo "Installing kubectl..."
	sudo apt install -y kubectl

	@echo "kubectl installation complete!"

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

