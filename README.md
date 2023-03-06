# Run an App using Epinio

In this lab we'll deploy a simple application called [clipboard-backend](https://github.com/mesquitamv/clipboard-backend) using Epinio to interface app with Kubernetes cluster.

## Prerequisites

To execute this environment you'll need:

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [K3D](https://k3d.io/v5.4.7/#installation)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Epinio CLI](https://docs.epinio.io/installation/install_epinio_cli)

## What technologies were used

These technologies were used in this lab to deploy all necessary infrastructure:

- K3S to deploy a kubernetes cluster;
- Cert Manager to provides SSL Certificates for apps;
- NGINX Ingress to act as Kubernetes Ingress ;
- Epinio to interface kubernetes cluster to developer;

## Application to be deployeed

In this lab a simple application was chosen called [clipboard-backend](https://github.com/mesquitamv/clipboard-backend) to demonstrate how push an application on kubernetes cluster using Epinio.

This application was written using Node.js and uses MongoDB as database. Your routes consists:

```bash
GET /clipboard # Gell all data stored on database
```
```bash
POST /clipboard # Store single text on database

Example of data: 
{
	"content":"qwertyasdfgzxcvb12345"
}
```

## Deploy K3D + Epinio + App

For deploy the lab environment in your desktop you must be in *epinio* folder located on root of this repository:

```bash
cd epinio
```

Run the following command:

``` bash
make deploy
```

This command will deploy a K3S Cluster and deploy Cert Manager, NGINX Ingress, Epinio and the example app with your MongoDB configured. 

To get Epinio and app endpoints use:

```bash
kubectl get ingress -A
```

And the output will look like:

```bash
NAMESPACE   NAME                        CLASS   HOSTS                                               ADDRESS                PORTS     AGE
epinio      dex                         nginx   auth.<IP of Loadbalancer>.omg.howdoi.website        <IP of Loadbalancer>   80, 443   xxx
epinio      epinio                      nginx   epinio.<IP of Loadbalancer>.omg.howdoi.website      <IP of Loadbalancer>   80, 443   xxx
workspace   rclipboard-clipboardxxxxx   nginx   clipboard.<IP of Loadbalancer>.omg.howdoi.website   <IP of Loadbalancer>   80, 443   xxx
```

Username and password of epinio interface will be *admin* and *password* respectively

To test app, you can execute the following command:

```bash
curl -X GET https://clipboard.<IP of Loadbalancer>.omg.howdoi.website/clipboard --insecure
```

And an empty json *[]* will be returned.

To load the app, use this command:

```bash
make load-clipboard-backend
```

This command will call app API to post random values on MongoDB.

To check if app load executed with success you can access clipboard endpoint again:

```bash
curl -X GET https://clipboard.<IP of Loadbalancer>.omg.howdoi.website/clipboard --insecure
```

And the output will look like:

```json
[{"_id":"6401392fc74960baf9d7a9b7","content":"31130","__v":0},{"_id":"64013930c74960baf9d7a9b9","content":"25131","__v":0},{"_id":"64013930c74960baf9d7a9bb","content":"20945","__v":0},{"_id":"64013930c74960baf9d7a9bd","content":"10223","__v":0},{"_id":"64013930c74960baf9d7a9bf","content":"10694","__v":0},{"_id":"64013930c74960baf9d7a9c1","content":"8902","__v":0},{"_id":"64013930c74960baf9d7a9c3","content":"8496","__v":0} ...]
```

# Undeploy

To undeploy the environment including K3D cluster, Epinio and Clipboard app use the following command:

```bash
make undeploy
```

# Makefile functions

You can call individually these functions:

```bash
make deploy                     # Deploy all environment
make undeploy                   # Undeploy all environment
make deploy-k3d                 # Deploy K3d Cluster
make init-helm                  # Add all necessary Helm repos
make deploy-k8s-infraservice    # Deploy NGINX Ingress and Cert Manager on current k8s context
make deploy-cert-manager        # Deploy Cert Manager on current k8s context
make deploy-ingress-nginx       # Deploy NGINX Ingress on current k8s context
make deploy-epinio              # Deploy Epinio on current k8s context
make epinio-login               # Execute login on Epinio
make deploy-epinio-service      # Deploy MongoDB service from Epinio Catalog
make create-clipboard-manifest  # Create clipboard app Manifest
make delete-clipboard-manifest  # Delete clipboard app Manifest
make deploy-clipboard-backend   # Deploy clipboard app Manifest using Epinio
make load-clipboard-backend     # Execute load on clipboard app
```