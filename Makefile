deploy-epinio:
	$(MAKE) deploy-k3d
	$(MAKE) init-helm
	$(MAKE) deploy-k8s-infraservice
	$(MAKE) deploy-epinio
	$(MAKE) epinio-login
	

undeploy-epinio:
	k3d cluster delete epinio-dev

deploy-k3d:
	K3D_FIX_DNS=1 k3d cluster create --config k3d/epinio-k3d-config.yml

init-helm:
	helm repo add jetstack https://charts.jetstack.io
	helm repo add epinio https://epinio.github.io/helm-charts
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update

deploy-k8s-infraservice:
	$(MAKE) deploy-ingress-nginx
	$(MAKE) deploy-cert-manager
	
deploy-cert-manager:
	kubectl create namespace cert-manager
	helm install cert-manager --namespace cert-manager jetstack/cert-manager \
		--set installCRDs=true \
		--set extraArgs={--enable-certificate-owner-ref=true}

deploy-ingress-nginx:
	helm install ingress-nginx ingress-nginx/ingress-nginx \
		--namespace ingress-nginx \
		--create-namespace \
		--values helm/ingress-nginx/values-ingress-nginx.yml

deploy-epinio:
	helm install epinio -n epinio \
		--create-namespace epinio/epinio \
		--values helm/epinio/values-epinio.yml \
		--set global.domain=`kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath={@.status.loadBalancer.ingress} | jq -r .[].ip`.omg.howdoi.website

epinio-login:
	epinio login -u admin https://epinio.`kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath={@.status.loadBalancer.ingress} | jq -r .[].ip`.omg.howdoi.website -p password --trust-ca
