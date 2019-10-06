OWNER   = punkerside
PROJECT = eks
ENV     = demo

AWS_REGION = us-east-1
AWS_DOMAIN = punkerside.com

NODE_VER = 1.14
NODE_DES = 3
NODE_MIN = 1
NODE_MAX = 10

init:
	@export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/ && terraform init

apply:
	@export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/ && terraform apply \
	  -var 'owner=$(OWNER)' \
	  -var 'project=$(PROJECT)' \
	  -var 'env=$(ENV)' \
	  -var 'node_ver=$(NODE_VER)' \
	  -var 'node_des=$(NODE_DES)' \
	  -var 'node_min=$(NODE_MIN)' \
	  -var 'node_max=$(NODE_MAX)' \
	-auto-approve

kubeconfig:
	$(eval NODE_ROLE = $(shell cd terraform/ && terraform output role))
	@rm -rf ~/.kube/
	@aws eks --region $(AWS_REGION) update-kubeconfig --name $(OWNER)-$(ENV)
	@export NODE_ROLE=$(NODE_ROLE) && envsubst < scripts/aws-auth-cm.yaml | kubectl apply -f -

addon-dashboard:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
	@kubectl apply -f scripts/eks-admin-service-account.yaml

addon-metrics:
	@mkdir -p tmp/ && rm -rf tmp/metrics-server/ && cd tmp/ && git clone https://github.com/kubernetes-incubator/metrics-server.git
	@kubectl create -f tmp/metrics-server/deploy/1.8+/

addon-ingress:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
	@kubectl apply -f scripts/service-l7.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/patch-configmap-l7.yaml

addon-autoscaler:
	@kubectl apply -f scripts/cluster-autoscaler-autodiscover.yaml

addon-cloudwatch:
	@curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/$(OWNER)-$(ENV)/;s/{{region_name}}/$(AWS_REGION)/" | kubectl apply -f -

config-dns:
	@sh scripts/config-dns.sh $(OWNER) $(PROJECT) $(ENV) $(AWS_REGION) $(AWS_DOMAIN)

deploy-guestbook:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-controller.json
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-service.json
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-controller.json
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-service.json
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-controller.json
	@kubectl apply -f guestbook/service.json
	@export AWS_DOMAIN=$(AWS_DOMAIN) && envsubst < guestbook/ingress.yaml | kubectl apply -f -

deploy-stress:
	@kubectl apply -f stress/service.yaml
	@kubectl apply -f stress/hpa.yaml
	@export AWS_DOMAIN=$(AWS_DOMAIN) && envsubst < stress/ingress.yaml | kubectl apply -f -

quickstart:
	@make init
	@make apply
	@make kubeconfig
	@make addon-dashboard
	@make addon-metrics
	@make addon-ingress
	@make addon-autoscaler
	@make deploy-guestbook

validation:
	@echo "Validando Nodos"
	@kubectl get nodes
	@echo "Validando servicios"
	@kubectl get svc

destroy:
	@export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/ && terraform destroy \
	  -var 'owner=$(OWNER)' \
	  -var 'project=$(PROJECT)' \
	  -var 'env=$(ENV)' \
	  -var 'node_ver=$(NODE_VER)' \
	  -var 'node_des=$(NODE_DES)' \
	  -var 'node_min=$(NODE_MIN)' \
	  -var 'node_max=$(NODE_MAX)' \
	-auto-approve

tmps:
	@rm -rf terraform/.terraform.tfstate.lock.info
	@rm -rf terraform/.terraform/
	@rm -rf terraform/terraform.tfstate
	@rm -rf terraform/terraform.tfstate.backup
	@rm -rf tmp/